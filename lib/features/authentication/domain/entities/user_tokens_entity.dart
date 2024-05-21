import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_tokens_model.dart';

class UserTokensEntity extends Equatable {
  final String accessToken;
  final String refreshToken;

  const UserTokensEntity({
    required this.accessToken,
    required this.refreshToken,
  });

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
