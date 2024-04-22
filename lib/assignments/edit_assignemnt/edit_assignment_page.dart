import 'package:assign_mate/assignments/edit_assignemnt/cubit/edit_assignment_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'edit_assignemnt_view.dart';

class EditAssignmentPage extends StatelessWidget {
  final String assignmentID;
  const EditAssignmentPage({Key? key, required this.assignmentID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EditAssignmentCubit>(
          create: (context) => EditAssignmentCubit(),
        ),
      ],
      child: EditAssignmentView(assignmentID: assignmentID),//EditAssignmentView(),
    );
  }
}