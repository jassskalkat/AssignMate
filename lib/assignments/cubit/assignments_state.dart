part of 'assignments_cubit.dart';

@immutable
abstract class AssignmentsState {
  const AssignmentsState();
}

class AssignmentsInitial extends AssignmentsState {}

class CurrentAssignments extends AssignmentsState {}

class PastAssignments extends AssignmentsState {}

class AssignmentsLoading extends AssignmentsState {}

class AssignmentsLoaded extends AssignmentsState {
  final Stream? snapshots;

  const AssignmentsLoaded({required this.snapshots});
}

class AssignmentsInfoLoaded extends AssignmentsState{
  final List<Stream?> assignmentsSnapshots;

  const AssignmentsInfoLoaded({required this.assignmentsSnapshots});
}

