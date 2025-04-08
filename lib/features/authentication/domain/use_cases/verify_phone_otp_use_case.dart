import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import '../entities/verify_otp_entity.dart';
class VerifyPhoneOtpUseCase extends UseCase<VerifyOtpEntity, VerifyPhoneOTPParams> {
  final AuthRepository _repository;

  VerifyPhoneOtpUseCase(this._repository);

  @override
  Future<Either<Failure, VerifyOtpEntity>> call(VerifyPhoneOTPParams params) {
    return _repository.verifyPhoneOTP(params);
  }
}

class VerifyPhoneOTPParams extends Equatable {
  final String phoneNumber;
  final String otp;

  const VerifyPhoneOTPParams({
    required this.phoneNumber,
    required this.otp,
  });

  Map<String, dynamic> toJson() => {
        'phoneNumber': phoneNumber,
        'otp': otp,
      };

  @override
  List<Object?> get props => [
        phoneNumber,
        otp,
      ];
}
