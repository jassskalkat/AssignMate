import 'package:assign_mate/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/new_entry_cubit.dart';


class NewEntryView extends StatelessWidget {
  const NewEntryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController title = TextEditingController();
    DateTime? dueDate;

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
      body: BlocBuilder<NewEntryCubit, NewEntryState>(
          builder: (context, state) {
            if(state is NewEntryInitial){
              return Column(
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(hintText: "Enter Assignment Name here"),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15,),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2100)
                        );
                        dueDate = pickedDate;
                        context.read<NewEntryCubit>().pickedDate(title.text, dueDate!);
                      },
                      child: const Text("Select a Due Date")
                  ),
                ],
              );
            }
            else if(state is DatePicked){
              dueDate = state.dueDate;
              title.text = state.title;
              return Column(
                children: [
                  TextField(
                    controller: title,
                    decoration: InputDecoration(hintText: title.text.isEmpty ? "Enter Assignment Name here": title.text),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5,),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "${dueDate!.year}-${dueDate!.month}-${dueDate!.day}",
                      hintStyle: const TextStyle(color: Colors.black),
                    ),
                    textAlign: TextAlign.center,
                    enabled: false,
                  ),
                  const SizedBox(height: 15,),
                  ElevatedButton(
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100)
                        );
                        dueDate = pickedDate;
                        context.read<NewEntryCubit>().pickedDate(title.text, dueDate!);
                      },
                      child: const Text("Select a Due Date")
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(title.text.isNotEmpty) {
                          context.read<NewEntryCubit>().create(title.text, dueDate!);
                        }
                      },
                      child: const Text('Create'),
                    ),
                  ),
                ],
              );
            }
            else if(state is NewEntryCreating){
              return const CircularProgressIndicator();
            }
            else if(state is NewEntryCreated){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushNamed(context, RouteGenerator.editAssignmentPage,
                    arguments: state.id);
              });
              title.clear();
              context.read<NewEntryCubit>().reset();
              return const SizedBox.shrink();
            }
            else{
              return const SizedBox.shrink();
            }
          }
      ),
    );
  }
}