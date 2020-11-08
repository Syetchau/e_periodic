import 'package:e_periodic/Model/TaskScheduleSummary.dart';

class CompletedList {
  List<Fnc_TaskScheduleSummaryResult> _completedList = List<Fnc_TaskScheduleSummaryResult>();

  List<Fnc_TaskScheduleSummaryResult> get completedList => _completedList;

  setCompletedList(List list){
    this._completedList = list;
  }

  getCompletedList() {
    return _completedList;
  }
}