part of 'authentication_ride_cubit.dart';

sealed class AuthenticationRideState extends Equatable {
  const AuthenticationRideState();

  @override
  List<Object> get props => [];
}

final class AuthenticationRideInitial extends AuthenticationRideState {}

class SuccessGetPartRideSocketModelState extends AuthenticationRideState {
  final PartsSocketModel model;

  const SuccessGetPartRideSocketModelState({required this.model});
}
