import 'package:assign_mate/dm/chat/tile/cubit/chat_tile_cubit.dart';
import 'package:assign_mate/dm/info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_view.dart';
import 'cubit/chat_cubit.dart';

class ChatPage extends StatelessWidget {
  final Info info;
  const ChatPage({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatCubit>(
          create: (context) => ChatCubit(),
        ),
        BlocProvider<ChatTileCubit>(
          create: (context) => ChatTileCubit(),
        ),
      ],
      child: ChatView(info: info,),
    );
  }
}