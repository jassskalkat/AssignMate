import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../database/database.dart';
part 'assignment_view_state.dart';

class AssignmentViewCubit extends Cubit<AssignmentViewState> {
  AssignmentViewCubit() : super(AssignmentViewInitial());

  Future getGroup(String id) async{
    emit(AssignmentLoading());
    final snapshot = await Database().getAssignment(id);
    emit(AssignmentLoaded(snapshot: snapshot));
  }
}
