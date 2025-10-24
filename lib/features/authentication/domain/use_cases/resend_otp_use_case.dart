import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class ResendOTPUseCase extends UseCase<void, ResendOTPParams> {
  final AuthRepository _repository;

  ResendOTPUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ResendOTPParams params) {
    return _repository.resendOTP(params);
  }
}

class ResendOTPParams extends Equatable {
  final String email;
  final bool forVerification;
  final bool? fromRegister;

  const ResendOTPParams( {required this.email,required this.forVerification,this.fromRegister});

  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
