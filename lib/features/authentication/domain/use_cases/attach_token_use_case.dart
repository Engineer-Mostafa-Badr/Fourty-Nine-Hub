
import '../../../../core/abstract/use_case.dart';
import '../repositories/auth_repository.dart';

class AttachTokenUseCase extends NormalUseCase<bool, String?> {
  final AuthRepository repository;

  AttachTokenUseCase(this.repository);

  @override
  bool call(String? params) {
    return repository.attachToken(params);
  }
}
