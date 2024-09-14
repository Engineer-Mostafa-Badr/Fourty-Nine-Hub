import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/settings/domain/repository/setting_repository.dart';

class DeleteAccountUseCase extends UseCase<bool,NoParams>{
 final SettingRepository _settingRepository;

  DeleteAccountUseCase(this._settingRepository);
  @override
  Future<Either<Failure, bool>> call(NoParams params)async {
    return await _settingRepository.deleteAccount();
  }

}