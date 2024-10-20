
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';

class SignOutUseCase extends NormalUseCase<Future<bool>, NoParams> {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  @override
  Future<bool> call(NoParams params) {
    return _repository.signOut();
  }
}
