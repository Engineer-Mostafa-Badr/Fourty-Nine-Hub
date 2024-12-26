import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_profile_views_usecase.dart';

class GetProfileViewsByUserIdUseCase
    extends UseCase<List<GetProfileViewsEntity>, GetProfileViewsParams> {
  final AuthRepository _repo;

  GetProfileViewsByUserIdUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> call(
      GetProfileViewsParams params) {
    return _repo.getProfileViewsByUserId(params);
  }
}