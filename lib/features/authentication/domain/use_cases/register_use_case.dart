import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/device_id.dart';

class RegisterUseCase extends UseCase<void, RegisterParams> {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(RegisterParams params) {
    return _repository.register(params);
  }
}

class RegisterParams extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final String token;
  final String? referralId;
  final bool isMale;

  const RegisterParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.token,
     this.referralId,
    required this.isMale,
  });

  Future<Map<String, dynamic>> toJson() async => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'gender': isMale ? 'male' : 'female',
        'fcm': token,
        'referralId': referralId,
        'deviceId': await getDeviceId(),
      };

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      ];
}
