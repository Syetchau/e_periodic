/// fnc_AreaResult : [{"_area":"Escalator","_areaRFID":"","_arsn":1,"_updatedBy":null,"_znsn":1},{"_area":"JP1","_areaRFID":"","_arsn":2,"_updatedBy":null,"_znsn":1},{"_area":"JP1 Basement 1","_areaRFID":"","_arsn":3,"_updatedBy":null,"_znsn":1},{"_area":"JP1 Basement 1A (Clinic)","_areaRFID":"","_arsn":4,"_updatedBy":null,"_znsn":1},{"_area":"JP1 Basement 2","_areaRFID":"","_arsn":6,"_updatedBy":null,"_znsn":1},{"_area":"JP1 Level 1","_areaRFID":"","_arsn":7,"_updatedBy":null,"_znsn":1},{"_area":"JP1 Staircase","_areaRFID":"","_arsn":14,"_updatedBy":null,"_znsn":1},{"_area":"JP2","_areaRFID":"","_arsn":15,"_updatedBy":null,"_znsn":2},{"_area":"JP2 Basement 1","_areaRFID":"","_arsn":16,"_updatedBy":null,"_znsn":2},{"_area":"JP2 Basement 2","_areaRFID":"","_arsn":17,"_updatedBy":null,"_znsn":2},{"_area":"JP2 Level 1","_areaRFID":"","_arsn":18,"_updatedBy":null,"_znsn":2},{"_area":"JP2 Staircase","_areaRFID":"","_arsn":21,"_updatedBy":null,"_znsn":2},{"_area":"Travellator","_areaRFID":"","_arsn":22,"_updatedBy":null,"_znsn":1}]

class Area {
  List<Fnc_AreaResult> _fncAreaResult;

  List<Fnc_AreaResult> get fncAreaResult => _fncAreaResult;

  Area({
    List<Fnc_AreaResult> fncAreaResult}){
    _fncAreaResult = fncAreaResult;
  }

  Area.fromJson(dynamic json) {
    if (json["fnc_AreaResult"] != null) {
      _fncAreaResult = [];
      json["fnc_AreaResult"].forEach((v) {
        _fncAreaResult.add(Fnc_AreaResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_fncAreaResult != null) {
      map["fnc_AreaResult"] = _fncAreaResult.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// _area : "Escalator"
/// _areaRFID : ""
/// _arsn : 1
/// _updatedBy : null
/// _znsn : 1

class Fnc_AreaResult {
  String _area;
  String _areaRFID;
  int _arsn;
  String _updatedBy;
  int _znsn;
  bool _isCheckedChild = true;

  String get area => _area;
  String get areaRFID => _areaRFID;
  int get arsn => _arsn;
  String get updatedBy => _updatedBy;
  int get znsn => _znsn;
  bool get isChecked => _isCheckedChild;

  Fnc_AreaResult({
    String area,
    String areaRFID,
    int arsn,
    String updatedBy,
    int znsn}){
    _area = area;
    _areaRFID = areaRFID;
    _arsn = arsn;
    _updatedBy = updatedBy;
    _znsn = znsn;
  }

  Fnc_AreaResult.fromJson(dynamic json) {
    _area = json["_area"];
    _areaRFID = json["_areaRFID"];
    _arsn = json["_arsn"];
    _updatedBy = json["_updatedBy"];
    _znsn = json["_znsn"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["_area"] = _area;
    map["_areaRFID"] = _areaRFID;
    map["_arsn"] = _arsn;
    map["_updatedBy"] = _updatedBy;
    map["_znsn"] = _znsn;
    return map;
  }

  setIsCheckChild(bool isCheck) {
    this._isCheckedChild = isCheck;
  }

  getIsCheckChild() {
    return _isCheckedChild;
  }
}