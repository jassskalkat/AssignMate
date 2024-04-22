import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../../../database/database.dart';

part 'member_tile_state.dart';

class MemberTileCubit extends Cubit<MemberTileState> {
  MemberTileCubit() : super(MemberTileInitial());

  Future<void> getInfo(String membername) async{
    emit(MemberTileLoading());
    final username = await Database().getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    final picUrl = await Database().getPicFromUsername(membername);
    emit(MemberTileLoaded( currUsername: username, picUrl: picUrl));
  }
}
