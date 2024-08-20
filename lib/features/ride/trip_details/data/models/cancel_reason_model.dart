import '../../domain/entities/cancel_reason_entity.dart';

class CancelReasonModel extends CancelReasonEntity {
  CancelReasonModel({required super.id, required super.name});
  factory CancelReasonModel.fromJson(Map<String, dynamic> json) {
    return CancelReasonModel(id: json['id'], name: json['name']);
  }
}
