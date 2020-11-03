/// fnc_TaskListResult : [{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#9933FF","_taskName":"Bin Washing","_taskShortName":"BinW","_taskcgsn":1,"_tasksn":2},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#0000FF","_taskName":"Carpet Shampoo","_taskShortName":"CSham","_taskcgsn":1,"_tasksn":5},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#118ab2","_taskName":"Damp Wiping(Furniture & Signs)","_taskShortName":"DWipe","_taskcgsn":1,"_tasksn":3},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#FF0066","_taskName":"Drain Cleaning","_taskShortName":"DrCle","_taskcgsn":1,"_tasksn":24},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#FF6600","_taskName":"Dusting (Furniture & Signs)","_taskShortName":"Dust","_taskcgsn":1,"_tasksn":69},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#330099","_taskName":"Escalator & Travelator Cleaning","_taskShortName":"ETCle","_taskcgsn":1,"_tasksn":26},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#2d92d1","_taskName":"Floor Scrubbing","_taskShortName":"FScrb","_taskcgsn":1,"_tasksn":36},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#e07a5f","_taskName":"Glass Canopy Cleaning","_taskShortName":"GlasC","_taskcgsn":1,"_tasksn":39},{"_instruction":"Ceiling, Lightings & AC Duct","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#432371","_taskName":"High Dusting (Ceiling/Lights/AC Duct)","_taskShortName":"HiDC","_taskcgsn":1,"_tasksn":40},{"_instruction":"Trussess","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#fca311","_taskName":"High Dusting (Trussess)","_taskShortName":"HiDT","_taskcgsn":1,"_tasksn":43},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#c44536","_taskName":"High Pressure","_taskShortName":"HiPre","_taskcgsn":1,"_tasksn":41},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#9f6976","_taskName":"Lift Polishing","_taskShortName":"LifPo","_taskcgsn":1,"_tasksn":55},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#c44536","_taskName":"Louvered Panels Cleaning","_taskShortName":"LPCle","_taskcgsn":1,"_tasksn":57},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#06d6a0","_taskName":"Polycarbonate Cleaning","_taskShortName":"PcCle","_taskcgsn":1,"_tasksn":66},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#99CCCC","_taskName":"Public Seating Area","_taskShortName":"PSA","_taskcgsn":1,"_tasksn":58},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#9933FF","_taskName":"Rooftop Cleaning","_taskShortName":"RTCle","_taskcgsn":1,"_tasksn":59},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#9933FF","_taskName":"Scrubbing (Urinal & WC)","_taskShortName":"ScrWC","_taskcgsn":1,"_tasksn":68},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#CC0066","_taskName":"Service Riser/M&E Rm Cleaning","_taskShortName":"RmCle","_taskcgsn":1,"_tasksn":61},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#6633FF","_taskName":"Shop Front Cleaning","_taskShortName":"SFCle","_taskcgsn":1,"_tasksn":62},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#0099FF","_taskName":"Stainless Steel Railings","_taskShortName":"SSR","_taskcgsn":1,"_tasksn":63},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#CC99CC","_taskName":"Staircase (Damp Wiping & Moping)","_taskShortName":"Stair","_taskcgsn":1,"_tasksn":64},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#a11d33","_taskName":"Toilet Descaling","_taskShortName":"TDesc","_taskcgsn":1,"_tasksn":60},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#9933FF","_taskName":"Vaccum & Carpet Spot Cleaning","_taskShortName":"SptCl","_taskcgsn":1,"_tasksn":56},{"_instruction":"","_itemChecklist":false,"_pjsn":1,"_taskCategory":"Project","_taskColor":"#339933","_taskName":"Wall Cleaning","_taskShortName":"WaCle","_taskcgsn":1,"_tasksn":65}]

class Task {
  List<Fnc_TaskListResult> _fncTaskListResult;

  List<Fnc_TaskListResult> get fncTaskListResult => _fncTaskListResult;

  Task({
    List<Fnc_TaskListResult> fncTaskListResult}){
    _fncTaskListResult = fncTaskListResult;
  }

  Task.fromJson(dynamic json) {
    if (json["fnc_TaskListResult"] != null) {
      _fncTaskListResult = [];
      json["fnc_TaskListResult"].forEach((v) {
        _fncTaskListResult.add(Fnc_TaskListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_fncTaskListResult != null) {
      map["fnc_TaskListResult"] = _fncTaskListResult.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _instruction : ""
/// _itemChecklist : false
/// _pjsn : 1
/// _taskCategory : "Project"
/// _taskColor : "#9933FF"
/// _taskName : "Bin Washing"
/// _taskShortName : "BinW"
/// _taskcgsn : 1
/// _tasksn : 2

class Fnc_TaskListResult {
  String _instruction;
  bool _itemChecklist;
  int _pjsn;
  String _taskCategory;
  String _taskColor;
  String _taskName;
  String _taskShortName;
  int _taskcgsn;
  int _tasksn;
  bool _isCheckedChild = true;

  String get instruction => _instruction;
  bool get itemChecklist => _itemChecklist;
  int get pjsn => _pjsn;
  String get taskCategory => _taskCategory;
  String get taskColor => _taskColor;
  String get taskName => _taskName;
  String get taskShortName => _taskShortName;
  int get taskcgsn => _taskcgsn;
  int get tasksn => _tasksn;
  bool get isChecked => _isCheckedChild;

  Fnc_TaskListResult({
    String instruction,
    bool itemChecklist,
    int pjsn,
    String taskCategory,
    String taskColor,
    String taskName,
    String taskShortName,
    int taskcgsn,
    int tasksn}){
    _instruction = instruction;
    _itemChecklist = itemChecklist;
    _pjsn = pjsn;
    _taskCategory = taskCategory;
    _taskColor = taskColor;
    _taskName = taskName;
    _taskShortName = taskShortName;
    _taskcgsn = taskcgsn;
    _tasksn = tasksn;
  }

  Fnc_TaskListResult.fromJson(dynamic json) {
    _instruction = json["_instruction"];
    _itemChecklist = json["_itemChecklist"];
    _pjsn = json["_pjsn"];
    _taskCategory = json["_taskCategory"];
    _taskColor = json["_taskColor"];
    _taskName = json["_taskName"];
    _taskShortName = json["_taskShortName"];
    _taskcgsn = json["_taskcgsn"];
    _tasksn = json["_tasksn"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_instruction"] = _instruction;
    map["_itemChecklist"] = _itemChecklist;
    map["_pjsn"] = _pjsn;
    map["_taskCategory"] = _taskCategory;
    map["_taskColor"] = _taskColor;
    map["_taskName"] = _taskName;
    map["_taskShortName"] = _taskShortName;
    map["_taskcgsn"] = _taskcgsn;
    map["_tasksn"] = _tasksn;
    return map;
  }

  setIsCheckChild(bool isCheck) {
    this._isCheckedChild = isCheck;
  }

  getIsCheckChild() {
    return _isCheckedChild;
  }
}