import 'package:e_periodic/Model/TaskScheduleSummary.dart';

class TotalList {
  List<Fnc_TaskScheduleSummaryResult> _totalList = List<Fnc_TaskScheduleSummaryResult>();

  List<Fnc_TaskScheduleSummaryResult> get totalList => _totalList;

  setTotalList(List list){
    this._totalList = list;
  }

  getTotalList() {
    return _totalList;
  }
}