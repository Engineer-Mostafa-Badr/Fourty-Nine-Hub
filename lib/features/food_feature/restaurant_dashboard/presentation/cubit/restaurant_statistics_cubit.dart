import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/error/failure.dart';

abstract class RestaurantStatisticsState {}

class RestaurantStatisticsInitial extends RestaurantStatisticsState {}

class RestaurantStatisticsLoading extends RestaurantStatisticsState {}

class RestaurantStatisticsSuccess extends RestaurantStatisticsState {
  final Map<String, dynamic> statistics;

  RestaurantStatisticsSuccess(this.statistics);
}

class RestaurantStatisticsError extends RestaurantStatisticsState {
  final String message;

  RestaurantStatisticsError(this.message);
}

class RestaurantStatisticsCubit extends Cubit<RestaurantStatisticsState> {
  final ApiConsumer apiConsumer;
  RestaurantStatistics? restaurantStatistics;

  RestaurantStatisticsCubit(this.apiConsumer)
      : super(RestaurantStatisticsInitial());

  Future<void> fetchRestaurantStatistics() async {
    emit(RestaurantStatisticsLoading());

    final Either<Failure, Map<String, dynamic>> result = await apiConsumer.get(
      'https://d0e2803e70a6.ngrok-free.app/api/v1/restaurants/statistics',
    );

    result.fold(
      (failure) => emit(
          RestaurantStatisticsError(failure.toString() ?? 'An error occurred')),
      (statistics) {
        restaurantStatistics = RestaurantStatistics.fromJson(statistics);
        emit(RestaurantStatisticsSuccess(statistics));
      },
    );
  }
}

class RestaurantStatistics {
  final bool status;
  final StatisticsData data;

  RestaurantStatistics({
    required this.status,
    required this.data,
  });

  // Factory method to parse from JSON
  factory RestaurantStatistics.fromJson(Map<String, dynamic> json) {
    return RestaurantStatistics(
      status: json['status'],
      data: StatisticsData.fromJson(json['data']),
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}

class StatisticsData {
  final int totalOrders;
  final double totalRevenue;
  final double totalRating;
  final int numberOfReviews;
  final int deadLineSubscription;

  StatisticsData({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalRating,
    required this.numberOfReviews,
    required this.deadLineSubscription,
  });

  // Factory method to parse from JSON
  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
      totalOrders: json['totalOrders'],
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalRating: (json['totalRating'] as num).toDouble(),
      numberOfReviews: json['numberOfReviews'],
      deadLineSubscription: json['deadLineSubscription'],
    );
  }

  // Method to convert the object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'totalRating': totalRating,
      'numberOfReviews': numberOfReviews,
      'deadLineSubscription': deadLineSubscription,
    };
  }
}
