import 'package:e_periodic/Common/Common.dart';
import 'package:e_periodic/Model/Area.dart';
import 'package:e_periodic/Model/CheckBoxParentArea.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CustomLabeledCheckbox.dart';

class PopupAreaDialog extends StatefulWidget {
  final List<Fnc_AreaResult> areaResultList;

  PopupAreaDialog({Key key, this.areaResultList}) : super(key: key);

  @override
  PopupAreaDialogState createState() => PopupAreaDialogState();
}

class PopupAreaDialogState extends State<PopupAreaDialog> {
  TextEditingController areaSearchController = TextEditingController();
  CheckBoxParentArea checkBoxParentArea = CheckBoxParentArea();
  List<bool> childrenValue;
  List<Fnc_AreaResult> areaNameList = List<Fnc_AreaResult>();
  List<Fnc_AreaResult> checkedList = List<Fnc_AreaResult>();
  List<String> displayTextList = List<String>();
  bool isClickedOkArea = false;

  @override
  void initState() {
    super.initState();
    areaNameList.addAll(widget.areaResultList);
    checkedList.addAll(widget.areaResultList);
    _getChkBoxStatus();
  }

  @override
  void dispose() {
    super.dispose();
    areaSearchController.dispose();
  }

   void _getChkBoxStatus() {
    checkBoxParentArea.getIsCheckParent();
    childrenValue = List.generate(areaNameList.length,
            (index) => areaNameList[index].getIsCheckChild());
    if(childrenValue.contains(false)) {
      checkBoxParentArea.setIsCheckParent(false);
    }
  }

  void _manageTristate(int index, bool value) {
    setState(() {
      if (value) {
        // selected
        childrenValue[index] = true;
        areaNameList[index].setIsCheckChild(true);
        // Checking if all other children are also selected -
        if (childrenValue.contains(false)) {
          // No. Parent -> tristate.
          checkBoxParentArea.setIsCheckParent(false);
        } else {
          // Yes. Select all.
          _checkAll(true);
        }
      } else {
        // unselected
        childrenValue[index] = false;
        areaNameList[index].setIsCheckChild(false);
        // Checking if all other children are also unselected -
        if (childrenValue.contains(true)) {
          // No. Parent -> tristate.
          checkBoxParentArea.setIsCheckParent(false);
        } else {
          // Yes. Unselect all.
          _checkAll(false);
        }
      }
    });
  }

  void _checkAll(bool value) {
    setState(() {
      checkBoxParentArea.setIsCheckParent(value);
      for (int i = 0; i < widget.areaResultList.length; i++) {
        childrenValue[i] = value;
        areaNameList[i].setIsCheckChild(childrenValue[i]);
      }
      notifyParent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        alignment: Alignment.centerLeft,
        child: Text('${Common.area}',
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
                    controller: areaSearchController,
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
                      filterAreaListResult(value);
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 40),
                  child: CustomLabeledCheckbox(
                    label: Common.selectAll,
                    value: checkBoxParentArea.getIsCheckParent(),
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
                            label: areaNameList[index].area,
                            value: areaNameList[index].isChecked,
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
                      itemCount: areaNameList.length),
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
            isClickedOkArea = false;
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
            isClickedOkArea = true;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void filterAreaListResult(String query) {
    List<Fnc_AreaResult> fullList = List<Fnc_AreaResult>();
    fullList.addAll(widget.areaResultList);
    if (query.isNotEmpty) {
      List<Fnc_AreaResult> filteredList = List<Fnc_AreaResult>();
      fullList.forEach((item) {
        if (item.area.toLowerCase().trim().contains(query)) {
          filteredList.add(item);
        }
      });
      setState(() {
        areaNameList.clear();
        areaNameList.addAll(filteredList);
      });
      return;
    } else {
      setState(() {
        areaNameList.clear();
        areaNameList.addAll(fullList);
      });
    }
  }

  void notifyParent() {
    if (checkBoxParentArea.getIsCheckParent() == true) {
      checkedList.clear();
      checkedList.addAll(widget.areaResultList);
    } else {
      checkedList.clear();
      displayTextList.clear();
      for(int i = 0; i< areaNameList.length; i++){
        if(areaNameList[i].isChecked == true){
          checkedList.add(areaNameList[i]);
        }
      }
      for(int j = 0; j < checkedList.length; j++){
        String area = checkedList[j].area;
        displayTextList.add(area);
      }
    }
  }
}
