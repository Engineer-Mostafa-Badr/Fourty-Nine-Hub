import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/fcm.dart';

class LoginUseCase extends UseCase<UserTokensEntity, LoginParams> {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserTokensEntity>> call(LoginParams params) {
    return _repository.login(params);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  Future<Map<String, dynamic>> toJson() async => {
        'email': email,
        'password': password,
        'fcmToken': await getFcmToken(),
        'fcmToken': 'fcmToken',
      };

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}
