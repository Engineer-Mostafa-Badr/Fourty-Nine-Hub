import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/question_entity.dart';
import '../repositories/fourty_nine_repository.dart';

class GetQuestionUseCase extends UseCase<QuestionEntity, NoParams> {
  final FourtyNineRepository _repo;

  GetQuestionUseCase(this._repo);

  @override
  Future<Either<Failure, QuestionEntity>> call(NoParams params) {
    return _repo.getQuestion();
  }
}
