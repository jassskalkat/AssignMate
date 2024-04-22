part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoggingIn extends LoginState {}

class LoggedIn extends LoginState {}
