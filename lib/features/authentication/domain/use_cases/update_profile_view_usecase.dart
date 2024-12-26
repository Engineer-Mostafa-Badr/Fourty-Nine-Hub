import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class UpdateProfileViewUseCase extends UseCase<bool, UpdateProfileViewParams> {
  final AuthRepository _repository;
  UpdateProfileViewUseCase(this._repository);

  @override
  Future<Either<Failure, bool>> call(params) {
    return _repository.updateProfileView(params);
  }
}

class UpdateProfileViewParams {
  bool isProfile;
  String userId;

  UpdateProfileViewParams({required this.isProfile, required this.userId});
}

class UpdateProfileViewActionType {
  static String profile = "profile";
  static String avatar = "avatar";
}
