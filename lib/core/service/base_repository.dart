import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/service/custom_response.dart';

class BaseRepository<T> {
  // Constructor
  BaseRepository();

  Future<Either<ServerFailure, CustomResponse<T>>> repository(
    Future dataSource, {
    required T Function(dynamic json) fromJsonT,
  }) async {
    try {
      // Await the response from the data source
      Response response = await dataSource;

      log(response.data.toString(), name: 'ResponseData');

      // Parse the response data
      CustomResponse<T> data = CustomResponse.fromJson(
        response.data,
        fromJsonT,
      );

      // Check response status and return the appropriate result
      if (response.statusCode == 200 && data.status) {
        return right(data);
      } else {
        return left(ServerFailure(message: data.message));
      }
    } catch (error) {
      log(error.toString(), name: 'Error');
      return left(ServerFailure(message: error.toString()));
    }
  }
}
