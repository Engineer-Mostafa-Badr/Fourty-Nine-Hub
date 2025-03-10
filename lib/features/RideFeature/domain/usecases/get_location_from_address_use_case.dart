import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/entities/get_location_from_address_entity.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../core/error/failure.dart';

class GetLocationFromAddressUseCase {
  final RideRepository repository;
  GetLocationFromAddressUseCase(this.repository);

  Future<Either<Failure, GetLocationFromAddressEntity>> call(GetLocationFromAddressUseCaseParams params) {
    return repository.getLocationFromAddress(params);
  }
}

class GetLocationFromAddressUseCaseParams {
  final String address;
  final String city;
  final String country;
  GetLocationFromAddressUseCaseParams(this.address, this.city, this.country);

  Map<String, dynamic> toJson() => {'address': '$address, $city, $country'};
}