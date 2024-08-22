part of 'fetch_car_brands_cubit.dart';

sealed class FetchCarBrandsState {}

final class FetchCarBrandsInitial extends FetchCarBrandsState {}

final class FetchCarBrandsLoading extends FetchCarBrandsState {}

final class FetchCarBrandsFailed extends FetchCarBrandsState {
  final String errorMessage;

  FetchCarBrandsFailed(this.errorMessage);
}

final class FetchCarBrandsSuccess extends FetchCarBrandsState {
  final List<CarBrandEntity> carBrandList;

  FetchCarBrandsSuccess(this.carBrandList);
}
