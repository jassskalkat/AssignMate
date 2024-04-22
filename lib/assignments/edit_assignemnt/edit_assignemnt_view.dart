import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../database/database.dart';
import 'cubit/edit_assignment_cubit.dart';

class EditAssignmentView extends StatelessWidget {
  final String assignmentID;
  const EditAssignmentView({Key? key, required this.assignmentID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("AssignMate"),
        automaticallyImplyLeading: true,
      ),
      body: BlocBuilder<EditAssignmentCubit, EditAssignmentState>(
        builder: (context, state) {
          if(state is EditAssignmentInitial){
            context.read<EditAssignmentCubit>().getGroup(assignmentID);
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is EditAssignmentLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is EditAssignmentLoaded){
            final snapshot = state.snapshot;
            return StreamBuilder(
              stream: snapshot,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: snapshot.data['title'],
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 30),
                          ),
                          textAlign: TextAlign.center,
                          enabled: false,
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Due Date: ${DateTime.parse(snapshot.data['dueDate']).year}"
                                "-${DateTime.parse(snapshot.data['dueDate']).month}"
                                "-${DateTime.parse(snapshot.data['dueDate']).day}",
                            hintStyle: const TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          textAlign: TextAlign.center,
                          enabled: false,
                        ),
                        const SizedBox(height: 5,),
                        const Text("Members: ", style: TextStyle(fontSize: 20),),
                        Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data['members'].length,
                              itemBuilder: (_,i){
                                return ListTile(
                                  title: Text(snapshot.data['members'][i]),
                                  trailing: ElevatedButton(
                                    onPressed: () async{
                                      await Database().removeMember(assignmentID, snapshot.data['members'][i], snapshot.data['group_ID']);
                                    },
                                    child: const Text("Remove"),
                                  ),
                                );
                              },
                          ),
                        ),
                        const Divider(color: Colors.black,),
                        const SizedBox(height: 5,),
                        const Text("Files: ", style: TextStyle(fontSize: 20),),
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data['files'].length,
                            itemBuilder: (_,i){
                              return ListTile(
                                title: Text(snapshot.data['files'][i].toString().substring(0,snapshot.data['files'][i].toString().indexOf("-"))),
                                trailing: ElevatedButton(
                                  onPressed: () async{
                                    await Database().removeFile(assignmentID, snapshot.data['files'][i]);
                                  },
                                  child: const Text("Remove"),
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    final controller = TextEditingController();
                                    return AlertDialog(
                                      title: const Text("Add a mate", textAlign: TextAlign.center,),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: controller,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(color: Colors.grey),
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.grey.shade900),
                                                  borderRadius: BorderRadius.circular(15)
                                              ),
                                              fillColor: Colors.grey.shade200,
                                              filled: true,
                                              hintText: "Mate's Username",
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        ElevatedButton(
                                            onPressed: (){
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                        ElevatedButton(
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

                                              QuerySnapshot querySnapshot = await Database().getUserData(controller.text);
                                              if (querySnapshot.docs.isNotEmpty){
                                                await Database().addMember(assignmentID,controller.text, snapshot.data['group_ID']);
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();

                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const AlertDialog(
                                                        title: Text("Mate has been Added successfully", textAlign: TextAlign.center,),
                                                      );
                                                    }
                                                );
                                              }
                                              else {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const AlertDialog(
                                                        title: Text("There Does not exist a mate with this Username", textAlign: TextAlign.center,),
                                                      );
                                                    }
                                                );
                                              }
                                            },
                                            child: const Text("add")),
                                      ],
                                    );
                                  }
                              );
                            },
                            child: const Text("Add a Member"),
                        ),
                        ElevatedButton(
                            onPressed: () async{
                              final result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf']);
                              if (result == null){
                                return showDialog(context: context, builder: (context){
                                  return const AlertDialog(
                                    title: Text('No File was selected'),
                                  );
                                });
                              }
                              else if(result.files.single.extension! != 'pdf'){
                                return showDialog(context: context, builder: (context){
                                  return const AlertDialog(
                                    title: Text('Invalid File type, The outline must be a pdf'),
                                  );
                                });
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Save changes?"),
                                      content: const Text("Do you want to save the file as the outline?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Discard"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final file = File(result.files.single.path!);
                                            await Database().addMainFile(assignmentID,file);
                                            Navigator.pop(context);

                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return const AlertDialog(
                                                    title: Text("Outline has been saved successfully", textAlign: TextAlign.center,),
                                                  );
                                                }
                                            );
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text("Add/Change Outline")
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              final result = await FilePicker.platform.pickFiles(
                                  allowMultiple: false,
                              );

                              if (result == null){
                                return showDialog(context: context, builder: (context){
                                  return const AlertDialog(
                                    title: Text('No File was selected'),
                                  );
                                });
                              }
                              else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Save changes?"),
                                      content: const Text("Do you want to save the file?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Discard"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            final file = File(result.files.single.path!);

                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  final controller = TextEditingController();
                                                  return AlertDialog(
                                                    title: const Text("File Name", textAlign: TextAlign.center,),
                                                    content: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        TextField(
                                                          controller: controller,
                                                          decoration: InputDecoration(
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: const BorderSide(color: Colors.grey),
                                                              borderRadius: BorderRadius.circular(15),
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.grey.shade900),
                                                                borderRadius: BorderRadius.circular(15)
                                                            ),
                                                            fillColor: Colors.grey.shade200,
                                                            filled: true,
                                                            hintText: "File Name",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                          onPressed: (){
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          },
                                                          child: const Text("Cancel")),
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            if(controller.text.isEmpty){
                                                              return;
                                                            }

                                                            showDialog(
                                                                context: context,
                                                                barrierDismissible: false,
                                                                builder: (context) {
                                                                  return const AlertDialog(
                                                                      title: CircularProgressIndicator()
                                                                  );
                                                                }
                                                            );

                                                            await Database().addFiles(assignmentID,file, controller.text);

                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);

                                                            showDialog(
                                                                context: context,
                                                                builder: (context) {
                                                                  return const AlertDialog(
                                                                    title: Text("File has been saved successfully", textAlign: TextAlign.center,),
                                                                  );
                                                                }
                                                            );
                                                          },
                                                          child: const Text("add")),
                                                    ],
                                                  );
                                                }
                                            );
                                          },
                                          child: const Text("Save"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: const Text("Add Files")
                        ),
                      ],
                    ),
                  );
                }
                else{
                  return Center(child: const CircularProgressIndicator());
                }
              },
            );
          }
          else{
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}