import 'package:fourtyninehub/features/azkaar/domain/entity/azkar_entity.dart';

class AzkarModel extends AzkarEntity {
  AzkarModel({required super.name});

  factory AzkarModel.fromJson(Map<String, dynamic> json) {
    return AzkarModel(name: json['_id'] ?? '');
  }
}
