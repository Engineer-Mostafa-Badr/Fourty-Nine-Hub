part of 'add_new_pick_me_trip_cubit.dart';

// sealed class AddNewPickMeTripState {
//   const AddNewPickMeTripState();
// }
//
// final class AddNewPickMeTripInitial extends AddNewPickMeTripState {}
//
// final class AddNewPickMeTripLoading extends AddNewPickMeTripState {}
//
// final class AddNewPickMeTripFailure extends AddNewPickMeTripState {
//   final String errorMessage;
//
//   AddNewPickMeTripFailure({required this.errorMessage});
// }
//
// final class AddNewPickMeTripSuccess extends AddNewPickMeTripState {
//   final AddNewPickMeModel addNewPickMeModel;
//
//   AddNewPickMeTripSuccess({required this.addNewPickMeModel});
// }


// part of 'view_all_trip_join_cubit.dart';

class AddNewPickMeTripState {
  final AddNewPickMeTripStateStatus status;
  final String? errorMessage;
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
  const AddNewPickMeTripState({
    this.status = AddNewPickMeTripStateStatus.initial,
    this.errorMessage,
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

  AddNewPickMeTripState copyWith({
    AddNewPickMeTripStateStatus? status,
    String? errorMessage,
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
    return AddNewPickMeTripState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
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

enum AddNewPickMeTripStateStatus {
  initial,
  loading,
  success,
  failure,
}
