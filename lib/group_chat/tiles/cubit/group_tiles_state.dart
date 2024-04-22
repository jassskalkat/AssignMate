part of 'group_tiles_cubit.dart';

@immutable
abstract class GroupTilesState {}

class TilesInitial extends GroupTilesState {}

class TileLoading extends GroupTilesState{}

class TileLoaded extends GroupTilesState{
  final Stream? snapshot;
  final String currUsername;

  TileLoaded({required this.snapshot, required this.currUsername});
}