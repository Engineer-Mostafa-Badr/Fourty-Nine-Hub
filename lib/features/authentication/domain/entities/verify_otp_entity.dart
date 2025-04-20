import 'package:fourtyninehub/features/authentication/domain/entities/gift_message_entity.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

class VerifyOtpEntity {
  final UserTokensEntity userTokensEntity;
  final GiftMessageEntity giftMessageEntity;

  VerifyOtpEntity({
    required this.userTokensEntity,
    required this.giftMessageEntity,
  });
}
