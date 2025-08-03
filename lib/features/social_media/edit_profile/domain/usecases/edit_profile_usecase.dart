import 'package:dartz/dartz.dart';
import '../entities/edit_profile_entity.dart';
import '../repositories/edit_profile_repo.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class EditProfileUseCase extends UseCase<bool, EditProfileEntity> {
  final EditProfileRepo _repo;
  EditProfileUseCase(this._repo);
  @override
  Future<Either<Failure, bool>> call(EditProfileEntity params) async {
    return await _repo.editProfile(params: params);
  }
}
