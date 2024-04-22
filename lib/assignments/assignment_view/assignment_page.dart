import 'package:assign_mate/assignments/assignment_view/cubit/assignment_view_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'assignemnt_view.dart';

class AssignmentPage extends StatelessWidget {
  final String assignmentID;
  const AssignmentPage({Key? key, required this.assignmentID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AssignmentViewCubit>(
          create: (context) => AssignmentViewCubit(),
        ),
      ],
      child: AssignmentView(assignmentID: assignmentID),
    );
  }
}