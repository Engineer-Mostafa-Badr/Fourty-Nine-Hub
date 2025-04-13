import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/call/data/models/agora_info_model.dart';
import 'package:fourtyninehub/features/call/domain/usecases/get_agora_token_usecase.dart';
import 'package:http/http.dart' as http;

abstract class CallRemoteDatasource {
  Future<Either<Exception, AgoraInfoModel>> getAgoraToken(
      GetAgoraTokenParams params);
}

class CallRemoteDatasourceImpl implements CallRemoteDatasource {
  @override
  Future<Either<Exception, AgoraInfoModel>> getAgoraToken(
      GetAgoraTokenParams params) async {
    try {
      final token = "";
      // await CacheManager.getAccessToken();
      Map<String, String> headers = {'Content-Type': 'application/json'};
      headers.addAll({'Authorization': 'Bearer $token'});
      http.Response response = await http.post(
        Uri.parse(
          EndPoints.productionBaseUrl+ EndPoints.whatsAppAgoraToken),
        headers: headers,
      );

      print("Response of getAgoraToken: ${response.statusCode} %% ${response.body}");

      if (response.statusCode > 199 &&
          response.statusCode < 300 &&
          response.body.isNotEmpty) {
        var body = jsonDecode(response.body);
        print("The body of agora is ${body['data']}");
        return Right(AgoraInfoModel.fromJson(body['data'] as Map<String, dynamic>));
      }

      return Left(Exception('Unable to get required data to initiate call'));
    } catch (e) {
      return Left(Exception('Unable to get required data to initiate call $e'));
    }
  }
}
