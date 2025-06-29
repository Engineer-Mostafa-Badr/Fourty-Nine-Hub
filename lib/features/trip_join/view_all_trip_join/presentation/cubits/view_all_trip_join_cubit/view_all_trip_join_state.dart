part of 'view_all_trip_join_cubit.dart';

class ViewAllTripJoinState {
  final ViewAllTripJoinStatus status;
  final String? errorMessage;
  final List<TripJoinCardEntity>? allCards;
  final Failure? failure;
  final List<RideBrandEntity>? rideBrandEntity;
  final List<RideModelEntity>? rideModelEntity;
  final ExpectedPriceTripEntity? expectedPriceEntity;
  final List<AvailableTripJoinEntity >? availableTripJoinEntity;
  final List<GetRequestTripJoinEntity>? requestTripJoinEntity;
  // final GetRequestTripJoinEntity? fullRequestTripJoinData;
  final List<MyAdsTripDocEntity>? myAdsTripJoinData;
  final DeleteMyTripJoinEntity? deleteMyTripJoinEntity;
  final GetRequestCountEntity? requestCountData;
  const ViewAllTripJoinState({
    this.status = ViewAllTripJoinStatus.initial,
    this.errorMessage,
    this.allCards,
    this.failure,
    this.rideBrandEntity,
    this.rideModelEntity,
    this.expectedPriceEntity,
    this.availableTripJoinEntity,
    this.requestTripJoinEntity,
    // this.fullRequestTripJoinData,
    this.myAdsTripJoinData,
    this.deleteMyTripJoinEntity,
    this.requestCountData,
  });

  ViewAllTripJoinState copyWith({
    ViewAllTripJoinStatus? status,
    String? errorMessage,
    List<TripJoinCardEntity>? allCards,
    Failure? failure,
    List<RideBrandEntity>? rideBrandEntity,
    List<RideModelEntity>? rideModelEntity,
    ExpectedPriceTripEntity? expectedPriceEntity,
    List<AvailableTripJoinEntity>? availableTripJoinEntity,
    List<GetRequestTripJoinEntity>? requestTripJoinEntity,
    // List<GetRequestTripJoinEntity>? fullRequestTripJoinData,
    List<MyAdsTripDocEntity>? myAdsTripJoinData,
    DeleteMyTripJoinEntity? deleteMyTripJoinEntity,
    GetRequestCountEntity? requestCountData,
  }) {
    return ViewAllTripJoinState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      allCards: allCards ?? this.allCards,
      failure: failure ?? this.failure,
      rideBrandEntity: rideBrandEntity ?? this.rideBrandEntity,
      rideModelEntity: rideModelEntity ?? this.rideModelEntity,
      expectedPriceEntity: expectedPriceEntity ?? this.expectedPriceEntity,
      availableTripJoinEntity: availableTripJoinEntity ?? this.availableTripJoinEntity,
      requestTripJoinEntity: requestTripJoinEntity ?? this.requestTripJoinEntity,
      // fullRequestTripJoinData: fullRequestTripJoinData ?? this.fullRequestTripJoinData,
      myAdsTripJoinData: myAdsTripJoinData ?? this.myAdsTripJoinData,
      deleteMyTripJoinEntity: deleteMyTripJoinEntity ?? this.deleteMyTripJoinEntity,
      requestCountData: requestCountData ?? this.requestCountData,
    );
  }
}

enum ViewAllTripJoinStatus {
  initial,
  loading,
  success,
  failure,
}
