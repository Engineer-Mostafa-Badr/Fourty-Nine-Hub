import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';

class UserTokensEntity extends Equatable {
  final String accessToken;
  final String refreshToken;

  const UserTokensEntity({
    required this.accessToken,
    required this.refreshToken,
  });

  UserTokensEntity copyWith({
    String? accessToken,
    String? refreshToken,
  }) =>
      UserTokensEntity(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  UserTokensModel toModel() => UserTokensModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
      ];
}
