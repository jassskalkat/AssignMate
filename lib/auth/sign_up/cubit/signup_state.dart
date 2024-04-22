part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SigningUp extends SignupState {}

class SignedUp extends SignupState {}