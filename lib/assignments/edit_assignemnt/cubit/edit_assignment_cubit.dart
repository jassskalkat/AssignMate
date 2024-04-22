import 'package:assign_mate/database/database.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'edit_assignment_state.dart';

class EditAssignmentCubit extends Cubit<EditAssignmentState> {
  EditAssignmentCubit() : super(EditAssignmentInitial());

  Future getGroup(String id) async{
    emit(EditAssignmentLoading());
    final snapshot = await Database().getAssignment(id);
    emit(EditAssignmentLoaded(snapshot: snapshot));
  }
}
