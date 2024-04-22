import 'package:assign_mate/database/database.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarInitial());

  late final Map<DateTime, List<String>> event;


  Future getEvents() async{
    String username = await Database().getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
    final Map<DateTime, List<String>> snap = await Database().getEvents(username);
    event = snap;
    emit(CalendarMonth(events: snap));
  }

  void updateCalendarFormat() {
    if(state is CalendarMonth){
      emit(CalendarTwoWeeks(event: event));
    }
    else if(state is CalendarTwoWeeks){
      emit(CalendarOneWeek(event: event));
    }
    else if(state is CalendarOneWeek){
      emit(CalendarMonth(events: event));
    }
  }

  void selectDay(DateTime day, DateTime selected, String format){
    emit(SelectedDay(day: day, format:  format, event: event));
  }

}
