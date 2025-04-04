import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

class RegisterByPhoneEntity extends Equatable {
  final bool isPhoneVerified;
  final UserTokensEntity tokensEntity;

  const RegisterByPhoneEntity(
      {required this.isPhoneVerified, required this.tokensEntity});

  @override
  List<Object?> get props => [
        isPhoneVerified,
        tokensEntity,
      ];
}
