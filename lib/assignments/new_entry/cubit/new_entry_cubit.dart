import 'package:assign_mate/database/database.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'new_entry_state.dart';

class NewEntryCubit extends Cubit<NewEntryState> {
  NewEntryCubit() : super(NewEntryInitial());

  void create(String title, DateTime dueDate) async{
    emit(NewEntryCreating());
    final String id = await Database().createAssignment(title, dueDate.toString(),);
    emit(NewEntryCreated(id: id));
  }

  void pickedDate(String title, DateTime dueDate){
    emit(DatePicked(title: title, dueDate: dueDate));
  }

  void reset(){
    emit(NewEntryInitial());
  }
}
