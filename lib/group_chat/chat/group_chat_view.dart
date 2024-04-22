import 'dart:io';
import 'package:assign_mate/database/database.dart';
import 'package:assign_mate/group_chat/chat/cubit/group_chat_cubit.dart';
import 'package:assign_mate/group_chat/chat/tile/group_chat_tile.dart';
import 'package:assign_mate/routes/route_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'group_info.dart';


class GroupChatView extends StatelessWidget {
  final GroupInfo info;
  const GroupChatView({super.key, required this.info});


  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              RouteGenerator.profileListPage,
              arguments: info.groupID,
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Text(
                  info.title,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<GroupChatCubit, GroupChatState>(
        builder: (context, state) {
          if(state is GroupChatInitial){
            context.read<GroupChatCubit>().getMessages(info.groupID);
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is GroupChatLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is GroupChatLoaded){
            final chats = state.snapshot;
            return Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: chats,
                    builder: (context, AsyncSnapshot snapshot){
                      return snapshot.hasData ? ListView.builder(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          controller: scrollController,
                          itemCount: snapshot.data.docs.length+1,
                          itemBuilder: (context, i){
                            if(i == snapshot.data.docs.length){
                              if (scrollController.position.hasContentDimensions) {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                );
                              }
                              return Container(height: 10,);
                            }
                            return GroupChatTile(
                              message: snapshot.data.docs[i]['message'],
                              sender: snapshot.data.docs[i]['sender'],
                              url: snapshot.data.docs[i]['file'],
                              user: info.currUser,
                              time: snapshot.data.docs[i]['time'].toString(),
                            );
                          }): const Center();
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[400],
                    child: Row(
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
                            else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Send Picture?"),
                                    content: const Text("Do you want to send the picture?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) {
                                                return const AlertDialog(
                                                    title: CircularProgressIndicator()
                                                );
                                              }
                                          );

                                          final file = File(result.files.single.path!);
                                          Database().groupSendFile(
                                              file,
                                              result.files.single.name,
                                              info.groupID,
                                              info.currUser
                                          );

                                          if (scrollController.position.hasContentDimensions) {
                                            scrollController.animateTo(
                                              scrollController.position.maxScrollExtent,
                                              duration: const Duration(milliseconds: 200),
                                              curve: Curves.easeOut,
                                            );
                                          }
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: const Text("send"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.grey[400]
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.attach_file,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: const InputDecoration(
                                hintText: "Message",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        GestureDetector(
                          onTap: (){
                            if(controller.text.isNotEmpty){
                              Map<String, dynamic> messageMap = {
                                'message': controller.text,
                                'file': "",
                                'sender': info.currUser,
                                'time': DateTime.now().millisecondsSinceEpoch
                              };

                              Database().sendGroupMessage(info.groupID, messageMap, info.currUser);
                              controller.clear();
                              if (scrollController.position.hasContentDimensions) {
                                scrollController.animateTo(
                                  scrollController.position.maxScrollExtent,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                );
                              }
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.red
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,),
                        GestureDetector(
                          onTap: (){
                            if (scrollController.position.hasContentDimensions) {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeOut,
                              );
                            }
                          },
                          child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.red
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_downward,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
          else {
            return Text("Something went wrong");
          }
          },
      ),
    );
  }
}