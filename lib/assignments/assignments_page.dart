import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'assignments_view.dart';
import 'cubit/assignments_cubit.dart';


class AssignmentsPage extends StatelessWidget {
  const AssignmentsPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AssignmentsCubit>(
          create: (context) => AssignmentsCubit(),
        ),
      ],
      child: AssignmentsView(),
    );
  }
}
