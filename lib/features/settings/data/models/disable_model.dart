import 'package:fourtyninehub/features/settings/domain/entities/disable_entity.dart';

class DisableModel extends DisableEntity {
  DisableModel(
      {required super.id,
      required super.firstName,
      required super.username,
      required super.isDisabled});

  factory DisableModel.fromJson(Map<String, dynamic> json) {
    return DisableModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? '',
      username: json['username'] ?? '',
      isDisabled: json['isDisabled'] ?? false,
    );
  }
}
