
import '../../domain/entity/complete_order_entity.dart';

class CompleteOrderModel extends CompleteOrderEntity {
  CompleteOrderModel({
    required super.status,
    required super.message,
  });

  factory CompleteOrderModel.fromJson(Map<String, dynamic> json) {
    return CompleteOrderModel(
      status: json['status'],
      message: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': message,
    };
  }
}
