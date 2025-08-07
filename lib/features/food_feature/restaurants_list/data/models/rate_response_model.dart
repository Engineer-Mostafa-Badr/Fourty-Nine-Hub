import '../../domain/entities/rate_response_entity.dart';

class RateResponseModel extends RateResponseEntity {
  RateResponseModel({
    required super.status,
    super.data,
  });

  factory RateResponseModel.fromJson(Map<String, dynamic> json) {
    return RateResponseModel(
      status: json['status'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data,
    };
  }
}
