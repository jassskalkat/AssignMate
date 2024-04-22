part of 'assignment_view_cubit.dart';

@immutable
abstract class AssignmentViewState {}

class AssignmentViewInitial extends AssignmentViewState {}

class AssignmentLoading extends AssignmentViewState {}

class AssignmentLoaded extends AssignmentViewState {
  final Stream? snapshot;
  AssignmentLoaded({required this.snapshot});
}