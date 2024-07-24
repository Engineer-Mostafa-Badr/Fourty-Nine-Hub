import '../../domain/entities/ad_statistics_entity.dart';

class AdStatisticsModel extends AdStatisticsEntity {
  AdStatisticsModel(
      {required super.calls,
      required super.chats,
      required super.requests,
      required super.views});
  factory AdStatisticsModel.fromJson(Map<String, dynamic> json) {
    return AdStatisticsModel(
      calls: json['calls'],
      chats: json['chat_room'],
      requests: json['requests'],
      views: json['views'],
    );
  }
}
