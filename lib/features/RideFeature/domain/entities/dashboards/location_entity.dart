import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable{
  final String title;
  // final CoordinatesEntity coordinates;

  const LocationEntity({required this.title, 
  // required this.coordinates
  });
  
  @override
  List<Object?> get props => [title, 
  // coordinates
  ];
}
// coordinates.dart
class CoordinatesEntity extends Equatable{
  final num lat;
  final num lng;

  const CoordinatesEntity({required this.lat, required this.lng});

  @override
  List<Object?> get props => [lat, lng];
}