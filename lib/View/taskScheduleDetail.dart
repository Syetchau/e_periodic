import 'dart:convert';
import 'dart:developer';

import 'package:e_periodic/Common/Common.dart';
import 'package:e_periodic/Model/TaskScheduleDetailList.dart';
import 'package:e_periodic/Repo/ApiProvider.dart';
import 'package:e_periodic/View/inspectionDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskScheduleDetailPage extends StatefulWidget {
  final String taskName;
  final String area;
  final int pjsn;
  final int arsn;
  final double startDate;
  final double endDate;
  final int tasksn;
  final int taskcgsn;
  final String taskCategory;

  TaskScheduleDetailPage({
    Key key,
    this.taskName,
    this.area,
    this.pjsn,
    this.arsn,
    this.startDate,
    this.endDate,
    this.tasksn,
    this.taskcgsn,
    this.taskCategory,
  }) : super(key: key);

  @override
  _TaskScheduleDetailPageState createState() => _TaskScheduleDetailPageState();
}

class _TaskScheduleDetailPageState extends State<TaskScheduleDetailPage> {
  List<dynamic> detailList = List<dynamic>();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  bool isEquipment = false;

  @override
  void initState() {
    super.initState();
    if (widget.taskCategory == Common.project) {
      isEquipment = false;
      _getTaskScheduleDetailList();
    } else {
      isEquipment = true;
      _getItemTaskScheduleDetailList();
    }
    _displayDateText();
  }

  @override
  void dispose() {
    super.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
  }

  Future<void> _getTaskScheduleDetailList() async {
    String detailURL = Common.taskScheduleDetailURL +
        "_pjsn=${widget.pjsn}" +
        "&_arsn=${widget.arsn}" +
        "&_startDate=${widget.startDate}" +
        "&_endDate=${widget.endDate}" +
        "&_tasksn=${widget.tasksn}" +
        "&_taskcgsn=${widget.taskcgsn}";

    await ApiProvider().getHTTPResponse(detailURL).then((response) async {
      setState(() {
        if (response.statusCode == 200) {
          Map<String, dynamic> resultMap = json.decode(response.body);
          List<dynamic> data = resultMap["fnc_TaskScheduleInspListResult"];
          detailList = data;
        } else {
          throw Exception(response.statusCode);
        }
      });
    }, onError: (error) {
      log('callTaskScheduleDetail : $error');
    });
  }

  Future<void> _getItemTaskScheduleDetailList() async {
    String itemDetailURL = Common.itemTaskScheduleDetailURL +
        "_pjsn=${widget.pjsn}" +
        "&_arsn=${widget.arsn}" +
        "&_startDate=${widget.startDate}" +
        "&_endDate=${widget.endDate}" +
        "&_tasksn=${widget.tasksn}" +
        "&_taskcgsn=${widget.taskcgsn}";

    await ApiProvider().getHTTPResponse(itemDetailURL).then((response) async {
      setState(() {
        if (response.statusCode == 200) {
          Map<String, dynamic> resultMap = json.decode(response.body);
          List<dynamic> data = resultMap["fnc_Item_TaskScheduleInspListResult"];
          detailList = data;
        } else {
          throw Exception(response.statusCode);
        }
      });
    }, onError: (error) {
      log('callTaskScheduleDetail : $error');
    });
  }

  void _displayDateText() {}

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
              "${widget.taskName}",
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
            Container(
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/ic_header_bkg.png"),
                fit: BoxFit.cover,
              )),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 110,
                  margin: const EdgeInsets.only(left: 15.0, right: 15.0),
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
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Text(
                          widget.area,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10.0, left: 10.0),
                                child: Text(Common.startTime,
                                    style: Common.cardLabelTextStyle),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10.0, left: 10.0),
                                child: Text(Common.endTime,
                                    style: Common.cardLabelTextStyle),
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: TextFormField(
                                  controller: startTimeController,
                                  readOnly: true,
                                  decoration: Common.cardEditTextDeco,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: TextFormField(
                                  controller: endTimeController,
                                  readOnly: true,
                                  decoration: Common.cardEditTextDeco,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 12,
                  color: Colors.grey,
                ),
                _buildListWidget(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListWidget() {
    return Expanded(
      child: ListView.builder(
          itemCount: detailList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InspectionDetailPage(
                          location: detailList[index]["_location"],
                          itemTaskInsPsn: detailList[index]["_itemtaskinspsn"],
                          taskInsPsn: detailList[index]["_taskinspsn"],
                          isEquipment: isEquipment,
                        )));
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 5.0, bottom: 5.0),
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(left: 10),
                        child: Text('${detailList[index]["_location"]}',
                            style: Common.cardLabelTextStyle)),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 5, left: 10),
                          child: Text('${Common.inspection}',
                              style: Common.detailCardLabelTextStyle),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Text(
                            '${detailList[index]["_status"]}',
                            style: Common.detailCardLabelTextStyle,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
