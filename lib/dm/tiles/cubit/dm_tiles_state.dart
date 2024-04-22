part of 'dm_tiles_cubit.dart';

@immutable
abstract class DMTilesState {}

class DMTilesInitial extends DMTilesState {}

class DMTileLoading extends DMTilesState{}

class DMTileLoaded extends DMTilesState{
  final Stream? snapshot;
  final String currUsername;
  final String picUrl;

  DMTileLoaded({required this.snapshot, required this.currUsername, required this.picUrl});
}