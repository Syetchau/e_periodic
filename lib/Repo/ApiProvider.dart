import 'dart:convert';
import 'dart:io';

import 'package:e_periodic/Common/Common.dart';
import 'package:http/http.dart' as http;

import 'HttpException.dart';

class ApiProvider{
  // next three lines makes this class a Singleton
  static ApiProvider _instance = new ApiProvider.internal();
  ApiProvider.internal();
  factory ApiProvider() => _instance;

  // Future<dynamic> get(String url) async {
  //   var responseJson;
  //   try {
  //     final response = await http.get(Common.baseURL + url);
  //     responseJson = _response(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return responseJson;
  // }
  //
  // Future<dynamic> post(String url) async {
  //   var responseJson;
  //   try {
  //     final response = await http.post((Common.baseURL + url)); //TODO: add post body / headers
  //     responseJson = _response(response);
  //   } on SocketException {
  //     throw FetchDataException('No Internet connection');
  //   }
  //   return responseJson;
  // }

  Future<http.Response> getHTTPResponse(String url) async {
    var response = await http.get(Common.baseURL + url,
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<http.Response> postHTTPResponse(String url, String body) async {
    var response = await http.post(Common.baseURL + url,
        headers: {"Content-Type": "application/json"}, body: body);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(response.statusCode);
    }
  }

  // dynamic _response(http.Response response) {
  //   switch (response.statusCode) {
  //     case 200:
  //       var responseJson = json.decode(response.body.toString());
  //       // print(responseJson);
  //       return responseJson;
  //     case 400:
  //       throw BadRequestException(response.body.toString());
  //     case 401:
  //     case 403:
  //       throw UnauthorisedException(response.body.toString());
  //     case 500:
  //     default:
  //       throw FetchDataException(
  //           'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
  //   }
  // }
}