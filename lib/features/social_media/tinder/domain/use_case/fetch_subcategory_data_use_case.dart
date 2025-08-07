import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/tinder_repository.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';

class FetchSubCategoryDataUseCase
    extends UseCase<List<SubCategoryEntity>, NoParams> {
  final TinderRepository _repository;

  FetchSubCategoryDataUseCase(this._repository);

  @override
  Future<Either<Failure, List<SubCategoryEntity>>> call(NoParams params) {
    return _repository.fetchSubCategoryData();
  }
}
