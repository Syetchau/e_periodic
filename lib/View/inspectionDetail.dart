import 'dart:convert';
import 'dart:developer';

import 'package:e_periodic/Common/Common.dart';
import 'package:e_periodic/Repo/ApiProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InspectionDetailPage extends StatefulWidget {
  final String location;
  final int itemTaskInsPsn;
  final int taskInsPsn;
  final bool isEquipment;

  InspectionDetailPage(
      {Key key,
      this.location,
      this.itemTaskInsPsn,
      this.taskInsPsn,
      this.isEquipment})
      : super(key: key);

  @override
  _InspectionDetailPageState createState() => _InspectionDetailPageState();
}

class _InspectionDetailPageState extends State<InspectionDetailPage> {
  dynamic taskInspectionDetailList;
  dynamic itemTaskInspectionDetailList;

  @override
  void initState() {
    super.initState();
    _callTaskOrItemApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _callTaskOrItemApi() async {
    if (widget.isEquipment != true) {
      _getTaskInspectionList();
    } else {
      _getItemTaskInspectionList();
    }
  }

  Future<void> _getTaskInspectionList() async {
    String taskInspectionURL =
        Common.taskInspectionDetailURL + "_taskinspsn=${widget.taskInsPsn}";

    await ApiProvider().getHTTPResponse(taskInspectionURL).then(
        (response) async {
      setState(() {
        if (response.statusCode == 200) {
          Map<String, dynamic> resultMap = json.decode(response.body);
          dynamic data = resultMap["fnc_TaskScheduleInspDetailsResult"];
          taskInspectionDetailList = data;
          return taskInspectionDetailList;
        } else {
          throw Exception(response.statusCode);
        }
      });
    }, onError: (error) {
      log('callTaskInspectionList : $error');
    });
  }

  Future<void> _getItemTaskInspectionList() async {
    String itemTaskInspectionURL = Common.itemInspectionDetailURL +
        "_itemtaskinspsn=${widget.itemTaskInsPsn}";

    await ApiProvider().getHTTPResponse(itemTaskInspectionURL).then(
        (response) async {
      setState(() {
        if (response.statusCode == 200) {
          Map<String, dynamic> resultMap = json.decode(response.body);
          dynamic data = resultMap["fnc_Item_TaskScheduleInspDetailsResult"];
          itemTaskInspectionDetailList = data;
          return itemTaskInspectionDetailList;
        } else {
          throw Exception(response.statusCode);
        }
      });
    }, onError: (error) {
      log('callItemTaskInspectionList : $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Common.appBarHeight),
        child: SafeArea(
          child: AppBar(
            backgroundColor: Colors.lightBlueAccent,
            centerTitle: true,
            title: Text(
              "${widget.location}",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(null);
                },
                child: Container(
                    padding: EdgeInsets.only(right: 20),
                    color: Colors.transparent,
                    width: 45,
                    height: 30,
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.arrow_back,
                        size: 24.0, color: Colors.black))),
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildListWidget() {
    if (widget.isEquipment != true) {
      return taskInspectionDetailWidget();
    } else {
      return itemTaskInspectionDetailWidget();
    }
  }

  Widget taskInspectionDetailWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10.0, left: 10.0),
            child: Text(
              '${taskInspectionDetailList["_listTaskInspection"][0]["_location"]}',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.startTime} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child:
                    _convertStartTime(taskInspectionDetailList["_startDate"]),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.endTime} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child: _convertEndTime(taskInspectionDetailList["_endDate"]),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.completedBy} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child: Text(
                  '${taskInspectionDetailList["_completedBy"]}',
                  style: Common.detailCardLabelTextStyle,
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.inspectedBy} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child: _setInspectionDetail(
                    taskInspectionDetailList["_inspectedBy"]),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text(
                    '${Common.result} :',
                    style: Common.cardLabelTextStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                  child: Text(
                    '${taskInspectionDetailList["_listTaskInspection"][0]["_status"]}',
                    style: Common.detailCardLabelTextStyle,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemTaskInspectionDetailWidget() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10.0, left: 10.0),
            child: Text(
              '${itemTaskInspectionDetailList["_listItemTaskInspection"][0]["_location"]}',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.startTime} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child: _convertStartTime(
                    itemTaskInspectionDetailList["_startDate"]),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.endTime} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child:
                    _convertEndTime(itemTaskInspectionDetailList["_endDate"]),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.completedBy} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child: Text(
                  '${itemTaskInspectionDetailList["_completedBy"]}',
                  style: Common.detailCardLabelTextStyle,
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                child: Text(
                  '${Common.inspectedBy} :',
                  style: Common.cardLabelTextStyle,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                child: _setInspectionDetail(
                    itemTaskInspectionDetailList["_inspectedBy"]),
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 10.0),
                  child: Text(
                    '${Common.result} :',
                    style: Common.cardLabelTextStyle,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 5.0),
                  child: Text(
                    '${itemTaskInspectionDetailList["_listItemTaskInspection"][0]["_status"]}',
                    style: Common.detailCardLabelTextStyle,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Text _convertStartTime(double start) {
    DateTime startTime = Common().convertFromOADate(start);
    String day = DateFormat.yMd().format(startTime);
    String hour = DateFormat.Hms().format(startTime);

    return Text(
      '$day $hour',
      style: Common.detailCardLabelTextStyle,
    );
  }

  Text _convertEndTime(double end) {
    DateTime endTime = Common().convertFromOADate(end);
    String day = DateFormat.yMd().format(endTime);
    String hour = DateFormat.Hms().format(endTime);

    return Text(
      '$day $hour',
      style: Common.detailCardLabelTextStyle,
    );
  }

  Text _setInspectionDetail(String inspectionBy) {
    String inspection;

    if (inspectionBy == "" || inspectionBy == null) {
      inspection = "-";
    } else {
      inspection = inspectionBy;
    }

    return Text(
      '$inspection',
      style: Common.detailCardLabelTextStyle,
    );
  }
}
