import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());


  void tryLoggingIn(){
    emit(LoggingIn());
  }

  void successful(bool success){
    if (success){
      emit(LoggedIn());
    }
    else {
      emit(LoginInitial());
    }
  }
}
