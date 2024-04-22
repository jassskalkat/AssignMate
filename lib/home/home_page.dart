import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/calendar_cubit.dart';
import 'home_view.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CalendarCubit>(
          create: (context) => CalendarCubit(),
        ),
      ],
      child: HomeView(),
    );
  }
}