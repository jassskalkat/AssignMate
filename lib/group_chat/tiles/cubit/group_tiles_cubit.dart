import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../database/database.dart';
part 'group_tiles_state.dart';

class GroupTilesCubit extends Cubit<GroupTilesState> {
  GroupTilesCubit() : super(TilesInitial());

  Future<void> getInfo(String id) async{
    emit(TileLoading());
    final snapshot = await Database().getGroupInfo(id);
    final username = await Database().getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    emit(TileLoaded(snapshot: snapshot, currUsername: username));
  }
}
