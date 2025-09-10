import 'package:dartz/dartz.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/profile_entity.dart';
import '../repository/profile_repository.dart';

class SearchProfilesUseCase extends UseCase<List<ProfileEntity>, SearchProfileParams> {
  final ProfileRepository repository;

  SearchProfilesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProfileEntity>>> call(SearchProfileParams params) async {
    return await repository.searchProfiles(params);
  }
}