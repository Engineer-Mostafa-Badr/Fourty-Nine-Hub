import 'package:dartz/dartz.dart';
import '../entity/topic_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repository/live_repository.dart';

class GetAllTopicsUseCase extends UseCase<List<TopicEntity>, NoParams> {
  final LiveRepository _liveRepository;

  GetAllTopicsUseCase({required LiveRepository liveRepository})
      : _liveRepository = liveRepository;
  @override
  Future<Either<Failure, List<TopicEntity>>> call(NoParams params) {
    return _liveRepository.getAllTopics();
  }
}
