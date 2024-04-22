import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/profile_cubit.dart';
import 'profile_view.dart';

class ProfilePage extends StatelessWidget {
  final String username;
  const ProfilePage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(),
        ),
      ],
      child: ProfileView(profileUsername: username,),
    );
  }
}