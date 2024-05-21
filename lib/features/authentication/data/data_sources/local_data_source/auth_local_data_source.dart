import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/local_storage/local_storage_consumer.dart';

abstract class AuthLocalDataSource {
  Future<Either<Failure, bool>> saveUserTokens(UserTokensModel? userTokens);

  Future<Either<Failure, UserTokensModel?>> getUserTokens();

  Future<Either<Failure, bool>> deleteTokens();

  Future<Either<Failure, String?>> getLanguage();

  Future<Either<Failure, bool>> saveLanguage(String language);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorageConsumer _localStorage;

  const AuthLocalDataSourceImpl(this._localStorage);

  @override
  Future<Either<Failure, String?>> getLanguage() async {
    final result = await _localStorage.get(key: 'language');
    return result.fold(
      (_) => const Left(CacheFailure()),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<Failure, bool>> saveLanguage(String language) async {
    final result = await _localStorage.save(
      key: 'language',
      value: language,
    );
    return result.fold(
      (_) => const Left(CacheFailure()),
      (data) => const Right(true),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteTokens() async {
    final result = await _localStorage.delete(
      key: 'token',
    );
    return result.fold(
      (_) => const Left(CacheFailure()),
      (data) => const Right(true),
    );
  }

  @override
  Future<Either<Failure, UserTokensModel?>> getUserTokens() async {
    final result = await _localStorage.get(key: 'token');
    return result.fold(
      (_) => const Left(CacheFailure()),
      (data) => Right(
        data == null
            ? null
            : UserTokensModel.fromJson(
                jsonDecode(data),
              ),
      ),
    );
  }

  @override
  Future<Either<Failure, bool>> saveUserTokens(
    UserTokensModel? userTokens,
  ) async {
    final result = await _localStorage.save(
      key: 'token',
      value: userTokens == null
          ? null
          : jsonEncode(
              userTokens.toJson(),
            ),
    );
    return result.fold(
      (_) => const Left(CacheFailure()),
      (data) => const Right(true),
    );
  }
}
