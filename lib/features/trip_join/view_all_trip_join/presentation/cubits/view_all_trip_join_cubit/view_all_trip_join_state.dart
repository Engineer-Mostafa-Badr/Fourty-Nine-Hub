part of 'view_all_trip_join_cubit.dart';

class ViewAllTripJoinState {
  final ViewAllTripJoinStatus status;
  final String? errorMessage;
  final String? searchText;
  final String? tripsSearchText;
  final bool? offersFromSearch;
  final bool? tripsFromSearch;
  final List<TripJoinCardEntity>? allCards;
  final Failure? failure;
  final List<RideBrandEntity>? rideBrandEntity;
  final List<RideModelEntity>? rideModelEntity;
  final ExpectedPriceTripEntity? expectedPriceEntity;
  final List<AvailableTripJoinEntity >? availableTripJoinEntity;
  final List<AvailableTripJoinEntity >? availablePickMeEntity;
  final List<GetRequestTripJoinEntity>? requestTripJoinEntity;
  // final GetRequestTripJoinEntity? fullRequestTripJoinData;
  final List<MyAdsTripDocEntity>? myAdsTripJoinData;
  final DeleteMyTripJoinEntity? deleteMyTripJoinEntity;
  final DeleteMyTripJoinEntity? deleteMyPickMeEntity;
  final GetRequestCountEntity? requestCountData;
  final GetRequestCountEntity? pickMeRequestCountData;
  final RideBrandModel? newBrand;
  final RideCarModelModel? newModel;
  const ViewAllTripJoinState({
    this.status = ViewAllTripJoinStatus.initial,
    this.offersFromSearch,
    this.tripsSearchText,
    this.tripsFromSearch,
    this.searchText,
    this.errorMessage,
    this.allCards,
    this.failure,
    this.rideBrandEntity,
    this.rideModelEntity,
    this.expectedPriceEntity,
    this.availableTripJoinEntity,
    this.availablePickMeEntity,
    this.requestTripJoinEntity,
    this.newBrand,
    this.newModel,
    // this.fullRequestTripJoinData,
    this.myAdsTripJoinData,
    this.deleteMyTripJoinEntity,
    this.deleteMyPickMeEntity,
    this.requestCountData,
    this.pickMeRequestCountData,
  });

  ViewAllTripJoinState copyWith({
    ViewAllTripJoinStatus? status,
    RideBrandModel? newBrand,
    RideCarModelModel? newModel,
    String? errorMessage,
    String? searchText,
    String? tripsSearchText,
    List<TripJoinCardEntity>? allCards,
    Failure? failure,
    List<RideBrandEntity>? rideBrandEntity,
    List<RideModelEntity>? rideModelEntity,
    ExpectedPriceTripEntity? expectedPriceEntity,
    List<AvailableTripJoinEntity>? availableTripJoinEntity,
    List<AvailableTripJoinEntity>? availablePickMeEntity,
    List<GetRequestTripJoinEntity>? requestTripJoinEntity,
    List<GetRequestTripJoinEntity>? requestPickMeEntity,
    // List<GetRequestTripJoinEntity>? fullRequestTripJoinData,
    List<MyAdsTripDocEntity>? myAdsTripJoinData,
    DeleteMyTripJoinEntity? deleteMyTripJoinEntity,
    DeleteMyTripJoinEntity? deleteMyPickMeEntity,
    GetRequestCountEntity? requestCountData,
    GetRequestCountEntity? pickMeRequestCountData,
    bool? offersFromSearch,
    bool? tripsFromSearch
  }) {
    return ViewAllTripJoinState(
      status: status ?? this.status,
      searchText: searchText ?? this.searchText,
      errorMessage: errorMessage ?? this.errorMessage,
      allCards: allCards ?? this.allCards,
      failure: failure ?? this.failure,
      rideBrandEntity: rideBrandEntity ?? this.rideBrandEntity,
      rideModelEntity: rideModelEntity ?? this.rideModelEntity,
      expectedPriceEntity: expectedPriceEntity ?? this.expectedPriceEntity,
      availableTripJoinEntity: availableTripJoinEntity ?? this.availableTripJoinEntity,
      availablePickMeEntity: availablePickMeEntity ?? this.availablePickMeEntity,
      requestTripJoinEntity: requestTripJoinEntity ?? this.requestTripJoinEntity,
      // fullRequestTripJoinData: fullRequestTripJoinData ?? this.fullRequestTripJoinData,
      myAdsTripJoinData: myAdsTripJoinData ?? this.myAdsTripJoinData,
      deleteMyTripJoinEntity: deleteMyTripJoinEntity ?? this.deleteMyTripJoinEntity,
      deleteMyPickMeEntity: deleteMyPickMeEntity ?? this.deleteMyPickMeEntity,
      requestCountData: requestCountData ?? this.requestCountData,
      pickMeRequestCountData: pickMeRequestCountData ?? this.pickMeRequestCountData,
      offersFromSearch: offersFromSearch ?? this.offersFromSearch,
      tripsSearchText: tripsSearchText ?? this.tripsSearchText,
      tripsFromSearch: tripsFromSearch ?? this.tripsFromSearch,
      newBrand: newBrand ?? this.newBrand,
      newModel: newModel ?? this.newModel,
    );
  }
}

enum ViewAllTripJoinStatus {
  initial,
  loading,
  success,
  failure,
}
