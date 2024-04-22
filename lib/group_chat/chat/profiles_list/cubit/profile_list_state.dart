part of 'profile_list_cubit.dart';

@immutable
abstract class ProfileListState {}

class ProfileListInitial extends ProfileListState {}

class ProfileListLoading extends ProfileListState {}

class ProfileListLoaded extends ProfileListState {
  final Stream? snapshot;

  ProfileListLoaded({required this.snapshot});
}

