import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../../database/database.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> getUserData(String user) async{
    emit(ProfileLoading());
    final email = FirebaseAuth.instance.currentUser!.email!;
    final currentUser = await Database().getUsernameFromEmail(email);
    final data = await Database().getUserprofile(user);
    emit(ProfileLoaded(data: data, currentUserName: currentUser));
  }
}
