import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';

import '../../domain/entities/register_by_phone_entity.dart';

class RegisterByPhoneModel extends RegisterByPhoneEntity{
  const RegisterByPhoneModel({
    required super.isPhoneVerified,
    required super.tokensEntity
  });

  factory RegisterByPhoneModel.fromJson(Map<String, dynamic> json) {
    return RegisterByPhoneModel(
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      tokensEntity: UserTokensModel.fromJson(json['tokens']),
    );
  }
}