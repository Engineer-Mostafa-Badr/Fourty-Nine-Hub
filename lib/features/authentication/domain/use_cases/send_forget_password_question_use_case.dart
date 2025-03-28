import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/send_forget_password_otp_use_case.dart';

import '../entities/forget_password_questions_entity.dart';

class SendForgetPasswordQuestionUseCase extends UseCase<ForgetPasswordQuestionsEntity, SendForgetPasswordParams> {
  final AuthRepository _repository;

  SendForgetPasswordQuestionUseCase(this._repository);

  @override
  Future<Either<Failure, ForgetPasswordQuestionsEntity>> call(SendForgetPasswordParams params) {
    return _repository.sendForgetPasswordQuestions(params);
  }
}
