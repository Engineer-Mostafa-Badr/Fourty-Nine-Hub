import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';

import '../../../../../core/data/datasources/local/shared_preferences/local_storage_consumer.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/shared_pref.dart';

abstract class AuthLocalDataSource {
  Future<Either<Failure, void>> clearGuestData();

  Future<Either<Failure, void>> clearGuestState();

  Future<Either<Failure, Map<String, dynamic>?>> getGuestData();

  Future<Either<Failure, bool>> getGuestState();
  Future<Either<Failure, String?>> getLanguage();
  Future<Either<Failure, UserTokensModel?>> getUserTokens();
  Future<Either<Failure, void>> saveGuestData(Map<String, dynamic> data);
  Future<Either<Failure, void>> saveGuestState();
  Future<Either<Failure, bool>> saveLanguage(String language);
  Future<Either<Failure, bool>> saveUserTokens(UserTokensModel? userTokens);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorageConsumer _localStorage;
  final Dio _dio = Dio();

  final _guestDataKey = 'guestData';
  final _guestModeKey = 'guestMode';

  AuthLocalDataSourceImpl(this._localStorage);

  @override
  Future<Either<Failure, void>> clearGuestData() async {
    final result = await _localStorage.delete(key: _guestDataKey);
    return result.fold(
      (_) => const Left(CacheFailure()),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> clearGuestState() async {
    final result = await _localStorage.delete(key: _guestModeKey);
    return result.fold(
      (_) => const Left(CacheFailure()),
      (_) => const Right(null),
    );
  }

  @override
  Future<bool> deleteTokens() async {
    bool result = false;
    try {
      Response response =
          await _dio.post('${EndPoints.productionBaseUrl}${EndPoints.logout}',
              options: Options(headers: {
                'Authorization': 'Bearer ${CacheManager.getAccessToken()}',
                'Content-Type': 'application/json',
              }));
      if (response.statusCode == 200) {
        print('logout successfully');
        result = await CacheManager.deleteAllTokens();
        return result;
      } else {
        return result;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getGuestData() async {
    final result = await _localStorage.get(key: _guestDataKey);
    return result.fold(
      (_) => const Right(null),
      (data) {
        if (data == null) return const Right(null);
        try {
          return Right(jsonDecode(data));
        } catch (e) {
          return const Right(null);
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> getGuestState() async {
    final result = await _localStorage.get(key: _guestModeKey);
    return result.fold(
      (_) => const Right(false),
      (data) => Right(data == 'true'),
    );
  }

  @override
  Future<Either<Failure, String?>> getLanguage() async {
    final result = await _localStorage.get(key: 'language');
    return result.fold(
      (_) => const Left(CacheFailure()),
      (data) => Right(data),
    );
  }

  @override
  Future<Either<Failure, UserTokensModel?>> getUserTokens() async {
    // final result = await _localStorage.get(key: 'token');
    // return result.fold(
    //   (_) => const Left(CacheFailure()),
    //   (data) {
    //     log("localstorage getUserTokens: $data");
    //     return Right(
    //       data == null
    //           ? null
    //           : UserTokensModel.fromJson(
    //               jsonDecode(data),
    //             ),
    //     );
    //   },
    // );
    return const Left(CacheFailure());
  }

  @override
  Future<Either<Failure, void>> saveGuestData(Map<String, dynamic> data) async {
    final result = await _localStorage.save(
      key: _guestDataKey,
      value: jsonEncode(data),
    );
    return result.fold(
      (_) => const Left(CacheFailure()),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> saveGuestState() async {
    final result = await _localStorage.save(key: _guestModeKey, value: 'true');
    return result.fold(
      (_) => const Left(CacheFailure()),
      (_) => const Right(null),
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
  Future<Either<Failure, bool>> saveUserTokens(
    UserTokensModel? userTokens,
  ) async {
    // final result = await _localStorage.save(
    //   key: 'token',
    //   value: userTokens == null
    //       ? null
    //       : jsonEncode(
    //           userTokens.toJson(),
    //         ),
    // );
    // return result.fold(
    //   (_) => const Left(CacheFailure()),
    //   (data) {
    //     log("localstorage saveUserTokens: $data");
    //     return const Right(true);
    //   },
    // );
    return const Right(true);
  }
}
