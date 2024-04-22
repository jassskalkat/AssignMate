import 'dart:io';
import 'package:assign_mate/database/database.dart';
import 'package:assign_mate/routes/route_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';

class EditingProfileView extends StatelessWidget {
  final  Map<String, dynamic> data;
  const EditingProfileView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController bioController = TextEditingController(text: data['bio'] == ''? "Bio: ": data['bio']);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Mate's Profile"),
        automaticallyImplyLeading: true,
      ),
      body: WillPopScope(
        onWillPop: () async {
          final shouldExit = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Changes To your bio will be Discarded'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Stay'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Discard'),
                  ),
                ],
              );
            },
          );
          return shouldExit ?? false;
        },
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 15,),
              CircleAvatar(
                radius: 100,
                child: FullScreenWidget(
                  disposeLevel: DisposeLevel.High,
                  child: data['profilePicUrl'] == "" ?
                  Container(
                    width: 200,
                    height: 200,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey,
                    ),
                    child: const Icon(
                        Icons.account_circle_rounded, size: 150),
                  ) : ClipOval(
                    child: Image.network(
                      data['profilePicUrl'],
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async{
                        final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['png','jpg']);
                        if (result == null){
                          return showDialog(context: context, builder: (context){
                            return const AlertDialog(
                              title: Text('No File was selected'),
                            );
                          });
                        }
                        else if(result.files.single.extension! != 'png' && result.files.single.extension! != 'jpg'){
                          return showDialog(context: context, builder: (context){
                            return const AlertDialog(
                              title: Text('Invalid File type, You can only share pictures of type png or jpg'),
                            );
                          });
                        }
                        else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Save changes?"),
                                content: const Text("Do you want to save the Picture as your profile picture?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Discard"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Center(child: CircularProgressIndicator(),),
                                            );
                                          },
                                      );

                                      final file = File(result.files.single.path!);
                                      await Database().updateUserPic(file);
                                      final email = FirebaseAuth.instance.currentUser!.email!;
                                      final username = await Database().getUsernameFromEmail(email);

                                      Navigator.pop(context);
                                      Navigator.pushNamed(context, RouteGenerator.profilePage, arguments: username);
                                    },
                                    child: const Text("Save"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text("add/change Photo",
                        style: TextStyle(
                            color: Colors.blue),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                color: Colors.grey[300],
                height: 350,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: bioController,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Center(child: CircularProgressIndicator(),),
                          );
                        },
                      );

                      await Database().updateUserBio(bioController.text);
                      final email = FirebaseAuth.instance.currentUser!.email!;
                      final username = await Database().getUsernameFromEmail(email);
                      Navigator.pushNamed(context, RouteGenerator.profilePage, arguments: username);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}