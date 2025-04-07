// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

import 'api_consumer.dart';

class GoogleApiConsumer extends ApiConsumer {
  final Dio dio;

  GoogleApiConsumer({
    required this.dio,
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
        bool refresh = false,}) async {
    try {
      // dio.options.baseUrl ;
      final result = await dio.get(url,
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: headers));
      if (result.data['status'] == 'OK') {
        return Right(result.data['results'][0] as Map<String, dynamic>);
      } else {
        return Left(ValidationFailure(result.data['error_message'] ??
            "Unkown Error, Please Try Again Later"));
      }
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  Failure _getFailure(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 401) {
        return const UnauthorizedFailure('');
      } else if (e.response?.statusCode == 400) {
        if (e.response?.data is Map &&
            e.response?.data['error_message'] is String) {
          return ServerFailure(message: e.response?.data['error_message'],
            name: e.response?.data['name'] as String? ?? 'Unknown Error',
          );
        } else {
          return const ServerFailure(
              message: "Unkown Error, Please Try Again Later",
            name:  'Unknown Error',
          );
        }
      }
    }
    return UnknownFailure(e);
  }

  @override
  void attachToken(UserTokensEntity? token) {
    // TODO: implement attachToken
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
        bool refresh = false,}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  // TODO: implement isTokenAttached
  bool get isTokenAttached => throw UnimplementedError();

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(String url,
      {Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
        bool refresh = false,}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
        bool refresh = false,}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers,
        bool refresh = false,}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  void removeTokenFromHeader() {
    // TODO: implement removeTokenFromHeader
  }
}
