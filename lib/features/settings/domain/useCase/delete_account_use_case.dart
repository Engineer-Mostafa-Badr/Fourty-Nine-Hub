import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/setting_repository.dart';

class DeleteAccountUseCase extends UseCase<bool, NoParams> {
  final SettingRepository _settingRepository;

  DeleteAccountUseCase(this._settingRepository);
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await _settingRepository.deleteAccount();
  }
}
