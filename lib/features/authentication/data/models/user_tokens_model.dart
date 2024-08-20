import 'package:fourtyninehub/features/authentication/domain/entities/user_tokens_entity.dart';

class UserTokensModel extends UserTokensEntity {
  const UserTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory UserTokensModel.fromJson(Map<String, dynamic> json) {
    return UserTokensModel(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };
}
