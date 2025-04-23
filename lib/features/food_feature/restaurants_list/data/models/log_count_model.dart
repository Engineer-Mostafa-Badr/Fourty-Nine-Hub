import '../../domain/entities/log_count_entity.dart';

class RequestLogCountModel extends RequestLogCountEntity {
  const RequestLogCountModel({required int count}) : super(count: count);

  factory RequestLogCountModel.fromJson(Map<String, dynamic> json) {
    return RequestLogCountModel(
      count: json['data'] as int,
    );
  }


}
