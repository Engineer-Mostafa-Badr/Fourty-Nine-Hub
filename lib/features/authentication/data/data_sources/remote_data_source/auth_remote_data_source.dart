import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/login_use_case.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<Either<Failure, UserTokensModel>> login(LoginParams loginParams);

  void attachToken(String? token);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final ApiConsumer _apiConsumer;

  const AuthRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, UserTokensModel>> login(
      LoginParams loginParams) async {
    final result = await _apiConsumer.post(
      EndPoints.login,
      data: loginParams.toJson(),
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(
        UserTokensModel.fromJson(
          response['data'],
        ),
      ),
    );
  }

  @override
  void attachToken(String? token) {
    _apiConsumer.attachToken(token);
  }
}
