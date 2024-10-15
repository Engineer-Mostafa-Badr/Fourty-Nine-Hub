part of 'map_box_cubit_cubit.dart';

abstract class MapBoxCubitState extends Equatable {
  const MapBoxCubitState();

  @override
  List<Object?> get props => [];
}

class MapBoxCubitInitial extends MapBoxCubitState {}

class MapBoxCubitLoading extends MapBoxCubitState {}

class MapBoxCubitSuccess extends MapBoxCubitState {
  final List<double> coordinates;

  const MapBoxCubitSuccess(this.coordinates);

  @override
  List<Object?> get props => [coordinates];
}

class MapBoxCubitFailure extends MapBoxCubitState {
  final String errorMessage;

  const MapBoxCubitFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
