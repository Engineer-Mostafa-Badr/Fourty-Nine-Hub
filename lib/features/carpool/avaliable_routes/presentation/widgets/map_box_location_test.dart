import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MapBox {
  static Future<Map<String, dynamic>> signIn({
    required BuildContext context,
    required String text,
    required String password,
  }) async {
    try {
      String url =
          'https://api.mapbox.com/search/geocode/v6/forward?q=$text&access_token=sk.eyJ1IjoiNDlhcHAiLCJhIjoiY20xem83MGQ5MDg3aDJqczhhYnlmMGI1ZSJ9.8sYHBUyxYXncueYcckCBMg';

      Response response = await Dio().get(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      // Parse the response data
      Map<String, dynamic> data = response.data;
      return data;
    } catch (error) {
      // Handle any errors that occur during the API call
      return {"error": "An error occurred during sign in."};
    }
  }
}
