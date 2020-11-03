import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Common{
  final startOfTime = DateTime(1899, 12, 30);
  static const String loginHeaderName = "ePeriodic";
  static const String login = "Login";
  static const String version = "Version";
  static const String username = "Username";
  static const String password = "Password";
  static const double appBarHeight = 45.0;
  static const String enquiry = "Enquiry";
  static const String signOut = "Sign out";
  static const String invalidLogin = "Invalid username or password";
  static const String ok = "OK";
  static const String yes = "YES";
  static const String no = "NO";
  static const String cancel = "CANCEL";
  static const String requiredMsg = "This field is required";
  static const String filter = "Filter";
  static const String status = "Status";
  static const String dateRange = "Date Range";
  static const String area = "Area";
  static const String task = "Task";
  static const String selectTradingMonth = "Select trading month";
  static const String selectAll = "Select All";
  static const String all = "All";
  static const String noTask = "No task available.";
  static const String startTime = "Start Time";
  static const String endTime = "End Time";
  static const String copyright = "Copyright @2020 EF Software Pte.Ltd.All Rights Reserved.";
  static const String baseURL = "http://efsoftware.dyndns.org:93/ePeriodicSchedule-skh-WS/";

  //login
  static const String loginURL = "SVSchedule.svc/fnc_login?";

  //projectList
  static const String projectListURL = "SVSchedule.svc/fnc_ProjectList";

  //areaList
  static const String areaListURL = "SVSchedule.svc/fnc_Area?";

  //taskList
  static const String taskListURL = "SVSchedule.svc/fnc_TaskList?";

  //TaskScheduleSummary
  static const String taskScheduleSummaryURL = "SVSchedule.svc/fnc_TaskScheduleSummary?";

  //TaskScheduleDetail
  static const String taskScheduleDetailURL = "SVSchedule.svc/fnc_TaskScheduleDetailList?";

  //ItemSchedule
  static const String itemTaskScheduleSummaryURL = "SVItemSchedule.svc/fnc_Item_Task_ScheduleSummary?";

  //ItemTaskScheduleDetail
  static const String itemTaskScheduleDetailURL = "SVItemSchedule.svc/fnc_Item_Task_ScheduleDetailList?";

  static const List<String> choices = <String>[
    enquiry,signOut
  ];

  static const TextStyle versionTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
  );

  static const TextStyle cardLabelTextStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
  );

  static const InputDecoration cardEditTextDeco = InputDecoration(
      isDense: true,
      labelStyle: TextStyle(color: Colors.black),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey))
  );

  double microsoftTimeStamp(DateTime date) {
    final diff = date.difference(startOfTime);
    return diff.inDays + ((diff - Duration(days: diff.inDays)).inSeconds / 86400);
  }

  DateTime convertFromOADate(double dblDate) {
    var days = dblDate.toInt();
    // Treat decimal part as part of 24hr day, always +ve
    var ms = ((dblDate - days) * 8.64e7).abs();
    // Add days and add ms
    return new DateTime(1899, 12, 30 + days, 0, 0, 0, ms.toInt());
  }

  double convertToOADate(DateTime dateTime) {
    var temp =
    new DateTime(dateTime.year, dateTime.month, dateTime.day).toUtc();
    // Set temp to start of day and get whole days between dates,
    var days =
    (temp.difference(new DateTime(1899, 12, 30).toUtc()).inMilliseconds /
        8.64e7)
        .round();
    // Get decimal part of day, OADate always assumes 24 hours in day
    var partDay =
    ((dateTime.difference(temp).inMilliseconds % 8.64e7).abs() / 8.64e7);
    return days+ double.parse(partDay.toStringAsFixed(10));
  }
}

