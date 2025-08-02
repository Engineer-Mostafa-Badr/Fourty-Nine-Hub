import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = 'https://6db25d211280.ngrok-free.app/';

  final Dio dio;

  ApiService(this.dio);

  Future<dynamic> get({
    required String url,
    String? token,
    Map<String, dynamic>? params,
  }) async {
    var response = await dio.get(
      '$_baseUrl$url',
      options: Options(
        headers: {'Authorization': 'Bearer $token',
          "x-api-key": "2fef55aee2e4efa73d64120ecad8092262fd4f1b912ca1d5460d70a47eaf4684",
        },
      ),
      queryParameters: params,
    );
    // Check if the response is a Map or a List
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else if (response.data is List<dynamic>) {
      // Handle the case where the response is a List
      // You might need to adjust this based on your API response structure
      return {'data': response.data};
    } else {
      // Handle unexpected response types
      throw Exception('Unexpected response type');
    }
  }

  post({
    required String url,
    dynamic data,
    dynamic query,
    String? token,
  }) async {
    var response = await dio.post(
      '$_baseUrl$url',
      data: data,
      queryParameters: query,
      options: Options(
        headers: {'Authorization': 'Bearer $token',
          "x-api-key": "2fef55aee2e4efa73d64120ecad8092262fd4f1b912ca1d5460d70a47eaf4684",},
      ),
    );
    return response.data;
  }

  Future<Map<String, dynamic>> delete({
    required String url,
    String? token,
  }) async {
    var response = await dio.delete(
      '$_baseUrl$url',
      options: Options(
        headers: {'Authorization': 'Bearer $token', "x-api-key": "2fef55aee2e4efa73d64120ecad8092262fd4f1b912ca1d5460d70a47eaf4684",},
      ),
    );
    // Check if the response is a Map or a List
    if (response.data is Map<String, dynamic>) {
      return response.data as Map<String, dynamic>;
    } else if (response.data is List<dynamic>) {
      // Handle the case where the response is a List
      // You might need to adjust this based on your API response structure
      return {'data': response.data};
    } else {
      // Handle unexpected response types
      throw Exception('Unexpected response type');
    }
  }
}
