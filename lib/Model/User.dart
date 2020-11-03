import 'dart:convert';

List<User> userModelFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

class User{
  bool accessAll;
  String name;
  int pjsn;
  String privilege;
  int serverDate;
  String username;
  int usn;

  User({
    this.accessAll,
    this.name,
    this.pjsn,
    this.privilege,
    this.serverDate,
    this.username,
    this.usn
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    accessAll: json["_accessAll"],
    name: json["_name"],
    pjsn: json["_pjsn"],
    privilege: json["_privilege"],
    serverDate: json["_serverDate"],
    username: json["_username"],
    usn: json["_usn"]
  );

  Map<String, dynamic> toJson() => {
    '_accessAll': accessAll,
    '_name': name,
    '_pjsn': pjsn,
    '_privilege': privilege,
    '_serverDate': serverDate,
    '_username': username,
    '_usn': usn
  };
}