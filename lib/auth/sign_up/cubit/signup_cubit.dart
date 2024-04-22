import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  void trySigningUp(){
    emit(SigningUp());
  }

  void successful(bool success){
    if (success){
      emit(SignedUp());
    }
    else {
      emit(SignupInitial());
    }
  }
}
