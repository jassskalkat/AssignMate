import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../../database/database.dart';

part 'dm_tiles_state.dart';

class DMTilesCubit extends Cubit<DMTilesState> {
  DMTilesCubit() : super(DMTilesInitial());

  Future<void> getInfo(String id) async{
    emit(DMTileLoading());
    final snapshot = await Database().getDMchat(id);
    final username = await Database().getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    final picUrl = await Database().getPicFromDMID(id,username);
    emit(DMTileLoaded(snapshot: snapshot, currUsername: username, picUrl: picUrl));
  }
}
