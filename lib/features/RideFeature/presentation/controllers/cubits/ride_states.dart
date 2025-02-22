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

  const RideState({
    this.status = RideStates.initState,
    this.failure,
    this.rideCategory,
    this.shippingCategory,
  });

  RideState copyWith({
    RideStates? status,
    Failure? failure,
    RideCategoryEntityUpdated? rideCategory,
    RideCategoryEntityUpdated? shippingCategory,
  }) {
    return RideState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      rideCategory: rideCategory ?? this.rideCategory,
      shippingCategory: shippingCategory ?? this.shippingCategory,
    );
  }
}
