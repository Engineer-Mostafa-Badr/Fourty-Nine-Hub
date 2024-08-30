part of 'fetch_car_models_cubit.dart';

sealed class FetchCarModelsState {}

final class FetchCarModelsInitial extends FetchCarModelsState {}

final class FetchCarModelsLoading extends FetchCarModelsState {}

final class FetchCarModelsFailed extends FetchCarModelsState {
  final String errorMessage;

  FetchCarModelsFailed(this.errorMessage);
}

final class FetchCarModelsSuccess extends FetchCarModelsState {
  final List<CarModelEntity> models;

  FetchCarModelsSuccess(this.models);
}
