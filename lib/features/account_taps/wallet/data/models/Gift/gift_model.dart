import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/gift_entities.dart';

class GiftModelModel<T> extends GiftEntities<T> {
  const GiftModelModel({
    required super.status,
    required super.message,
    required super.data,
  });

  // Factory method to create a BaseResponseModel from JSON
  factory GiftModelModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return GiftModelModel(
      status: json['status'],
      message: json['message'],
      data: fromJsonT(json['data']),
    );
  }

  // Method to convert BaseResponseModel to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'status': status,
      'message': message,
      'data': toJsonT(data),
    };
  }
}
