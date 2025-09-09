import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/profile_entity.dart';
import '../repository/profile_repository.dart';

class UpdateProfileUseCase extends UseCase<String, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(params);
  }
}