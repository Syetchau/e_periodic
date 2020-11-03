import 'dart:convert';
import 'dart:developer';

import 'package:e_periodic/Common/Common.dart';
import 'package:e_periodic/Model/User.dart';
import 'package:e_periodic/Repo/ApiProvider.dart';
import 'package:e_periodic/Repo/SPHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEmptyUser = false;
  bool isEmptyPassword = false;
  bool showLoading = false;
  String version = "";
  String etUsername;
  String etPassword;

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  Future<void> _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // appName = packageInfo.appName;
    // packageName = packageInfo.packageName;
    version = packageInfo.version;
    // buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/bg.png"),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0, bottom: 0),
                      height: 100,
                      child: Image.asset("assets/ic_isslogo.png")),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(left: 15.0, top: 20.0, right: 15.0, bottom: 15.0),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left:10.0,right: 10.0, top: 15.0),
                          child: Text(Common.loginHeaderName, style: TextStyle(
                              color: Colors.green,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left:10.0, right: 10.0),
                              child: TextFormField(
                                controller: usernameController,
                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 15),
                                  alignLabelWithHint: true,
                                  hintText: Common.username,
                                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.greenAccent),
                                  hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                                onChanged: (value){
                                  if(value.isEmpty){
                                    isEmptyUser = true;
                                  } else{
                                    isEmptyUser = false;
                                  }
                                  etUsername = value;
                                  setState(() {});
                                },
                                onFieldSubmitted: (value){
                                  if(value.isEmpty){
                                    isEmptyUser = true;
                                    _showEmptyDetails();
                                  } else{
                                    isEmptyUser = false;
                                  }
                                  etUsername = value;
                                  setState(() {});
                                },
                              ),
                            ),
                            Visibility(
                              visible: isEmptyUser,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    margin: const EdgeInsets.only(right: 15.0, top: 15.0),
                                    child: Image.asset("assets/ic_warning.png", color: Colors.red,)),
                              ),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left:10.0, right: 10.0, bottom: 10.0),
                              child: TextFormField(
                                controller: passwordController,
                                obscureText: true,
                                style: TextStyle(fontSize: 14.0, color: Colors.black),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 15),
                                  alignLabelWithHint: true,
                                  hintText: Common.password,
                                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.greenAccent),
                                  hintStyle: TextStyle(fontSize: 12.0, color: Colors.grey),
                                ),
                                onChanged: (value){
                                  if(value.isEmpty){
                                    isEmptyPassword = true;
                                  } else{
                                    isEmptyPassword = false;
                                  }
                                  etPassword = value;
                                  setState(() {});
                                },
                                onFieldSubmitted: (value){
                                  if(value.isEmpty){
                                    isEmptyPassword = true;
                                    _showEmptyDetails();
                                  } else{
                                    isEmptyPassword = false;
                                  }
                                  etPassword = value;
                                  setState(() {});
                                },
                              ),
                            ),
                            Visibility(
                              visible: isEmptyPassword,
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                    margin: const EdgeInsets.only(right: 15.0, top: 15.0),
                                    child: Image.asset("assets/ic_warning.png", color: Colors.red,)),
                              ),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showLoading = true;
                              executeLogin(etUsername, etPassword);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10.0),
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(Common.login,
                                  style: TextStyle(color: Colors.white, fontSize: 18.0)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(Common.version+" "+version, style: Common.versionTextStyle),
                      ),
                      Container(
                        child: Text(Common.copyright, style: Common.versionTextStyle),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: showLoading,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(187, 187, 187, 1)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> executeLogin(String username, String password) async{

    String url = Common.loginURL+"_username=$username"+"&"+"_password=$password";

    if(username == null || username == "" && password == null || password == ""){
      setState(() {
        isEmptyUser = true;
        isEmptyPassword = true;
        showLoading = false;
        _showEmptyDetails();
      });
    } else if(username == null || username == ""){
      setState(() {
        isEmptyUser = true;
        showLoading = false;
        _showEmptyDetails();
      });
    } else if(password == null || password == ""){
      setState(() {
        isEmptyPassword = true;
        showLoading = false;
        _showEmptyDetails();
      });
    } else {
      await ApiProvider().getHTTPResponse(url).then((response) async{
        setState(() {
          if(response.statusCode == 200){
            User user = new User();
            Map<String, dynamic> resultMap = json.decode(response.body);
            user.username = resultMap["fnc_LoginResult"]["_username"];
            user.usn = resultMap["fnc_LoginResult"]["_usn"];
            user.serverDate = resultMap["fnc_LoginResult"]["_serverDate"];
            user.privilege = resultMap["fnc_LoginResult"]["_privilege"];
            user.pjsn = resultMap["fnc_LoginResult"]["_pjsn"];
            user.name = resultMap["fnc_LoginResult"]["_name"];
            user.accessAll = resultMap["fnc_LoginResult"]["_accessAll"];

            if(user.username != null && user.username == username){
              showLoading = false;
              _navigateToHomePage(user);
            } else{
              showLoading = false;
              _showLoginErrorDialog();
            }
          }
          else{
            showLoading = false;
            throw Exception(response.statusCode);
          }
        });
      },onError: (error){
        showLoading = false;
        log('callUserLoginError : $error');
      });
    }
  }

  void _showEmptyDetails(){
    Fluttertoast.showToast(
        msg: Common.requiredMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void _showLoginErrorDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text(Common.invalidLogin, style: TextStyle(color: Colors.black),),
          actions: <Widget>[
            FlatButton(
              child: Text(Common.ok, style: TextStyle(color: Colors.greenAccent),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  Future<void> _navigateToHomePage(User user) async {
    SPHelper.save(SPHelper.userInfo, user);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext ctx) =>
            HomePage(initialDate: DateTime.now())));
  }
}
