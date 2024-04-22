import 'package:assign_mate/database/database.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'group_chat_state.dart';

class DmCubit extends Cubit<DmState> {
  DmCubit() : super(DmInitial());

  Future<void> getMessengers() async{
    emit(DmLoading());
    final email = FirebaseAuth.instance.currentUser!.email!;
    final snapshot = await Database().getUserMates(email);
    emit(DmLoaded(snapshot: snapshot));
  }
}
