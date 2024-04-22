import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../database/database.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  Future<void> getMessages(String dmId) async{
    emit(ChatLoading());
    final snapshot = await Database().getChats(dmId);
    emit(ChatLoaded(snapshot: snapshot));
  }
}
