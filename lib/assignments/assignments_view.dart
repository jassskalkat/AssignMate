import 'package:assign_mate/assignments/cubit/assignments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../routes/route_generator.dart';
import '../bottomNavigation/navigation_bar_view.dart';
import 'package:intl/intl.dart';
import 'package:assign_mate/assignments/helper.dart';

class AssignmentsView extends StatelessWidget {
  const AssignmentsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Assignment> assignments = [];
    List<String> assignmentsIDs = [];

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Assignments"),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<AssignmentsCubit, AssignmentsState>(
            builder: (context, state) {
              if(state is AssignmentsInitial){
                context.read<AssignmentsCubit>().getAssignments();
                return const Center(child:CircularProgressIndicator(),);
              }
              else if(state is AssignmentsLoading){
                return const Center(child:CircularProgressIndicator(),);
              }
              else if(state is AssignmentsLoaded){
                final snapshot = state.snapshots;
                return StreamBuilder(
                    stream: snapshot,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        for(int i = 0; i < snapshot.data["assignments"].length; i++){
                          assignmentsIDs.add(snapshot.data['assignments'][i].toString());
                        }
                        context.read<AssignmentsCubit>().getAssignmentsInfo(assignmentsIDs);
                      }
                      else{
                      }
                      return const Center(child:CircularProgressIndicator(),);
                    },
                );
              }
              else if(state is AssignmentsInfoLoaded) {
                final List<Stream?> assignmentsSnapshots = state.assignmentsSnapshots;

                if(assignmentsSnapshots.isEmpty){
                  context.read<AssignmentsCubit>().change();
                }

                return ListView.builder(
                    itemCount: assignmentsSnapshots.length,
                    itemBuilder: (BuildContext context, int i) {
                      return StreamBuilder(
                        stream: assignmentsSnapshots[i],
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            assignments.add(Assignment(DateTime.parse(snapshot.data['dueDate']), snapshot.data['title'],snapshot.data['assignment_ID']));
                            if(i+1 == assignmentsSnapshots.length){
                              assignments.sort((a, b) => a.dueDate.compareTo(b.dueDate));
                              context.read<AssignmentsCubit>().change();
                            }
                          }
                          return SizedBox.shrink();
                        },
                      );
                    },
                );
              }
              else if(state is CurrentAssignments){
                return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const ElevatedButton(
                              onPressed: null, child: Text('Current')),
                          const Padding(padding: EdgeInsets.only(right: 150.0)),
                          ElevatedButton(
                              child: const Text('Past'),
                              onPressed: () =>
                                  BlocProvider.of<AssignmentsCubit>(context)
                                      .change()),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: assignments.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (assignments[index].dueDate.day.compareTo(DateTime.now().day) < 0) {
                              return Container();
                            }
                            return ListTile(
                              title: Text(assignments[index].assignmentName),
                              subtitle: Text(
                                DateFormat('MM/dd HH:mm').format(assignments[index].dueDate),
                              ),
                              onTap:(){
                                Navigator.pushNamed(context,RouteGenerator.entryPage, arguments: assignments[index].id);
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, bottom: 5),
                            child: FloatingActionButton(
                              onPressed: () {
                                final List<String> assignNames = [];

                                for(int i = 0; i < assignments.length; i++){
                                  assignNames.add(assignments[i].assignmentName);
                                }

                                Navigator.pushNamed(context, RouteGenerator.reminderPage, arguments: assignNames);
                              },
                              child: const Icon(Icons.alarm),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0, bottom: 5),
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pushNamed(context,RouteGenerator.newEntryPage);
                              },
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    ],
                );
              }
              else if(state is PastAssignments){
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            child: const Text('Current'),
                            onPressed: () =>
                                BlocProvider.of<AssignmentsCubit>(context)
                                    .change()),
                        const Padding(padding: EdgeInsets.only(right: 150.0)),
                        const ElevatedButton(
                            onPressed: null, child: Text('Past')),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: assignments.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (assignments[index].dueDate.day.compareTo(DateTime.now().day) >=  0) {
                            return Container();
                          }
                          return ListTile(
                            title: Text(assignments[index].assignmentName),
                            subtitle: Text(
                              DateFormat('MM/dd HH:mm').format(assignments[index].dueDate),
                            ),
                            onTap:(){
                              Navigator.pushNamed(context,RouteGenerator.entryPage, arguments: assignments[index].id);
                            },
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, bottom: 5),
                          child: FloatingActionButton(
                            onPressed: () {
                              final List<String> assignNames = [];

                              for(int i = 0; i < assignments.length; i++){
                                assignNames.add(assignments[i].assignmentName);
                              }

                              Navigator.pushNamed(context, RouteGenerator.reminderPage, arguments: assignNames);
                            },
                            child: const Icon(Icons.alarm),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0, bottom: 5),
                          child: FloatingActionButton(
                            onPressed: () {
                              Navigator.pushNamed(context,RouteGenerator.newEntryPage);
                            },
                            child: const Icon(Icons.add),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
              return SizedBox.shrink();
        }),
        bottomNavigationBar:
            NavigationBarView(NavigationBarView.assignmentsIndex));
  }
}