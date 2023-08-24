import 'dart:convert';

import 'package:http/http.dart' as http;

class SQLFunctions {
  static Future<http.Response> sendQuery({required String query}) async {
    final queryParameters = {
      "Password": "n1yrefrb0p0tyoussif26dec",
      "Query": query,
    };
    var jsonResult = json.encode(queryParameters);
    var url = Uri.parse('https://spain-city.com/SQLFunctions/');
    var response = await http.post(url, body: jsonResult, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      "accept": "*/*",
      "Access-Control-Allow-Headers": "*",
      "Access-Control-Allow-Methods": "*",
      "Access-Control-Allow-Origin": "*"
    });
    return response;
  }
}
