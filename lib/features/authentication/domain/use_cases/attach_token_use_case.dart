import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

import '../../../../core/abstract/use_case.dart';
import '../repositories/auth_repository.dart';

class AttachTokenUseCase extends NormalUseCase<bool, UserTokensEntity?> {
  final AuthRepository repository;

  AttachTokenUseCase(this.repository);

  @override
  bool call(UserTokensEntity? params) {
    return repository.attachToken(params);
  }
}
