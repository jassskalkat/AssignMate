part of 'group_chat_cubit.dart';

@immutable
abstract class GroupChatState {}

class GroupChatInitial extends GroupChatState {}

class GroupChatLoading extends GroupChatState{}

class GroupChatLoaded extends GroupChatState{
  final Stream? snapshot;

  GroupChatLoaded({required this.snapshot});
}