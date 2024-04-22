part of 'group_chat_cubit.dart';

@immutable
abstract class DmState {}

class DmInitial extends DmState {}

class DmLoading extends DmState{}

class DmLoaded extends DmState{
  final Stream? snapshot;

  DmLoaded({required this.snapshot});
}
