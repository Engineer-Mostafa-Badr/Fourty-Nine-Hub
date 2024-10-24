import 'package:fourtyninehub/features/custom_page/domain/entity/activate_entity.dart';

class ActivateModel extends ActivateEntity {
  ActivateModel(
      {required super.id, required super.userId, required super.customPage});

  factory ActivateModel.fromJson(Map<String, dynamic> json) {
    return ActivateModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      customPage: json['customPage'] ?? false,
    );
  }
}
