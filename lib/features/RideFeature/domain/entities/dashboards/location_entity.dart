import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable{
  final String type;
  final List<double> coordinates;

  const LocationEntity({required this.type, required this.coordinates});
  
  @override
  List<Object?> get props => [type, coordinates];
}