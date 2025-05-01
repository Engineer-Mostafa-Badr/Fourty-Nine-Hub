part of 'cusine_restaurants_cubit.dart';

enum CusineRestaurantsStates { initState, loading, error }

extension CusineRestaurantsStateX on CusineRestaurantsState {
  bool get isInitial => status == CusineRestaurantsStates.initState;
  bool get isLoading => status == CusineRestaurantsStates.loading;
  bool get isError => status == CusineRestaurantsStates.error;
}

@immutable
class CusineRestaurantsState {
  final CusineRestaurantsStates? status;
  final Failure? failure;
  final List<GetAllRestaurantEntity>? cusineRestaurants;

  const CusineRestaurantsState({
    this.status,
    this.failure,
    this.cusineRestaurants,
  });
  CusineRestaurantsState copyWith({
    CusineRestaurantsStates? status,
    Failure? failure,
    List<GetAllRestaurantEntity>? cusineRestaurants,
  }) {
    return CusineRestaurantsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      cusineRestaurants: cusineRestaurants ?? this.cusineRestaurants,
    );
  }
}
