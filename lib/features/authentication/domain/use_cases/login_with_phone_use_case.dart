import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/utils/device_id.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class LoginWithPhoneUseCase
    extends UseCase<UserTokensEntity, LoginWithPhoneParams> {
  final AuthRepository _repository;

  LoginWithPhoneUseCase(this._repository);

  @override
  Future<Either<Failure, UserTokensEntity>> call(LoginWithPhoneParams params) {
    return _repository.loginWithPhone(params);
  }
}

class LoginWithPhoneParams extends Equatable {
  final String phoneNumber;
  final String password;
  final String token;

  const LoginWithPhoneParams({
    required this.phoneNumber,
    required this.password,
    required this.token,
  });

  Future<Map<String, dynamic>> toJson() async => {
        'phoneNumber': phoneNumber,
        'password': password,
        'fcmToken': token,
        'deviceId': await getDeviceId(),
        'deviceName': await getDeviceName(),
        // 'fcmToken': 'fcmToken',
        'platform' : Platform.operatingSystem,
      };

  @override
  List<Object?> get props => [
        phoneNumber,
        password,
        token,
      ];
}
