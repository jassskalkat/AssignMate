import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


class Database {
  final String? userid;
  Database({this.userid});

  final CollectionReference usersRef =
  FirebaseFirestore.instance.collection("users");

  final CollectionReference DMsRef =
  FirebaseFirestore.instance.collection("DirectMessages");

  final CollectionReference groupChatRef =
  FirebaseFirestore.instance.collection("GroupChat");

  final CollectionReference assignmentsRef =
  FirebaseFirestore.instance.collection("Assignment");

  final FirebaseStorage storage = FirebaseStorage.instance;
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future<void> addUser(String username, String email) {
    return usersRef.doc(username).set({
      'userID': userid,
      'username': username,
      'email': email,
      'profilePicUrl': '',
      'bio': '',
      'assignments': [],
      'DM': [],
      'assignmentsGroups': [],
    });
  }

  Future<void> updateUserBio(String bio) async {
    String username = await getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    return usersRef.doc(username).update({
      'bio': bio,
    });
  }

  Future<void> updateUserPic(File profilePic) async {
    String username = await getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    Reference ref = FirebaseStorage.instance.ref().child('profilePic/$username/');
    UploadTask uploadTask = ref.putFile(profilePic);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return usersRef.doc(username).update({
      'profilePicUrl': downloadUrl,
    });
  }

  Future getUserData(String username) async {
    QuerySnapshot snapshot = await usersRef.where("username", isEqualTo: username).get();
    return snapshot;
  }

  getUserMates(String email) async{
    final username = await getUsernameFromEmail(email);
    return usersRef.doc(username).snapshots();
  }

  getUserAssignments() async{
    final username = await getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    return usersRef.doc(username).snapshots();
  }

  Future<String> getUsernameFromEmail(String email) async {
    final snapshot = await usersRef.where('email', isEqualTo: email).get();
    if (snapshot.docs.isNotEmpty) {
      final username = snapshot.docs.first.get('username');
      return username as String;
    }
    return '';
  }

  Future createDM(String username) async{
    String currUsername = await getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);

    DocumentReference dm = await DMsRef.add({
      "DM_ID": "",
      "messageID": [],
      'members': [],
      'recentMessage': "",
      'recentMessageTime': "",
    });

    await dm.update({
      "DM_ID": dm.id,
      'members': FieldValue.arrayUnion([currUsername, username])
    });

    await usersRef.doc(currUsername).update({
      "DM": FieldValue.arrayUnion([dm.id])
    });

