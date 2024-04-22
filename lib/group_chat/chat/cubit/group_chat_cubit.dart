import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../database/database.dart';
part 'group_chat_state.dart';

class GroupChatCubit extends Cubit<GroupChatState> {
  GroupChatCubit() : super(GroupChatInitial());

  Future<void> getMessages(String groupID) async{
    emit(GroupChatLoading());
    final snapshot = await Database().getGroupChats(groupID);
    emit(GroupChatLoaded(snapshot: snapshot));
  }
}
