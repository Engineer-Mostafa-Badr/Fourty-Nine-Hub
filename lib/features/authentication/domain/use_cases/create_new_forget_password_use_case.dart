import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class CreateNewForgetPasswordUseCase
    extends UseCase<void, CreateNewForgetParams> {
  final AuthRepository _repository;

  CreateNewForgetPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(CreateNewForgetParams params) {
    return _repository.createNewForgetPassword(params);
  }
}

class CreateNewForgetParams extends Equatable {
  final String email;
  final String newPassword;
  final String newPasswordConfirmation;

  const CreateNewForgetParams({
    required this.email,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  Map<String, dynamic> toJson() => {
        'email': email,
        'newPassword': newPassword,
        'confirmNewPassword': newPasswordConfirmation,
      };

  @override
  List<Object?> get props => [
        email,
        newPassword,
        newPasswordConfirmation,
      ];
}
