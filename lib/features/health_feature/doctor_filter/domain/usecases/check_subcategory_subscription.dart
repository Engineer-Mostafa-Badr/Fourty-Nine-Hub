import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/domain/repositories/doctor_list_repo.dart';

class CheckSubCategorySubscriptionUseCase extends UseCase<bool, String> {
  final DoctorListRepo _categoryRepository;
  CheckSubCategorySubscriptionUseCase(this._categoryRepository);

  @override
  Future<Either<Failure, bool>> call(String subCategoryId) async {
    return await _categoryRepository
        .checkSubCategorySubscription(subCategoryId);
  }
}
