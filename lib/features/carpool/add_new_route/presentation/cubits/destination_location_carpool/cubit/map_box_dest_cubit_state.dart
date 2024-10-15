import 'package:equatable/equatable.dart';

abstract class MapBoxDestCubitState extends Equatable {
  @override
  List<Object> get props => [];
}

class MapBoxDestCubitInitial extends MapBoxDestCubitState {}

class MapBoxDestCubitLoading extends MapBoxDestCubitState {}

class MapBoxDestCubitSuccess extends MapBoxDestCubitState {
  final List<double> coordinates;

  MapBoxDestCubitSuccess(this.coordinates);

  @override
  List<Object> get props => [coordinates];
}

class MapBoxDestCubitFailure extends MapBoxDestCubitState {
  final String errorMessage;

  MapBoxDestCubitFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
