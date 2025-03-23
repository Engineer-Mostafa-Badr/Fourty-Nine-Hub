import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

import '../../../../core/utils/device_id.dart';

class RegisterByPhoneUseCase extends UseCase<void, RegisterByPhoneParams> {
  final AuthRepository _repository;

  RegisterByPhoneUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(RegisterByPhoneParams params) {
    return _repository.registerByPhone(params);
  }
}

class RegisterByPhoneParams extends Equatable {
  final String userName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String token;
  final String? birthday;
  final String? referralId;
  final bool isMale;

  const RegisterByPhoneParams({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.token,
    this.birthday,
    this.referralId,
    required this.isMale,
  });

  Future<Map<String, dynamic>> toJson() async => {
        'username': userName,
        'firstName': firstName,
        'lastName': lastName,
        if (birthday != null && (birthday?.isNotEmpty ?? false))
          'birthday': birthday,
        'phoneNumber': phoneNumber,
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
        phoneNumber,
        password,
        confirmPassword,
      ];
}
