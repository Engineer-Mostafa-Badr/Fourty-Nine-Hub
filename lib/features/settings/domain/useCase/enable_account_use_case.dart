import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/setting_repository.dart';

import '../entities/disable_entity.dart';

class EnableAccountUseCase extends UseCase<DisableEntity, NoParams> {
  final SettingRepository _settingRepository;

  EnableAccountUseCase(this._settingRepository);

  @override
  Future<Either<Failure, DisableEntity>> call(NoParams params) async {
    return await _settingRepository.enableAccount();
  }
}
