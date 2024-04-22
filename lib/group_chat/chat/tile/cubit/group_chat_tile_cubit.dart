import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../../database/database.dart';

part 'group_chat_tile_state.dart';

class GroupChatTileCubit extends Cubit<GroupChatTileState> {
  GroupChatTileCubit() : super(GroupChatTileInitial());

  Future<void> getuser() async{
    emit(UserLoading());
    final email = FirebaseAuth.instance.currentUser!.email!;
    final username = await Database().getUsernameFromEmail(email);
    emit(UserLoaded(user: username));
  }
}
