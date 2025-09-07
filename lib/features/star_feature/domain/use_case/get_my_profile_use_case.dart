import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/profile_entity.dart';
import '../repository/profile_repository.dart';

class GetMyProfileUseCase extends UseCase<ProfileEntity, NoParams> {
  final ProfileRepository repository;

  GetMyProfileUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
    return await repository.getMyProfile();
  }
}
