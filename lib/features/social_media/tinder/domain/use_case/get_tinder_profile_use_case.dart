import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/profile_user_model.dart';
import '../repositories/tinder_repository.dart';

class GetTinderProfileUseCase extends UseCase<ProfileUserModel, String> {
  final TinderRepository _repository;

  GetTinderProfileUseCase(this._repository);

  @override
  Future<Either<Failure, ProfileUserModel>> call(String params) {
    return _repository.getUserProfile(params);
  }
}
