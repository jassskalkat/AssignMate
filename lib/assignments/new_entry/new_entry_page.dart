import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/new_entry_cubit.dart';
import 'new_entry_view.dart';

class  NewEntryPage extends StatelessWidget {
  const NewEntryPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NewEntryCubit>(
          create: (context) => NewEntryCubit(),
        ),
      ],
      child: NewEntryView(),
    );
  }
}