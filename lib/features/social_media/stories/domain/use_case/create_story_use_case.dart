import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/stories_repository.dart';

class CreateStoryUseCase extends UseCase<bool, CreateStoryParams> {
  final StoriesRepository _repository;

  CreateStoryUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(CreateStoryParams params)async {
    return await _repository.createStory(params);
  }
}

class CreateStoryParams {
  String text;
  String color;
  String fontFamily;
  CreateStoryParams({required this.text, required this.color, required this.fontFamily,});
}
