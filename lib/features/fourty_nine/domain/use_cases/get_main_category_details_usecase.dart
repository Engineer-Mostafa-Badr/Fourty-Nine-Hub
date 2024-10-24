import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/repositories/fourty_nine_repository.dart';

class GetMainCategoryDetailsUseCase
    extends UseCase<MainCategoryEntity?, String> {
  final FourtyNineRepository _repo;
  GetMainCategoryDetailsUseCase(this._repo);
  @override
  Future<Either<Failure, MainCategoryEntity>> call(String params) {
    return _repo.getMainCategoryDetails(params);
  }
}
