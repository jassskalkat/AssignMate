part of 'group_chat_tile_cubit.dart';

@immutable
abstract class GroupChatTileState {}

class GroupChatTileInitial extends GroupChatTileState {}

class UserLoading extends GroupChatTileState {}

class UserLoaded extends GroupChatTileState {
  final String user;

  UserLoaded({required this.user});
}