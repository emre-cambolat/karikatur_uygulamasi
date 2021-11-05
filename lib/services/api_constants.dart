import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

// https://labkod.net/meram/meramAPI/getToken
class ApiConstants {
  static Future<String> getToken() async {
    if (API_LINK.isNotEmpty) {
      var response = await http.get(Uri.parse(API_LINK));
      var gelenCevap = json.decode(response.body);
      TOKEN_VALUE = gelenCevap["token"];
      debugPrint("Token: "+gelenCevap["token"]);
      return TOKEN_VALUE;
    }
    else{
      debugPrint("Error! 'API_LINK' is Empty.");
      return "Error! 'API_LINK' is Empty.";
    }
  }

  static String API_LINK = "";
  static String TOKEN_VALUE = "";
}
