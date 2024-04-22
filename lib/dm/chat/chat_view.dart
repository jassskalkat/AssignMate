import 'dart:io';
import 'package:assign_mate/database/database.dart';
import 'package:assign_mate/dm/chat/tile/chat_tile.dart';
import 'package:assign_mate/dm/chat/cubit/chat_cubit.dart';
import 'package:assign_mate/routes/route_generator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../info.dart';

class ChatView extends StatelessWidget {
  final Info info;
  const ChatView({super.key, required this.info});


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
                RouteGenerator.profilePage,
                arguments: info.receiver);
            },
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                child: info.picUrl == '' ?
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueGrey,
                  ),
                  child: const Icon(Icons.account_circle_rounded, size: 45),
                ):
                ClipOval(
                  child: Image.network(
                    info.picUrl,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              const SizedBox(width: 10,),
              Text(info.receiver),
            ],
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if(state is ChatInitial){
            context.read<ChatCubit>().getMessages(info.dmId);
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is ChatLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is ChatLoaded){
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
                            return ChatTile(
                              message: snapshot.data.docs[i]['message'],
                              sender: snapshot.data.docs[i]['sender'],
                              url: snapshot.data.docs[i]['file'],
                              time: snapshot.data.docs[i]["time"].toString(),
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
                                          Database().sendFile(
                                              file,
                                              result.files.single.name,
                                              info.dmId,
                                              info.receiver == info.firstUser? info.secondUser: info.firstUser
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
                                'sender': info.receiver == info.firstUser? info.secondUser: info.firstUser,
                                'time': DateTime.now().millisecondsSinceEpoch
                              };

                              Database().sendMessage(info.dmId, messageMap);
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
            return const Text("Something went wrong");
          }
          },
      ),
    );
  }
}