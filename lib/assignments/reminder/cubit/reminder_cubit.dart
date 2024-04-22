import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'reminder_state.dart';

class ReminderCubit extends Cubit<ReminderState> {
  ReminderCubit() : super(ReminderInitial());

  void selectAssignment(String selected){
    emit(SelectedAssignment(selected: selected));
  }

  void selectDate(DateTime selected){
    emit(SelectedDate(selected: selected));
  }

  void reload(){
    emit(ReminderInitial());
  }
}
