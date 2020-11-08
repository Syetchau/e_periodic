import 'package:e_periodic/Model/TaskScheduleSummary.dart';

class PendingList {
  List<Fnc_TaskScheduleSummaryResult> _pendingList = List<Fnc_TaskScheduleSummaryResult>();

  List<Fnc_TaskScheduleSummaryResult> get pendingList => _pendingList;

  setPendingList(List list){
    this._pendingList = list;
  }

  getPendingList() {
    return _pendingList;
  }
}