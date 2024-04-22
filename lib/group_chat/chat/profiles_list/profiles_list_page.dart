import 'package:assign_mate/group_chat/chat/profiles_list/cubit/profile_list_cubit.dart';
import 'package:assign_mate/group_chat/chat/profiles_list/profiles_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilesListPage extends StatelessWidget {
  final String groupID;
  const ProfilesListPage({Key? key, required this.groupID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileListCubit>(
          create: (context) => ProfileListCubit(),
        ),
      ],
      child: ProfilesListView(groupID: groupID),
    );
  }
}