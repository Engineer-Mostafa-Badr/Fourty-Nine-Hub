import 'package:equatable/equatable.dart';

class AdsAddressEntity extends Equatable {
  final String? governmentAr;
  final String? governmentEn;
  final String? cityAr;
  final String? cityEn;
  final String? addressAr;
  final String? addressEn;
  final List<double> coordinates;

  const AdsAddressEntity({
    required this.governmentAr,
    required this.governmentEn,
    required this.cityAr,
    required this.cityEn,
    required this.addressAr,
    required this.addressEn,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [
        governmentAr,
        governmentEn,
        cityAr,
        cityEn,
        addressAr,
        addressEn,
        coordinates,
      ];
}
