part of 'create_car_pool_cubit.dart';

sealed class CreateCarPoolState {}

final class CreateCarPoolInitial extends CreateCarPoolState {}

final class CreateCarPoolLoading extends CreateCarPoolState {}

final class CreateCarPoolFailure extends CreateCarPoolState {
  final String errorMessage;

  CreateCarPoolFailure({required this.errorMessage});
}

final class CreateCarPoolSuccess extends CreateCarPoolState {
  final CreateCarPoolModel createCarPoolModel;

  CreateCarPoolSuccess({required this.createCarPoolModel});
}
