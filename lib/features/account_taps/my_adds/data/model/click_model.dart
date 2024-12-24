import '../../domain/entity/click_entity.dart';

class ClickModel extends ClickEntity {
  ClickModel({required super.status, required super.data});

  factory ClickModel.fromJson(Map<String, dynamic> json) {
    return ClickModel(
      status: json['status'] ?? false,
      data: json['data'] ?? '',
    );
  }
}
