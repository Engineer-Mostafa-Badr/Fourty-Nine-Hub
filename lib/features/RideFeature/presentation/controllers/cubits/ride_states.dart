import 'package:fourtyninehub/features/RideFeature/domain/entities/activity_trip_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/completed_trips_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/expected_price_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/running_trips_entity.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';

enum RideStates {
  initState,
  loading,
  error,
  success,
}

extension RideStatex on RideState {
  bool get isInitial => status == RideStates.initState;
  bool get isLoading => status == RideStates.loading;
  bool get isError => status == RideStates.error;
  bool get isSuccess => status == RideStates.success;
}

class RideState {
  final RideStates status;
  final Failure? failure;
  final RideCategoryEntityUpdated? rideCategory;
  final RideCategoryEntityUpdated? shippingCategory;
  final List<GovernorateEntity>? governorates;
  final GetLocationFromAddressEntity? currentLocation;
  final GetLocationFromAddressEntity? toLocation;
  final RideExpectedPriceEntity? rideExpectedPrice;
  final List<CompletedTripsEntity>? completedTrips;
  final List<RunningTripsEntity>? runningTrips;
  final ActivityTripEntity ? activityTrips;

  const RideState({
    this.status = RideStates.initState,
    this.failure,
    this.rideCategory,
    this.shippingCategory,
    this.governorates,
    this.currentLocation,
    this.toLocation,
    this.rideExpectedPrice,
    this.completedTrips,
    this.runningTrips,
    this.activityTrips,
  });

  RideState copyWith({
    RideStates? status,
    Failure? failure,
    RideCategoryEntityUpdated? rideCategory,
    RideCategoryEntityUpdated? shippingCategory,
    List<GovernorateEntity>? governorates,
    GetLocationFromAddressEntity? currentLocation,
    GetLocationFromAddressEntity? toLocation,
    RideExpectedPriceEntity? rideExpectedPrice,
    List<CompletedTripsEntity>? completedTrips,
    List<RunningTripsEntity>? runningTrips,
    ActivityTripEntity ? activityTrips,
  }) {
    return RideState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      rideCategory: rideCategory ?? this.rideCategory,
      shippingCategory: shippingCategory ?? this.shippingCategory,
      governorates: governorates ?? this.governorates,
      currentLocation: currentLocation ?? this.currentLocation,
      toLocation: toLocation ?? this.toLocation,
      rideExpectedPrice: rideExpectedPrice ?? this.rideExpectedPrice,
      completedTrips: completedTrips ?? this.completedTrips,
      runningTrips: runningTrips ?? this.runningTrips,
      activityTrips: activityTrips ?? this.activityTrips,
    );
  }
}
