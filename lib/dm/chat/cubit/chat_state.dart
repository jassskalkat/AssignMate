part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState{}

class ChatLoaded extends ChatState{
  final Stream? snapshot;

  ChatLoaded({required this.snapshot});
}