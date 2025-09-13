import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/active_category_model.dart';
import '../repository/star_repository.dart';

class GetActiveCategoriesUseCase extends UseCase<ActiveCategoryResponse, NoParams> {
  final StarRepository _starRepository;

  GetActiveCategoriesUseCase(this._starRepository);

  @override
  Future<Either<Failure, ActiveCategoryResponse>> call(NoParams params) async {
    return await _starRepository.getActiveCategories();
  }
}