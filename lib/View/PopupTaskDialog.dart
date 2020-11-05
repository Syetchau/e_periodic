import 'package:e_periodic/Common/Common.dart';
import 'package:e_periodic/Model/CheckBoxParentTask.dart';
import 'package:e_periodic/Model/Task.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomLabeledCheckbox.dart';

class PopupTaskDialog extends StatefulWidget {
  final List<Fnc_TaskListResult> taskResultList;

  PopupTaskDialog({Key key, this.taskResultList}) : super(key: key);

  @override
  PopupTaskDialogState createState() => PopupTaskDialogState();
}

class PopupTaskDialogState extends State<PopupTaskDialog> {
  TextEditingController taskSearchController = TextEditingController();
  CheckBoxParentTask checkBoxParentTask = CheckBoxParentTask();
  List<bool> childrenValue;
  List<Fnc_TaskListResult> taskNameList = List<Fnc_TaskListResult>();
  List<Fnc_TaskListResult> checkedList = List<Fnc_TaskListResult>();
  List<String> displayTextList = List<String>();
  bool isClickedOkTask = false;

  @override
  void initState() {
    super.initState();
    taskNameList.addAll(widget.taskResultList);
    checkedList.addAll(widget.taskResultList);
    _getChkBoxStatus();
  }

  @override
  void dispose() {
    super.dispose();
    taskSearchController.dispose();
  }

  void _getChkBoxStatus() {
    checkBoxParentTask.getIsCheckParent();
    childrenValue = List.generate(taskNameList.length,
            (index) => taskNameList[index].getIsCheckChild());
    if(childrenValue.contains(false)) {
      checkBoxParentTask.setIsCheckParent(false);
    }
  }

  void _manageTristate(int index, bool value) {
    setState(() {
      if (value) {
        // selected
        childrenValue[index] = true;
        taskNameList[index].setIsCheckChild(true);
        // Checking if all other children are also selected -
        if (childrenValue.contains(false)) {
          // No. Parent -> tristate.
          checkBoxParentTask.setIsCheckParent(false);
        } else {
          // Yes. Select all.
          _checkAll(true);
        }
      } else {
        // unselected
        childrenValue[index] = false;
        taskNameList[index].setIsCheckChild(false);
        // Checking if all other children are also unselected -
        if (childrenValue.contains(true)) {
          // No. Parent -> tristate.
          checkBoxParentTask.setIsCheckParent(false);
        } else {
          // Yes. Unselect all.
          _checkAll(false);
        }
      }
    });
  }

  void _checkAll(bool value) {
    setState(() {
      checkBoxParentTask.setIsCheckParent(value);
      for (int i = 0; i < widget.taskResultList.length; i++) {
        childrenValue[i] = value;
        taskNameList[i].setIsCheckChild(childrenValue[i]);
      }
      notifyParent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text('${Common.task}',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  child: TextFormField(
                    controller: taskSearchController,
                    autocorrect: false,
                    decoration: InputDecoration(
                        icon: Icon(Icons.search, color: Colors.grey, size: 24),
                        isDense: true,
                        labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey))),
                    onChanged: (value) {
                      filterTaskListResult(value);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: CustomLabeledCheckbox(
                    label: Common.selectAll,
                    value: checkBoxParentTask.getIsCheckParent(),
                    onChanged: (value) {
                      if (value != null) {
                        // Checked/Unchecked
                        setState(() => _checkAll(value));
                      } else {
                        // Tristate
                        setState(() => _checkAll(true));
                      }
                    },
                    checkboxType: CheckboxType.Parent,
                    activeColor: Colors.greenAccent,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0, top: 80),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) => CustomLabeledCheckbox(
                            label: taskNameList[index].taskName,
                            value: taskNameList[index].isChecked,
                            onChanged: (value) {
                              setState(() => _manageTristate(index, value));
                            },
                            checkboxType: CheckboxType.Child,
                            activeColor: Colors.greenAccent,
                          ),
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFFd6d6d6)),
                      itemCount: taskNameList.length),
                )
              ],
            ),
          );
        },
      ),
      actions: <Widget>[
        FlatButton(
          child:
              Text(Common.cancel, style: TextStyle(color: Colors.greenAccent)),
          onPressed: () {
            notifyParent();
            isClickedOkTask = false;
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(
            Common.ok,
            style: TextStyle(color: Colors.greenAccent),
          ),
          onPressed: () {
            notifyParent();
            isClickedOkTask = true;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void filterTaskListResult(String query) {
    List<Fnc_TaskListResult> fullList = List<Fnc_TaskListResult>();
    fullList.addAll(widget.taskResultList);
    if (query.isNotEmpty) {
      List<Fnc_TaskListResult> filteredList = List<Fnc_TaskListResult>();
      fullList.forEach((item) {
        if (item.taskName.toLowerCase().contains(query)) {
          filteredList.add(item);
        }
      });
      setState(() {
        taskNameList.clear();
        taskNameList.addAll(filteredList);
      });
      return;
    } else {
      setState(() {
        taskNameList.clear();
        taskNameList.addAll(fullList);
      });
    }
  }

  notifyParent() {
    if (checkBoxParentTask.getIsCheckParent() == true) {
      checkedList.clear();
      checkedList.addAll(widget.taskResultList);
    } else {
      checkedList.clear();
      displayTextList.clear();
      for(int i = 0; i< taskNameList.length; i++){
        if(taskNameList[i].isChecked == true){
          checkedList.add(taskNameList[i]);
        }
      }
      for(int j = 0; j < checkedList.length; j++){
        String area = checkedList[j].taskName;
        displayTextList.add(area);
      }
    }
  }
}
