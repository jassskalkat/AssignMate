import 'package:assign_mate/dm/cubit/dm_cubit.dart';
import 'package:assign_mate/dm/dm_view.dart';
import 'package:assign_mate/dm/tiles/cubit/dm_tiles_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DMPage extends StatelessWidget {
  const DMPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DmCubit>(
          create: (context) => DmCubit(),
        ),
        BlocProvider<DMTilesCubit>(
          create: (context) => DMTilesCubit(),
        ),
      ],
      child: DMView(),
    );
  }
}
