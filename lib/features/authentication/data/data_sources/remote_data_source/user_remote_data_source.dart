import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/authentication/data/models/wallet_model.dart';

import '../../../../../core/error/failure.dart';

abstract class UserRemoteDataSource {
  Future<Either<Failure, UserModel>> getUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiConsumer _apiConsumer;

  UserRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    final result = await _apiConsumer.get(EndPoints.getProfile);
    log(result.toString(), name: "UserDataLog");
    return result.fold((failure) => Left(failure), (response) {
      final user = UserModel.fromJson(
        response['data'],
      );
      // getWallet();
      return Right(user);
    });
  }
}
