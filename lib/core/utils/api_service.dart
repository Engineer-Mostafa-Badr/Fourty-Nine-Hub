import 'package:dio/dio.dart';

class ApiService {
  final String _baseUrl = 'https://49dev.com/';

  final Dio dio;

  ApiService(this.dio);

  Future<Map<String,dynamic>> get({
    required String url,
    String? token,
  }) async {
    var response = await dio.get(
      '$_baseUrl$url',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        },
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


  Future<Map<String,dynamic>> delete({
    required String url,
    String? token,
  }) async {
    var response = await dio.delete(
      '$_baseUrl$url',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        },
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