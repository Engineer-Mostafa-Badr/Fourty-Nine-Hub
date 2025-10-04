import '../../domain/entity/winner_statistics_entity.dart';

class WinnerStatisticsModel extends WinnerStatisticsEntity {
  const WinnerStatisticsModel({
    required super.totalWinner,
    required super.totalAds,
  });

  factory WinnerStatisticsModel.fromJson(Map<String, dynamic> json) {
    return WinnerStatisticsModel(
      totalWinner: json['totalWinner'] ?? 0,
      totalAds: json['totalAds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWinner': totalWinner,
      'totalAds': totalAds,
    };
  }
}