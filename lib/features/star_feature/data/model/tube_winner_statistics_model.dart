import '../../domain/entity/tube_winner_statistics_entity.dart';

class TubeWinnerStatisticsModel extends TubeWinnerStatisticsEntity {
  const TubeWinnerStatisticsModel({
    required super.totalWinner,
    required super.totalVideos,
  });

  factory TubeWinnerStatisticsModel.fromJson(Map<String, dynamic> json) {
    return TubeWinnerStatisticsModel(
      totalWinner: json['totalWinner'] ?? 0,
      totalVideos: json['totalVideos'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWinner': totalWinner,
      'totalVideos': totalVideos,
    };
  }
}