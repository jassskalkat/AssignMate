import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import '../../database/database.dart';
part 'assignments_state.dart';

class AssignmentsCubit extends Cubit<AssignmentsState> {
  AssignmentsCubit() : super(AssignmentsInitial());

  void change(){
    if(state is CurrentAssignments){
      emit(PastAssignments());
    }
    else {
      emit(CurrentAssignments());
    }
  }

  Future getAssignments() async{
    emit(AssignmentsLoading());
    final snapshot = await Database().getUserAssignments();
    emit(AssignmentsLoaded(snapshots: snapshot));
  }

  Future getAssignmentsInfo(List<String> assignmentsIDs) async{
    emit(AssignmentsLoading());
    List<Stream?> assignmentsSnapshots = [];
    for(int i = 0; i < assignmentsIDs.length; i++){
      final snapshot = await Database().getAssignment(assignmentsIDs[i]);
      assignmentsSnapshots.add(snapshot);
    }
    emit(AssignmentsInfoLoaded(assignmentsSnapshots: assignmentsSnapshots));
  }
}
