part of 'chat_tile_cubit.dart';

@immutable
abstract class ChatTileState {}

class ChatTileInitial extends ChatTileState {}

class UserLoading extends ChatTileState {}

class UserLoaded extends ChatTileState {
  final String user;

  UserLoaded({required this.user});
}