import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'remote/api/api_consumer.dart';

class JsonParser implements ApiConsumer {
  @override
  void attachToken(UserTokensEntity? token) {
    // TODO: implement attachToken
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> delete(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> get(String url,
      {Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers}) async {
    try {
      final response = jsonDecode(await rootBundle.loadString(url));

      return Right(response as Map<String, dynamic>);
    } catch (e) {
      return Left(_getFailure(e));
    }
  }

  @override
  // TODO: implement isTokenAttached
  bool get isTokenAttached => throw UnimplementedError();

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(String url,
      {Map<String, dynamic>? data,
      FormData? formData,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) {
    // TODO: implement put
    throw UnimplementedError();
  }

  Failure _getFailure(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 413) {
        return const ServerFailure(
          message: 'File size is too large',
        );
      } else if (e.response?.statusCode == 401) {
        return const UnauthorizedFailure();
      } else if (e.response?.data is Map &&
          e.response?.data['message'] is String) {
        return ServerFailure(
          message: e.response?.data['message'] as String,
        );
      } else if (e.response?.data is Map && e.response?.data['error'] is Map) {
        final error = e.response?.data['error'] as Map;
        List<String>? errors;
        if (error['data'] is List) {
          final data = e.response?.data['error']['data'] as List;
          errors = data
              .map((e) => e['message'] as String)
              .whereType<String>()
              .toList();
        }
        return ServerFailure(
          message: error['message'] as String,
          errors: errors,
        );
      } else if (e.response?.data is Map &&
          e.response?.data['data'] is String) {
        return ServerFailure(
          message: e.response?.data['data'] as String,
        );
      }
    }
    return UnknownFailure(e);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> patch(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? headers}) {
    // TODO: implement patch
    throw UnimplementedError();
  }
}
