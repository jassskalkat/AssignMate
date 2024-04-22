import 'package:assign_mate/dm/cubit/dm_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_view.dart';


class GroupPage extends StatelessWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DmCubit>(
          create: (context) => DmCubit(),
        ),
      ],
      child: GroupView(),
    );
  }
}
