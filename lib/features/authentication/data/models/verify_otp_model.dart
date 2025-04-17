import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/verify_otp_entity.dart';

import 'gift_model.dart';

class VerifyOtpModel extends VerifyOtpEntity{
  VerifyOtpModel({required super.userTokensEntity, required super.giftMessageEntity,});

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpModel(
      userTokensEntity: UserTokensModel.fromJson(json),
      giftMessageEntity: GiftMessageModel.fromJson(json['gift']),
    );
  }

}