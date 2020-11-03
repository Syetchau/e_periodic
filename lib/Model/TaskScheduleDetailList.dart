import 'dart:convert';

List<TaskScheduleDetail> taskScheduleDetailModelFromJson(String str) =>
    List<TaskScheduleDetail>.from(json.decode(str).map((x) => TaskScheduleDetail.fromJson(x)));

class TaskScheduleDetail {
  String area;
  String areaRFID;
  int arsn;
  int bdsn;
  String bedNo;
  String cancelledBy;
  double cancelledDate;
  double completedDate;
  String createdBy;
  int eqpsn;
  String equipment;
  String instruction;
  bool itemChecklist;
  int lcsn;
  String location;
  String note;
  int pjsn;
  double planningDate;
  String projectName;
  String remarks;
  String requestType;
  double scheduleDate;
  String scheduleEndTime;
  String scheduleStartTime;
  String status;
  String taskCategory;
  String taskName;
  int taskcgsn;
  int taskscheduledtlsn;
  int taskschedulesn;
  int tasksn;
  int znsn;
  String zone;

  TaskScheduleDetail({
    this.area,
    this.areaRFID,
    this.arsn,
    this.bdsn,
    this.bedNo,
    this.cancelledBy,
    this.cancelledDate,
    this.completedDate,
    this.createdBy,
    this.eqpsn,
    this.equipment,
    this.instruction,
    this.itemChecklist,
    this.lcsn,
    this.location,
    this.note,
    this.pjsn,
    this.planningDate,
    this.projectName,
    this.remarks,
    this.requestType,
    this.scheduleDate,
    this.scheduleEndTime,
    this.scheduleStartTime,
    this.status,
    this.taskCategory,
    this.taskName,
    this.taskcgsn,
    this.taskscheduledtlsn,
    this.taskschedulesn,
    this.tasksn,
    this.znsn,
    this.zone
  });

  factory TaskScheduleDetail.fromJson(Map<String, dynamic> json) => TaskScheduleDetail(
    area: json["_area"],
    areaRFID: json["_areaRFID"],
    arsn: json["_arsn"],
    bdsn: json["_bdsn"],
    bedNo: json["_bedNo"],
    cancelledBy: json["_cancelledBy"],
    cancelledDate: json["_cancelledDate"],
    completedDate: json["_completedDate"],
    createdBy: json["_createdBy"],
    eqpsn: json["_eqpsn"],
    equipment: json["_equipment"],
    instruction: json["_instruction"],
    itemChecklist: json["_itemChecklist"],
    lcsn: json["_lcsn"],
    location: json["_location"],
    note: json["_note"],
    pjsn: json["_pjsn"],
    planningDate: json["_planningDate"],
    projectName: json["_projectName"],
    remarks: json["_remarks"],
    requestType: json["_requestType"],
    scheduleDate: json["_scheduleDate"],
    scheduleEndTime: json["_scheduleEndTime"],
    scheduleStartTime: json["_scheduleStartTime"],
    status: json["_status"],
    taskCategory: json["_taskCategory"],
    taskName: json["_taskName"],
    taskcgsn: json["_taskcgsn"],
    taskscheduledtlsn: json["_taskscheduledtlsn"],
    taskschedulesn: json["_taskschedulesn"],
    tasksn: json["_tasksn"],
    znsn: json["_znsn"],
    zone: json["_zone"]
  );
}