import 'package:assign_mate/routes/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'cubit/assignment_view_cubit.dart';


class AssignmentView extends StatelessWidget {
  final String assignmentID;
  const AssignmentView({Key? key, required this.assignmentID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("AssignMate"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, RouteGenerator.assignmentPage);
          },
        ),
      ),
      body: BlocBuilder<AssignmentViewCubit, AssignmentViewState>(
        builder: (context, state) {
          if(state is AssignmentViewInitial){
            context.read<AssignmentViewCubit>().getGroup(assignmentID);
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is AssignmentLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is AssignmentLoaded){
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
                                  title: Text('${i+1}- ${snapshot.data['members'][i]}',textScaleFactor: 1.3,),
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
                                onTap: () {
                                  FileDownloader.downloadFile(
                                    url: snapshot.data['files'][i].toString().substring(snapshot.data['files'][i].toString().indexOf("-")+1),
                                    name: snapshot.data['files'][i].toString().substring(0,snapshot.data['files'][i].toString().indexOf("-")),
                                    onDownloadCompleted: (done) {
                                      showDialog(context: context, builder: (context){
                                        return const AlertDialog(
                                          title: Text("Download Has been completed."),
                                        );
                                      });
                                    },
                                    onDownloadError: (error){
                                      showDialog(context: context, builder: (context){
                                        return const AlertDialog(
                                          title: Text("an Error has occurred"),
                                        );
                                      });
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.pushNamed(context, RouteGenerator.pdfViewer, arguments: snapshot.data['main pdf']);
                            },
                            child: const Text("Open Assignment Outline")
                        )
                      ],
                    ),
                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }
          else{
            return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouteGenerator.editAssignmentPage, arguments: assignmentID);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}