import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

import '../entities/verify_otp_entity.dart';

class VerifyOTPUseCase extends UseCase<VerifyOtpEntity, VerifyOTPParams> {
  final AuthRepository _repository;
  VerifyOTPUseCase(this._repository);

  @override
  Future<Either<Failure, VerifyOtpEntity>> call(VerifyOTPParams params) {
    return _repository.verifyOTP(params);
  }
}

class VerifyOTPParams extends Equatable {
  final String email;
  final String otp;

  const VerifyOTPParams({
    required this.email,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'otp': otp,
      };

  @override
  List<Object?> get props => [
        email,
        otp,
      ];
}
