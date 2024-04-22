import 'package:assign_mate/assignments/reminder/reminder_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/reminder_cubit.dart';

class ReminderPage extends StatelessWidget {
  final List<String> assignments;
  const ReminderPage({super.key, required this.assignments});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReminderCubit>(
          create: (context) => ReminderCubit(),
        ),
      ],
      child: ReminderView(assignments: assignments),
    );
  }
}