// model.dart

import '../../../domain/entities/get_request_count_entity.dart';

class GetRequestCountModel extends GetRequestCountEntity {
  GetRequestCountModel({required super.countRequest});

  factory GetRequestCountModel.fromJson(Map<String, dynamic> json) {
    return GetRequestCountModel(
      countRequest: json['data']['countRequest'] as int,
    );
  }
}
