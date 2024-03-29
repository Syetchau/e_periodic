import 'dart:convert';
import 'dart:developer';

import 'package:e_periodic/Common/Common.dart';
import 'package:e_periodic/Model/Area.dart';
import 'package:e_periodic/Model/CompletedList.dart';
import 'package:e_periodic/Model/PendingList.dart';
import 'package:e_periodic/Model/ProjectList.dart';
import 'package:e_periodic/Model/Task.dart';
import 'package:e_periodic/Model/TaskScheduleSummary.dart';
import 'package:e_periodic/Model/TotalList.dart';
import 'package:e_periodic/Model/User.dart';
import 'package:e_periodic/Repo/ApiProvider.dart';
import 'package:e_periodic/Repo/SPHelper.dart';
import 'package:e_periodic/View/PopupTaskDialog.dart';
import 'package:e_periodic/View/login.dart';
import 'package:e_periodic/View/taskScheduleDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import 'CustomMonthlyPicker.dart';
import 'PopupAreaDialog.dart';
import 'package:grouped_list/grouped_list.dart';

class HomePage extends StatefulWidget {
  final DateTime initialDate;

  HomePage({Key key, this.initialDate}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  SPHelper spHelper = SPHelper();
  List<Fnc_AreaResult> areaList = List<Fnc_AreaResult>();
  List<Fnc_TaskListResult> taskList = List<Fnc_TaskListResult>();
  List<Fnc_TaskScheduleSummaryResult> taskScheduleSummaryList =
      List<Fnc_TaskScheduleSummaryResult>();
  List<Fnc_TaskScheduleSummaryResult> itemScheduleList =
      List<Fnc_TaskScheduleSummaryResult>();
  TotalList total = TotalList();
  PendingList pending = PendingList();
  CompletedList completed = CompletedList();
  TextEditingController calendarController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController taskController = TextEditingController();
  ScrollController scrollController = ScrollController();
  GlobalKey<PopupAreaDialogState> areaKey = GlobalKey();
  GlobalKey<PopupTaskDialogState> taskKey = GlobalKey();
  String projectName = "";
  int selectedIndex;
  DateTime selectedDate;
  double convertedTimeStamp;
  bool isLoading = true;
  bool isFilteringArea = false;
  bool isFilteringTask = false;
  bool isClearTaskList = false;
  bool isClearAreaList = false;
  List<String> _options = [
    "ALL",
    "PENDING",
    "PENDING INSP",
    "VERIFY",
    "COMPLETED",
    "FOLLOW-UP"
  ];

  @override
  void initState() {
    super.initState();
    _getConvertedMicrosoftTimeStamp();
    _getProjectTitle();
    _getAreaList();
    _getTaskList();
    _getTotalList(convertedTimeStamp);
    selectedIndex = 0;
    selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    super.dispose();
    calendarController.dispose();
    areaController.dispose();
    taskController.dispose();
    scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _getConvertedMicrosoftTimeStamp() {
    // get current year, month that start from 01
    final firstDateOfMonth =
        DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
    convertedTimeStamp = Common().convertToOADate(firstDateOfMonth);

    // set text for editText
    calendarController.text = DateFormat.yMMM().format(firstDateOfMonth);
    areaController.text = Common.all;
    taskController.text = Common.all;
  }

  Future<void> _getProjectTitle() async {
    await ApiProvider().getHTTPResponse(Common.projectListURL).then(
        (response) async {
      if (response.statusCode == 200) {
        ProjectList project = new ProjectList();
        project = ProjectList.fromJson(json.decode(response.body));
        projectName = project.fncProjectListResult[0].projectName;
      } else {
        throw Exception(response.statusCode);
      }
    }, onError: (error) {
      log('callProjectListError : $error');
    });
  }

  Future<void> _getAreaList() async {
    User user = User.fromJson(await spHelper.read(SPHelper.userInfo));
    await ApiProvider()
        .getHTTPResponse(Common.areaListURL + "_pjsn=${user.pjsn}")
        .then((response) async {
      if (response.statusCode == 200) {
        Area area = new Area();
        area = Area.fromJson(json.decode(response.body));
        areaList = area.fncAreaResult;
        areaList.sort((a, b) => a.area.compareTo(b.area));
      } else {
        throw Exception(response.statusCode);
      }
    }, onError: (error) {
      log('callAreaListError : $error');
    });
  }

  Future<void> _getTaskList() async {
    User user = User.fromJson(await spHelper.read(SPHelper.userInfo));
    await ApiProvider()
        .getHTTPResponse(Common.taskListURL + "_pjsn=${user.pjsn}")
        .then((response) async {
      if (response.statusCode == 200) {
        Task task = new Task();
        task = Task.fromJson(json.decode(response.body));
        taskList = task.fncTaskListResult;
        taskList.sort((a, b) => a.taskName.compareTo(b.taskName));
      } else {
        throw Exception(response.statusCode);
      }
    }, onError: (error) {
      log('callTaskListError : $error');
    });
  }

  Future<void> _getTaskScheduleSummaryList(convertedTimeStamp) async {
    User user = User.fromJson(await spHelper.read(SPHelper.userInfo));
    String scheduleURL = Common.taskScheduleSummaryURL +
        "_pjsn=${user.pjsn}" +
        "&_date=$convertedTimeStamp" +
        "&_tasksn=${0}" +
        "&_taskcgsn=${0}";

    await ApiProvider().getHTTPResponse(scheduleURL).then((response) async {
      if (response.statusCode == 200) {
        TaskScheduleSummary taskScheduleSummary = new TaskScheduleSummary();
        taskScheduleSummary =
            TaskScheduleSummary.fromJson(json.decode(response.body));
        taskScheduleSummaryList =
            taskScheduleSummary.fncTaskScheduleSummaryResult;
      } else {
        throw Exception(response.statusCode);
      }
    }, onError: (error) {
      log('callTaskScheduleSummaryListError : $error');
    });
  }

  Future<void> _getItemScheduleList(convertedTimeStamp) async {
    User user = User.fromJson(await spHelper.read(SPHelper.userInfo));
    String itemTaskScheduleURL = Common.itemTaskScheduleSummaryURL +
        "_pjsn=${user.pjsn}" +
        "&_date=$convertedTimeStamp" +
        "&_tasksn=${0}" +
        "&_taskcgsn=${0}";

    await ApiProvider().getHTTPResponse(itemTaskScheduleURL).then(
        (response) async {
      if (response.statusCode == 200) {
        TaskScheduleSummary taskScheduleSummary = new TaskScheduleSummary();
        taskScheduleSummary =
            TaskScheduleSummary.fromJson2(json.decode(response.body));
        itemScheduleList = taskScheduleSummary.fncTaskScheduleSummaryResult;
      } else {
        throw Exception(response.statusCode);
      }
    }, onError: (error) {
      log('callTaskScheduleSummaryListError : $error');
    });
  }

  Future<void> _getTotalList(convertedTimeStamp) async {
    // wait these two APIs call first
    await _getTaskScheduleSummaryList(convertedTimeStamp);
    await _getItemScheduleList(convertedTimeStamp);

    List<Fnc_TaskScheduleSummaryResult> taskList = taskScheduleSummaryList;
    List<Fnc_TaskScheduleSummaryResult> itemList = itemScheduleList;
    List<Fnc_TaskScheduleSummaryResult> totalList =
        List<Fnc_TaskScheduleSummaryResult>();
    List<Fnc_TaskScheduleSummaryResult> fullList =
        List<Fnc_TaskScheduleSummaryResult>();
    List<Fnc_TaskScheduleSummaryResult> pendingList =
        List<Fnc_TaskScheduleSummaryResult>();
    List<Fnc_TaskScheduleSummaryResult> completedList =
        List<Fnc_TaskScheduleSummaryResult>();

    if (itemList.length != 0 && taskList.length != 0) {
      totalList.addAll(taskList);
      totalList.addAll(itemList);
      totalList.sort((a, b) => a.planningDate.compareTo(b.planningDate));
      total.setTotalList(totalList);
    } else if (itemList.length == 0) {
      totalList = taskList;
      totalList.sort((a, b) => a.planningDate.compareTo(b.planningDate));
      total.setTotalList(totalList);
    } else if (taskList.length == 0) {
      totalList = itemList;
      totalList.sort((a, b) => a.planningDate.compareTo(b.planningDate));
      total.setTotalList(totalList);
    }

    fullList.clear();
    pendingList.clear();
    completedList.clear();
    fullList.addAll(totalList);

    for (int i = 0; i < fullList.length; i++) {
      if (fullList[i].pending >= 1) {
        pendingList.add(fullList[i]);
        pendingList.sort((a, b) => a.planningDate.compareTo(b.planningDate));
        pending.setPendingList(pendingList);
      } else if (fullList[i].pending == 0) {
        completedList.add(fullList[i]);
        completedList.sort((a, b) => a.planningDate.compareTo(b.planningDate));
        completed.setCompletedList(completedList);
      }
    }

    isLoading = false;
    _scrollToTop();
    if (isFilteringTask != true ||
        isFilteringArea != true ||
        isClearTaskList != false ||
        isClearAreaList != false) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Common.appBarHeight),
        child: SafeArea(
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.lightBlueAccent,
            centerTitle: true,
            title: Text(
              "$projectName",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold),
            ),
            leading: Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Icon(
                Icons.calendar_today,
                color: Colors.black,
                size: 24.0,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 10.0),
                child: Icon(
                  Icons.add_circle_outline,
                  color: Colors.black,
                  size: 24.0,
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.black,
                  size: 24.0,
                ),
                onSelected: _choiceAction,
                itemBuilder: (BuildContext context) {
                  return Common.choices.map((String choice) {
                    return PopupMenuItem(
                      height: 38,
                      value: choice,
                      child: Text(
                        choice,
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    );
                  }).toList();
                },
              )
            ],
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
                  height: 275,
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
                          Common.filter,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              Common.status,
                              style: Common.cardLabelTextStyle,
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              top: 3.0, left: 3.0, right: 3.0),
                          height: 95,
                          child: _buildChips(),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10.0),
                                child: Text(Common.dateRange,
                                    style: Common.cardLabelTextStyle,
                                    textAlign: TextAlign.left),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: Text(Common.area,
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
                                margin: const EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  controller: calendarController,
                                  readOnly: true,
                                  decoration: Common.cardEditTextDeco,
                                  onTap: () {
                                    _displayMonthlyCalendar(context);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                margin:
                                    const EdgeInsets.only(left: 15, right: 10),
                                child: TextFormField(
                                  controller: areaController,
                                  readOnly: true,
                                  decoration: Common.cardEditTextDeco,
                                  maxLines: 1,
                                  onTap: () {
                                    showAreaPopupDialog();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0, top: 5.0),
                            child: Text(Common.task,
                                style: Common.cardLabelTextStyle,
                                textAlign: TextAlign.left),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: taskController,
                              readOnly: true,
                              decoration: Common.cardEditTextDeco,
                              onTap: () {
                                showTaskPopupDialog();
                              },
                            ),
                          ),
                        ),
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
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: _setBuildWidget(),
                  ),
                )
              ],
            ),
            Visibility(
              visible: isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _setBuildWidget() {
    if (selectedIndex == 0 && total.totalList.isNotEmpty)
      return _buildTaskScheduleList(total.getTotalList());
    else if (selectedIndex == 1 && pending.pendingList.isNotEmpty)
      return _buildTaskScheduleList(pending.getPendingList());
    else if (selectedIndex == 4 && completed.completedList.isNotEmpty)
      return _buildTaskScheduleList(completed.getCompletedList());
    else {
      return _noResultView();
    }
  }

  Widget _noResultView() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 130,
      child: Text(Common.noTask,
          style: TextStyle(color: Colors.black54, fontSize: 14)),
    );
  }

  Widget _buildTaskScheduleList(List<Fnc_TaskScheduleSummaryResult> list) {
    return GroupedListView<Fnc_TaskScheduleSummaryResult, DateTime>(
      shrinkWrap: true,
      elements: list,
      groupBy: (element) =>
          Common().convertFromOADate(element.planningDate.toDouble()),
      groupSeparatorBuilder: (DateTime date) => Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
          child: Text(DateFormat.yMMMEd().format(date),
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold))),
      indexedItemBuilder:
          (context, Fnc_TaskScheduleSummaryResult element, index) =>
              GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => TaskScheduleDetailPage(
                        taskName: list[index].taskName,
                        area: list[index].area,
                        pjsn: list[index].pjsn,
                        arsn: list[index].arsn,
                        startDate: list[index].planningDate.toDouble(),
                        endDate: list[index].scheduleDate.toDouble(),
                        tasksn: list[index].tasksn,
                        taskcgsn: list[index].taskcgsn,
                        taskCategory: list[index].taskCategory,
                      )))
              .then((value) => _refresh());
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: _setRedCircleIconType(list[index]),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child:
                        Icon(Icons.circle, size: 24.0, color: Colors.redAccent),
                  ),
                ),
                Visibility(
                  visible: _setGreenCheckIconType(list[index]),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Icon(Icons.check, size: 24.0, color: Colors.green),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          child: Text(
                            '${list[index].taskName.trim()}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            '${list[index].area.trim()}',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
      itemComparator: (item1, item2) =>
          item1.taskName.compareTo(item2.taskName),
      useStickyGroupSeparators: true,
      floatingHeader: true,
      order: GroupedListOrder.ASC,
    );
  }

  // Widget _buildTaskScheduleList(List<Fnc_TaskScheduleSummaryResult> list) {
  //   return ListView.builder(
  //     controller: scrollController,
  //     itemCount: list.length,
  //     itemBuilder: (BuildContext context, int index) {
  //       if(list.length != 0){
  //         return Column(
  //           children: [
  //             Container(
  //                 alignment: Alignment.topLeft,
  //                 margin:
  //                 const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0),
  //                 child: Text(
  //                     DateFormat.yMMMEd().format(Common().convertFromOADate(
  //                         list[index].planningDate.toDouble())),
  //                     style: TextStyle(
  //                         color: Colors.black87,
  //                         fontSize: 15.0,
  //                         fontWeight: FontWeight.bold))),
  //             ListView.builder(
  //               shrinkWrap: true,
  //               physics: ClampingScrollPhysics(),
  //               itemCount: list.length,
  //               itemBuilder: (context, index) => GestureDetector(
  //                 onTap: () {
  //                   Navigator.of(context)
  //                       .push(MaterialPageRoute(
  //                       builder: (context) => TaskScheduleDetailPage(
  //                         taskName: list[index].taskName,
  //                         area:  list[index].area,
  //                         pjsn:  list[index].pjsn,
  //                         arsn:  list[index].arsn,
  //                         startDate:  list[index].planningDate.toDouble(),
  //                         endDate:  list[index].scheduleDate.toDouble(),
  //                         tasksn:  list[index].tasksn,
  //                         taskcgsn:  list[index].taskcgsn,
  //                       )))
  //                       .then((value) => _refresh());
  //                 },
  //                 child: Container(
  //                     margin: const EdgeInsets.only(
  //                         left: 10, right: 10, top: 5.0, bottom: 5.0),
  //                     padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.grey.withOpacity(0.5),
  //                           spreadRadius: 3,
  //                           blurRadius: 5,
  //                           offset: Offset(0, 3), // changes position of shadow
  //                         ),
  //                       ],
  //                     ),
  //                     child: Row(
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         Visibility(
  //                           visible: _setRedCircleIconType(list[index]),
  //                           child: Container(
  //                             margin: const EdgeInsets.only(left: 10.0),
  //                             child: Icon(Icons.circle,
  //                                 size: 24.0, color: Colors.redAccent),
  //                           ),
  //                         ),
  //                         Visibility(
  //                           visible: _setGreenCheckIconType(list[index]),
  //                           child: Container(
  //                             margin: const EdgeInsets.only(left: 10.0),
  //                             child: Icon(Icons.check,
  //                                 size: 24.0, color: Colors.green),
  //                           ),
  //                         ),
  //                         Expanded(
  //                           child: Container(
  //                             margin: const EdgeInsets.only(left: 10.0),
  //                             child: Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               mainAxisSize: MainAxisSize.min,
  //                               children: [
  //                                 Container(
  //                                   child: Text(
  //                                     '${ list[index].taskName.trim()}',
  //                                     style: TextStyle(color: Colors.black),
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   margin: const EdgeInsets.only(top: 3.0),
  //                                   child: Text(
  //                                     '${list[index].area.trim()}',
  //                                     style: TextStyle(
  //                                         color: Colors.black,
  //                                         fontWeight: FontWeight.bold),
  //                                   ),
  //                                 )
  //                               ],
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //       else{
  //         return _noResultView();
  //       }
  //     },
  //   );
  // }

  Widget _buildChips() {
    List<Widget> chips = new List();

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: selectedIndex == i,
        label: Container(
            width: 100,
            child: Text(
              _options[i],
              style: TextStyle(
                  color: selectedIndex == i ? Colors.white : Colors.black45,
                  fontSize: 12),
              textAlign: TextAlign.center,
            )),
        shape: StadiumBorder(
            side: selectedIndex != i
                ? BorderSide(color: Colors.black45, width: 0.5)
                : BorderSide(color: Colors.redAccent, width: 0.5)),
        selectedColor: Colors.redAccent,
        backgroundColor: Colors.white,
        pressElevation: 1.0,
        onSelected: (bool selected) {
          if (selected) {
            setState(() {
              selectedIndex = i;
              _getTotalList(convertedTimeStamp);
            });
          }
        },
      );
      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5), child: choiceChip));
    }

    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      childAspectRatio: 3.0,
      mainAxisSpacing: 2.0,
      crossAxisSpacing: 1.0,
      crossAxisCount: 3,
      children: chips,
    );
  }

  void _choiceAction(String choice) {
    if (choice == Common.enquiry) {
      //TODO
    } else if (choice == Common.signOut) {
      _showLogoutDialog();
    }
  }

  void _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text("Are you sure you want to sign out?"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    Common.no,
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text(
                    Common.yes,
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                  onPressed: () {
                    _logout();
                  },
                ),
              ],
            ));
  }

  void _displayMonthlyCalendar(BuildContext context) {
    showMonthlyPicker(
            context: context,
            firstDate: DateTime(DateTime.now().year - 5, 1),
            lastDate: DateTime(DateTime.now().year + 5, 12),
            initialDate: selectedDate ?? widget.initialDate,
            locale: Locale(_setLocaleForCalendar()))
        .then((date) {
      if (date != null) {
        isLoading = true;
        selectedDate = date;
        calendarController.text = DateFormat.yMMM().format(date);

        // get selected month start from 1
        final firstDateOfSelectedMonth = DateTime.utc(date.year, date.month, 1);
        convertedTimeStamp = Common().convertToOADate(firstDateOfSelectedMonth);

        total.totalList.clear();
        completed.completedList.clear();
        pending.pendingList.clear();

        _getTotalList(convertedTimeStamp);
        _scrollToTop();
      }
    });
  }

  String _setLocaleForCalendar() {
    if (Platform.localeName.split('_')[0] != null) {
      return Platform.localeName.split('_')[0];
    } else {
      return 'en';
    }
  }

  void showAreaPopupDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopupAreaDialog(key: areaKey, areaResultList: areaList);
        }).then((value) => updateTextFieldArea());
  }

  void showTaskPopupDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return PopupTaskDialog(key: taskKey, taskResultList: taskList);
        }).then((value) => updateTextFieldTask());
  }

  bool _setRedCircleIconType(
      Fnc_TaskScheduleSummaryResult taskScheduleSummaryList) {
    // pending = cancel + completed - show green
    // pending != cancel + completed - show red
    int pending = taskScheduleSummaryList.pending;

    if (pending >= 1) {
      return true;
    } else {
      return false;
    }
  }

  bool _setGreenCheckIconType(
      Fnc_TaskScheduleSummaryResult taskScheduleSummaryList) {
    // pending = cancel + completed - show green
    // pending != cancel + completed - show red
    int pending = taskScheduleSummaryList.pending;

    if (pending == 0) {
      return true;
    } else {
      return false;
    }
  }

  updateTextFieldArea() async {
    if (areaKey.currentState.checkBoxParentArea.getIsCheckParent() == true) {
      areaController.text = Common.all;
      isClearAreaList = false;
      if (areaKey.currentState.isClickedOkArea) {
        await _getTotalList(convertedTimeStamp);
        setState(() {});
      }
    } else {
      List<String> displayList = areaKey.currentState.displayTextList;
      List<Fnc_TaskScheduleSummaryResult> filteredTotalList =
          List<Fnc_TaskScheduleSummaryResult>();
      List<Fnc_TaskScheduleSummaryResult> filteredPendingList =
          List<Fnc_TaskScheduleSummaryResult>();
      List<Fnc_TaskScheduleSummaryResult> filteredCompletedList =
          List<Fnc_TaskScheduleSummaryResult>();

      filteredTotalList.clear();
      filteredPendingList.clear();
      filteredCompletedList.clear();

      isFilteringArea = true;
      isClearAreaList = false;

      if (displayList.length != 0) {
        await _getTotalList(convertedTimeStamp);
        String finalString = displayList.reduce((value, element) {
          return value + " ," + element;
        });
        for (int i = 0; i < total.totalList.length; i++) {
          for (int j = 0; j < displayList.length; j++) {
            if (total.totalList[i].area == displayList[j]) {
              filteredTotalList.add(total.totalList[i]);
            }
          }
        }
        for (int i = 0; i < pending.pendingList.length; i++) {
          for (int j = 0; j < displayList.length; j++) {
            if (pending.pendingList[i].area == displayList[j]) {
              filteredPendingList.add(pending.pendingList[i]);
            }
          }
        }
        for (int i = 0; i < completed.completedList.length; i++) {
          for (int j = 0; j < displayList.length; j++) {
            if (completed.completedList[i].area == displayList[j]) {
              filteredCompletedList.add(completed.completedList[i]);
            }
          }
        }
        total.totalList.clear();
        pending.pendingList.clear();
        completed.completedList.clear();
        total.setTotalList(filteredTotalList);
        pending.setPendingList(filteredPendingList);
        completed.setCompletedList(filteredCompletedList);

        areaController.text = finalString;
        _scrollToTop();
        setState(() {});
      } else {
        if (areaKey.currentState.isClickedOkArea) {
          total.totalList.clear();
          pending.pendingList.clear();
          completed.completedList.clear();

          isFilteringArea = false;
          isClearAreaList = true;
          areaController.text = "";
          setState(() {});
        }
      }
    }
  }

  updateTextFieldTask() async {
    if (taskKey.currentState.checkBoxParentTask.getIsCheckParent() == true) {
      taskController.text = Common.all;
      isClearTaskList = false;
      if (taskKey.currentState.isClickedOkTask) {
        await _getTotalList(convertedTimeStamp);
        setState(() {});
      }
    } else {
      List<String> displayList = taskKey.currentState.displayTextList;
      List<Fnc_TaskScheduleSummaryResult> filteredTotalList =
          List<Fnc_TaskScheduleSummaryResult>();
      List<Fnc_TaskScheduleSummaryResult> filteredPendingList =
          List<Fnc_TaskScheduleSummaryResult>();
      List<Fnc_TaskScheduleSummaryResult> filteredCompletedList =
          List<Fnc_TaskScheduleSummaryResult>();

      filteredTotalList.clear();
      filteredPendingList.clear();
      filteredCompletedList.clear();

      isFilteringTask = true;
      isClearTaskList = false;

      if (displayList.length != 0) {
        await _getTotalList(convertedTimeStamp);
        String finalString = displayList.reduce((value, element) {
          return value + " ," + element;
        });
        for (int i = 0; i < total.totalList.length; i++) {
          for (int j = 0; j < displayList.length; j++) {
            if (total.totalList[i].taskName == displayList[j]) {
              filteredTotalList.add(total.totalList[i]);
            }
          }
        }
        for (int i = 0; i < pending.pendingList.length; i++) {
          for (int j = 0; j < displayList.length; j++) {
            if (pending.pendingList[i].taskName == displayList[j]) {
              filteredPendingList.add(pending.pendingList[i]);
            }
          }
        }
        for (int i = 0; i < completed.completedList.length; i++) {
          for (int j = 0; j < displayList.length; j++) {
            if (completed.completedList[i].taskName == displayList[j]) {
              filteredCompletedList.add(completed.completedList[i]);
            }
          }
        }
        total.totalList.clear();
        pending.pendingList.clear();
        completed.completedList.clear();
        total.setTotalList(filteredTotalList);
        pending.setPendingList(filteredPendingList);
        completed.setCompletedList(filteredCompletedList);

        taskController.text = finalString;
        _scrollToTop();
        setState(() {});
      } else {
        if (taskKey.currentState.isClickedOkTask) {
          total.totalList.clear();
          pending.pendingList.clear();
          completed.completedList.clear();

          isFilteringTask = false;
          isClearTaskList = true;
          taskController.text = "";
          setState(() {});
        }
      }
    }
  }

  void _scrollToTop() {
    scrollController.animateTo(0,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  void _refresh() {
    _scrollToTop();
    // _getTotalList(convertedTimeStamp);
  }

  Future<void> _logout() async {
    SPHelper.remove(SPHelper.userInfo);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
  }
}
