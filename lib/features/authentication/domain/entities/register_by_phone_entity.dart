import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';
import 'gift_message_entity.dart';

class RegisterByPhoneEntity extends Equatable {
  final bool isPhoneVerified;
  final UserTokensEntity tokensEntity;
  final GiftMessageEntity giftMessageEntity;

  const RegisterByPhoneEntity({
    required this.isPhoneVerified,
    required this.tokensEntity,
    required this.giftMessageEntity,
  });

  @override
  List<Object?> get props => [
        isPhoneVerified,
        tokensEntity,
        giftMessageEntity,
      ];
}
