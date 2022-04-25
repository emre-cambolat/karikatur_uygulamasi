import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> fetchData({required String url}) async {
    final http.Response response = await http.get(
      Uri.parse(Uri.encodeFull(url)),
      // headers: {
      //   "token": "${ApiConstants.TOKEN_VALUE}",
      // },
    );
    if (response.statusCode == 200) {
      debugPrint("$url: " + response.body);
      return response.body;
    } else {
      throw Exception(
        "İstek durumu başarısız oldu. Hata kodu: ${response.statusCode}",
      );
    }
  }
}
