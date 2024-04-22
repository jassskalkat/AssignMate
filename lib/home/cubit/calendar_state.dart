part of 'calendar_cubit.dart';

@immutable
abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarMonth extends CalendarState {
  final Map<DateTime, List<String>> events;

  CalendarMonth({required this.events});
}

class CalendarTwoWeeks extends CalendarState {
  final Map<DateTime, List<String>> event;

  CalendarTwoWeeks({required this.event});
}

class CalendarOneWeek extends CalendarState {
  final Map<DateTime, List<String>> event;

  CalendarOneWeek({required this.event});
}

class SelectedDay extends CalendarState {
  final DateTime day;
  final String format;
  final Map<DateTime, List<String>> event;

  SelectedDay({required this.day, required this.format, required this.event});
}

class Loading extends CalendarState {}
