import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class SendForgetPasswordOTPUseCase extends UseCase<void, SendForgetPasswordParams> {
  final AuthRepository _repository;

  SendForgetPasswordOTPUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(SendForgetPasswordParams params) {
    return _repository.sendForgetPasswordOTP(params);
  }
}

class SendForgetPasswordParams extends Equatable {
  final String email;

  const SendForgetPasswordParams({required this.email});

  Map<String, dynamic> toJson() => {
        'email': email,
      };

  @override
  List<Object?> get props => [email];
}
