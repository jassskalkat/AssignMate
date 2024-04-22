part of 'reminder_cubit.dart';

@immutable
abstract class ReminderState {}

class ReminderInitial extends ReminderState {}

class SelectedAssignment extends ReminderState {
  final String selected;

  SelectedAssignment({required this.selected});
}

class SelectedDate extends ReminderState {
  final DateTime selected;

  SelectedDate({required this.selected});
}
