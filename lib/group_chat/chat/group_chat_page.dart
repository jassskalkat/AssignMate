import 'package:assign_mate/group_chat/chat/tile/cubit/group_chat_tile_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'group_chat_view.dart';
import 'cubit/group_chat_cubit.dart';
import 'group_info.dart';

class GroupChatPage extends StatelessWidget {
  final GroupInfo info;
  const GroupChatPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GroupChatCubit>(
          create: (context) => GroupChatCubit(),
        ),
        BlocProvider<GroupChatTileCubit>(
          create: (context) => GroupChatTileCubit(),
        ),
      ],
      child: GroupChatView(info: info,),
    );
  }
}