    await usersRef.doc(username).update({
      "DM": FieldValue.arrayUnion([dm.id])
    });
  }

  Future<String> createAssignment(String title, String dueDate) async{
    DocumentReference dr = await assignmentsRef.add({
      "assignment_ID": "",
      "group_ID": "",
      "members": [],
      "files": [],
      "dueDate": dueDate,
      "main pdf": "",
      "title": title,
    });

    String currUsername = await getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);


    String groupID = await createGroupChat(dr.id, [currUsername], title);

    await dr.update({
      "assignment_ID": dr.id,
      "members": [currUsername],
      'group_ID': groupID,
    });

    await usersRef.doc(currUsername).update({
      "assignments": FieldValue.arrayUnion([dr.id]),
      "assignmentsGroups": FieldValue.arrayUnion([groupID]),
    });

    Map<String, dynamic> event = {
      "Name" : "$title DueDate",
      "Date" : DateTime.parse(dueDate),
    };

    await addEvent(currUsername, event);

    return dr.id;
  }

  addMember(String assignmentID, String name, String groupID) async{
    await usersRef.doc(name).update({
      "assignments": FieldValue.arrayUnion([assignmentID]),
      "assignmentsGroups": FieldValue.arrayUnion([groupID]),
    });

    await assignmentsRef.doc(assignmentID).update({
      'members': FieldValue.arrayUnion([name]),
    });

    await groupChatRef.doc(groupID).update({
      'members': FieldValue.arrayUnion([name]),
    });

    final snapshot = await assignmentsRef.where('assignment_ID', isEqualTo: assignmentID).get();
    final title = snapshot.docs.first.get('title');
    final dueDate = snapshot.docs.first.get('dueDate');

    Map<String, dynamic> event = {
      "Name" : "$title DueDate",
      "Date" : DateTime.parse(dueDate),
    };

    await addEvent(name, event);
  }

  addFiles(String id, File file, String title) async{
    Reference ref = FirebaseStorage.instance.ref().child('assignmentsFiles/$id/${file.path.split('/').last}');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    assignmentsRef.doc(id).update({
      "files": FieldValue.arrayUnion(['$title-$downloadUrl']),
    });
  }

  addMainFile(String id, File file) async{
    Reference ref = FirebaseStorage.instance.ref().child('assignmentsOutlines/$id/${file.path.split('/').last}');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    assignmentsRef.doc(id).update({
      "main pdf": downloadUrl,
    });
  }

  removeMember(String assignmentID, String name, String groupID) async{
    await assignmentsRef.doc(assignmentID).update({
      'members': FieldValue.arrayRemove([name])
    });

    await usersRef.doc(name).update({
      'assignments': FieldValue.arrayRemove([assignmentID]),
      'assignmentsGroups': FieldValue.arrayRemove([groupID]),
    });

    await groupChatRef.doc(groupID).update({
      'members': FieldValue.arrayRemove([name]),
    });
  }

  removeFile(String id, String file) async{
    await assignmentsRef.doc(id).update({
      'files': FieldValue.arrayRemove([file])
    });
  }

  Future createGroupChat(String assignmentID, List<String> members, String title) async{
    DocumentReference groupChat = await groupChatRef.add({
      "group_ID": "",
      "messageID": [],
      'members': members,
      'recentMessage': "",
      'recentMessageTime': "",
      'recentMessageSender': "",
      'title': title,
    });

    groupChat.update({
      "group_ID": groupChat.id,
    });

    return groupChat.id;
  }

  getDMchat(String id){
    return DMsRef.doc(id).snapshots();
  }

  getGroupInfo(String groupID){
    return groupChatRef.doc(groupID).snapshots();
  }

  getAssignment(String assignmentID){
    return assignmentsRef.doc(assignmentID).snapshots();
  }

  sendMessage(String dmID, Map<String,dynamic> message){
    DMsRef.doc(dmID).collection("messages").add(message);
    DMsRef.doc(dmID).update({
      'recentMessage': message['message'],
      'recentMessageTime': message['time'].toString()
    });
  }

  sendGroupMessage(String groupID, Map<String,dynamic> message, String sender){
    groupChatRef.doc(groupID).collection("messages").add(message);
    groupChatRef.doc(groupID).update({
      'recentMessage': message['message'],
      'recentMessageTime': message['time'].toString(),
      'recentMessageSender': sender,
    });
  }

  addEvent(String username, Map<String,dynamic> event){
    usersRef.doc(username).collection("events").add(event);
  }

  getEvents(String username) async{
    Map<DateTime, List<String>> events = {};

    await usersRef
        .doc(username)
        .collection("events")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        DateTime date = document.get("Date").toDate();
        String name = document.get("Name");
        if (events[date] == null) {
          events[date] = [name];
        } else {
          events[date]?.add(name);
        }
      });
    });

    return events;
  }


  getChats(String dmId) async {
    return DMsRef
        .doc(dmId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  getGroupChats(String groupId) async{
    return groupChatRef
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  sendFile(File file, String name, String dmID, String sender) async {
    Reference ref = FirebaseStorage.instance.ref().child('dmFiles/$dmID/${file.path.split('/').last}');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> messageMap = {
      'message': "",
      'file': downloadUrl,
      'sender': sender,
      'time': DateTime.now().millisecondsSinceEpoch
    };

    sendMessage(dmID,messageMap);
  }

  groupSendFile(File file, String name, String groupID, String sender) async {
    Reference ref = FirebaseStorage.instance.ref().child('groupFiles/$groupID/${file.path.split('/').last}');
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> messageMap = {
      'message': "",
      'file': downloadUrl,
      'sender': sender,
      'time': DateTime.now().millisecondsSinceEpoch
    };

    sendGroupMessage(groupID,messageMap, sender);
  }

  Future<Map<String, dynamic>> getUserprofile(String username) async {
    final snapshot = await usersRef.where('username', isEqualTo: username).get();
    if (snapshot.docs.isNotEmpty) {
      return {
        'username': username,
        'email': snapshot.docs.first.get('email'),
        'profilePicUrl': snapshot.docs.first.get('profilePicUrl'),
        'bio': snapshot.docs.first.get('bio'),
      };
    } else {
      return {"": ""};
    }
  }

  Future<String> getPicFromDMID(String dmID, String currUser) async {
    QuerySnapshot querySnapshot = await DMsRef.where("DM_ID", isEqualTo: dmID).get();
    if (querySnapshot.docs.isNotEmpty) {
      List<dynamic> members = querySnapshot.docs.first.get('members');
      final snapshot = await usersRef.where('username', isEqualTo: members[0] == currUser? members[1]: members[0]).get();
      return snapshot.docs.first.get('profilePicUrl');
    } else {
      return "";
    }
  }

  Future getPicFromUsername(String username) async{
    final snapshot = await usersRef.where('username', isEqualTo: username).get();
    return snapshot.docs.first.get('profilePicUrl');
  }
}