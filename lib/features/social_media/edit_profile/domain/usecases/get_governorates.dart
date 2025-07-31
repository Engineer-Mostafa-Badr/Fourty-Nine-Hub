import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../repositories/edit_profile_repo.dart';

class GetProfileGovernoratesUseCase
    extends UseCase<List<GovernorateEntity>, NoParams> {
  final EditProfileRepo _repository;

  GetProfileGovernoratesUseCase(this._repository);

  @override
  Future<Either<Failure, List<GovernorateEntity>>> call(NoParams params) {
    return _repository.getGovernorates();
  }
}
