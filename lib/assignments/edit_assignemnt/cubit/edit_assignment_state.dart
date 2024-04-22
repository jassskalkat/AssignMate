part of 'edit_assignment_cubit.dart';

@immutable
abstract class EditAssignmentState {}

class EditAssignmentInitial extends EditAssignmentState {}

class EditAssignmentLoading extends EditAssignmentState {}

class EditAssignmentLoaded extends EditAssignmentState {
  final Stream? snapshot;
  EditAssignmentLoaded({required this.snapshot});
}