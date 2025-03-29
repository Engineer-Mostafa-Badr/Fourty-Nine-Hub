
import '../../domain/entity/complete_order_entity.dart';

class CompleteOrderModel extends CompleteOrderEntity {
  CompleteOrderModel({
    required bool status,
    required String message,
  }) : super(
    status: status,
    message: message,
  );

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
