import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/main_category_entity.dart';
import '../repositories/fourty_nine_repository.dart';

class GetMainCategoryDetailsUseCase
    extends UseCase<MainCategoryEntity?, String> {
  final FourtyNineRepository _repo;
  GetMainCategoryDetailsUseCase(this._repo);
  @override
  Future<Either<Failure, MainCategoryEntity>> call(String params) {
    return _repo.getMainCategoryDetails(params);
  }
}
