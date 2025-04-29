import 'package:equatable/equatable.dart';

class AdsAddressEntity extends Equatable {
  final String government;
  final String city;
  final String address;
  final List<double> coordinates;

  const AdsAddressEntity({
    required this.government,
    required this.city,
    required this.address,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [
        government,
        city,
    address,
        coordinates,
      ];
}
