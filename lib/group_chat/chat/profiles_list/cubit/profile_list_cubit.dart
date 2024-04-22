import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../database/database.dart';
part 'profile_list_state.dart';

class ProfileListCubit extends Cubit<ProfileListState> {
  ProfileListCubit() : super(ProfileListInitial());

  Future<void> getGroupInfo(String groupID) async{
    emit(ProfileListLoading());
    final snapshot = await Database().getGroupInfo(groupID);
    emit(ProfileListLoaded(snapshot: snapshot));
  }
}
