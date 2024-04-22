import 'package:assign_mate/assignments/reminder/cubit/reminder_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/database.dart';

class ReminderView extends StatelessWidget {
  final List<String> assignments;
  const ReminderView({super.key, required this.assignments});

  @override
  Widget build(BuildContext context) {
    String? assignmentSelected;
    DateTime? dateSelected;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Assignments Reminders"),
          automaticallyImplyLeading: true,
        ),
        body: BlocBuilder<ReminderCubit, ReminderState>
          (builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    iconSize: 30,
                    hint: const Text("Select an Assignment"),
                    value: assignmentSelected,
                    onChanged: (newValue){
                      assignmentSelected = newValue;
                      context.read<ReminderCubit>().selectAssignment(newValue!);
                    },
                    items: assignments.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null && picked != dateSelected) {
                        dateSelected = picked;
                        context.read<ReminderCubit>().selectDate(dateSelected!);
                      }
                    },
                    child: const Text('Choose a date'),
                  ),
                  const SizedBox(height: 5,),
                  dateSelected == null ? const Text("") :
                  Text("${dateSelected!.year}-${dateSelected!.month}-${dateSelected!.day}",textScaleFactor: 1.5,),
                  const SizedBox(height: 100,),
                  ElevatedButton(
                      onPressed: () async{
                        if(assignmentSelected != null && dateSelected != null){
                          String username = await Database().getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
                          Map<String, dynamic> event = {
                            "Name" : "${assignmentSelected!} Reminder",
                            "Date" : DateTime(dateSelected!.year,dateSelected!.month, dateSelected!.day),
                          };
                          await Database().addEvent(username, event);

                          showDialog(context: context, builder: (context) {
                            return const AlertDialog(
                              title: Text("A reminder has been set"),
                            );
                          });
                          assignmentSelected = null;
                          dateSelected = null;

                          context.read<ReminderCubit>().reload();
                        }
                        else {
                          showDialog(context: context, builder: (context) {
                            return const AlertDialog(
                              title: Text("Please Select an assignment and a date"),
                            );
                          });
                        }
                      },
                      child: const Text("Set Reminder")
                  ),
                ],
              ),
            );
        },),
    );
  }
}