import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/profile_entity.dart';
import '../repository/profile_repository.dart';

class GetProfileByIdUseCase extends UseCase<ProfileEntity, String> {
  final ProfileRepository repository;

  GetProfileByIdUseCase(this.repository);

  @override
  Future<Either<Failure, ProfileEntity>> call(String profileId) async {
    return await repository.getProfileById(profileId);  
  }
}