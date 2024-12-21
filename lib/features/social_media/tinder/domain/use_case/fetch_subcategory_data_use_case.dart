import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/tinder/domain/repositories/tinder_repository.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

class FetchSubCategoryDataUseCase
    extends UseCase<List<SubCategoryEntity>, NoParams> {
  final TinderRepository _repository;

  FetchSubCategoryDataUseCase(this._repository);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(NoParams params) {
    return _repository.fetchSubCategoryData();
  }
}
