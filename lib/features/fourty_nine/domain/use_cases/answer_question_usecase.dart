import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';

class AnswerQuestionUseCase extends UseCase<bool, AnswerQuestionParams> {
  final FourtyNineRepository _repo;

  AnswerQuestionUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(AnswerQuestionParams params) {
    return _repo.answerQuestion(params);
  }
}

class AnswerQuestionParams{
  final String id;
  final String answer;

  AnswerQuestionParams({required this.id, required this.answer});
}