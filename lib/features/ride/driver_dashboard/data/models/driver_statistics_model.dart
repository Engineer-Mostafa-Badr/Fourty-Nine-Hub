import '../../domain/entities/driver_statistics_entity.dart';

class DriverStatisticsModel extends DriverStatisticsEntity {
  DriverStatisticsModel(
      {required super.allTripsCount,
      required super.todaysTripsCount,
      required super.todaysIncome,
      required super.reviewsCount,
      required super.ratingAvg});

  factory DriverStatisticsModel.fromJson(Map<String, dynamic> json) {
    return DriverStatisticsModel(
      allTripsCount: json['all_trips_count'],
      todaysTripsCount: json['todays_trips_count'],
      todaysIncome: json['todays_income'],
      reviewsCount: json['reviews_count'],
      ratingAvg: json['rating_avg'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['all_trips_count'] = allTripsCount;
    data['todays_trips_count'] = todaysTripsCount;
    data['todays_income'] = todaysIncome;
    data['reviews_count'] = reviewsCount;
    data['rating_avg'] = ratingAvg;
    return data;
  }
}
