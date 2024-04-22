part of 'member_tile_cubit.dart';

@immutable
abstract class MemberTileState {}

class MemberTileInitial extends MemberTileState {}

class MemberTileLoading extends MemberTileState {}

class MemberTileLoaded extends MemberTileState {
  final String currUsername;
  final String picUrl;

  MemberTileLoaded({ required this.currUsername, required this.picUrl});
}
