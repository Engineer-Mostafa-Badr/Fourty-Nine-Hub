
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/create_price_per_seat_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/repositories/captain_share_repository.dart';

import '../../../../core/error/failure.dart';

class CreatePricePerSeatUseCase {
  final CaptainShareRepository repository;

  CreatePricePerSeatUseCase(this.repository);

  Future<Either<Failure, CreatePricePerSeatEntity>> call(CreatePricePerSeatParams params) {
    return repository.createPricePerSeat(params);
  }
}

class CreatePricePerSeatParams {
  final List<double> fromLocation;
  final List<double> toLocation;
  final String phoneNumber;
  final bool? isLadiesDriver;
  final bool? isLadiesPassenger;
  final bool? isComfort;
  final bool? isPremium;

  CreatePricePerSeatParams( {
    required this.fromLocation,required this.phoneNumber, required this.toLocation, this.isLadiesDriver,this.isPremium, this.isLadiesPassenger, this.isComfort,
  });
  toJson() => {
    if(isPremium!=null)"isPremium" : isPremium,
    if(phoneNumber.isNotEmpty)"phoneNumber":phoneNumber,
    "startLocation": {
      "longitude": fromLocation[1],
      "latitude": fromLocation[0]
    },
    "targetLocation": {
      "longitude": toLocation[1],
      "latitude": toLocation[0]
    },
    "features": [
      if(isLadiesDriver==true) "LADY_DRIVER",
      if(isLadiesPassenger==true) "LADY_PASSENGER",
      if(isComfort==true) "COMFORT"
    ]
  };
}