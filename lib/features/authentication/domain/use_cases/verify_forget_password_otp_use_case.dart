import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class VerifyForgetPasswordOTPUseCase
    extends UseCase<void, VerifyForgetOTPParams> {
  final AuthRepository _repository;

  VerifyForgetPasswordOTPUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(VerifyForgetOTPParams params) {
    return _repository.verifyForgetPasswordOTP(params);
  }
}

class VerifyForgetOTPParams extends Equatable {
  final String email;
  final String otp;

  const VerifyForgetOTPParams({
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
