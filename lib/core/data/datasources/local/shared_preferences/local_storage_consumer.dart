import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../error/failure.dart';

abstract class LocalStorageConsumer {
  const LocalStorageConsumer();

  Future<Either<Failure, String?>> get({
    required String key,
  });

  Future<Either<Failure, bool>> save({
    required String key,
    String? value,
  });

  Future<Either<Failure, bool>> delete({
    required String key,
  });
}

class BaseLocalStorageConsumer extends LocalStorageConsumer {
  final FlutterSecureStorage storage;

  const BaseLocalStorageConsumer({
    required this.storage,
  });

  @override
  Future<Either<Failure, bool>> delete({
    required String key,
  }) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      log(e.toString());
    }
    return const Left(CacheFailure());
  }

  @override
  Future<Either<Failure, String?>> get({
    required String key,
  }) async {
    try {
      final result = await storage.read(key: key);
      return Right(result);
    } catch (e) {
      log(e.toString());
    }
    return const Left(CacheFailure());
  }

  @override
  Future<Either<Failure, bool>> save({
    required String key,
    String? value,
  }) async {
    try {
      await storage.write(key: key, value: value);
      return const Right(true);
    } catch (e) {
      log(e.toString());
    }
    return const Left(CacheFailure());
  }
}
