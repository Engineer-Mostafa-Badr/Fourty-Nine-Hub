part of 'join_trip_car_pool_cubit.dart';

sealed class JoinTripCarPoolState {}

final class JoinTripCarPoolInitial extends JoinTripCarPoolState {}

final class JoinTripCarPoolLoading extends JoinTripCarPoolState {}

final class JoinTripCarPoolSuccess extends JoinTripCarPoolState {
  final JoinTripCarpoolModel joinTripCarpoolModel;

  JoinTripCarPoolSuccess({required this.joinTripCarpoolModel});
}

final class JoinTripCarPoolFailure extends JoinTripCarPoolState {
  final String message;

  JoinTripCarPoolFailure({required this.message});
}
