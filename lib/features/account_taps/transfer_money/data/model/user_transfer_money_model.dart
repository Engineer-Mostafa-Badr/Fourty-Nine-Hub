import 'package:fourtyninehub/features/account_taps/transfer_money/domain/entities/user_transfer_money_entity.dart';

class UserTransferMoneyModel extends UserTransferMoneyEntity {
  UserTransferMoneyModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.userName,
    // required super.profilePictureId,
    // required super.image,
  });

  factory UserTransferMoneyModel.fromJson(Map<String, dynamic> json) {
    return UserTransferMoneyModel(
        id: json['_id'] ?? '',
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        userName: json['username'] ?? ''
        // profilePictureId: json['_id'] ??'',
        // image: json['mediaKey'] ??'',
        );
  }
}
