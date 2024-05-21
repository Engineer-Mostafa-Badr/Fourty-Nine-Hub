part of 'ride_bloc.dart';

abstract class RideState extends Equatable {
  const RideState();  

  @override
  List<Object> get props => [];
}
class RideInitial extends RideState {}
