import 'dart:convert';

import 'package:followup/GlobalVariables.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SyncData {
  Future<List> downloadData(String? url) async {
    var conResult = await Connectivity().checkConnectivity();

    if (conResult == ConnectivityResult.none) {
      return ["You are not connected to the network"];
    } else {
      final apiUrl =
          "${GlobalVariables.SERVER_URL!}${url}"; // Replace with your API endpoint URL

      try {
        final response = await Dio().get(
          apiUrl,
          options: Options(
            contentType: "application/json",
            responseType: ResponseType.json,
          ),
        );

        if (response.statusCode == 200) {
          print(response.data);
          return response.data;
        } else {
          print('Error: ${response.statusCode}');
          return [null];
        }
      } catch (e) {
        print('Error: $e');
        return [e.toString()];
      }
    }
  }
}
