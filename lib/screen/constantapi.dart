// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:convert';
import 'package:finance_user/functions/variables.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class constantapi {
  static Future<dynamic> CompleteCollection(String Amount) async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection/CompleteCollection'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'AgentId': store.read('id'),
          'collectionAmount': Amount,
        },
      ),
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Completed");
      }
    }
  }

  static Future<dynamic> collectionchecking() async {
    final http.Response response = await http.post(
      Uri.parse('$ip/collection//Collectioncheck'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print(response.body);
      }
      if (response.body == "Already Exist") {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
