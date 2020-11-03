/// fnc_ProjectListResult : [{"_pjsn":1,"_projectName":"Jurong Point"}]

class ProjectList {
  List<Fnc_ProjectListResult> _fncProjectListResult;

  List<Fnc_ProjectListResult> get fncProjectListResult => _fncProjectListResult;

  ProjectList({
    List<Fnc_ProjectListResult> fncProjectListResult}){
    _fncProjectListResult = fncProjectListResult;
  }

  ProjectList.fromJson(dynamic json) {
    if (json["fnc_ProjectListResult"] != null) {
      _fncProjectListResult = [];
      json["fnc_ProjectListResult"].forEach((v) {
        _fncProjectListResult.add(Fnc_ProjectListResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_fncProjectListResult != null) {
      map["fnc_ProjectListResult"] = _fncProjectListResult.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _pjsn : 1
/// _projectName : "Jurong Point"

class Fnc_ProjectListResult {
  int _pjsn;
  String _projectName;

  int get pjsn => _pjsn;
  String get projectName => _projectName;

  Fnc_ProjectListResult({
    int pjsn,
    String projectName}){
    _pjsn = pjsn;
    _projectName = projectName;
  }

  Fnc_ProjectListResult.fromJson(dynamic json) {
    _pjsn = json["_pjsn"];
    _projectName = json["_projectName"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_pjsn"] = _pjsn;
    map["_projectName"] = _projectName;
    return map;
  }

}