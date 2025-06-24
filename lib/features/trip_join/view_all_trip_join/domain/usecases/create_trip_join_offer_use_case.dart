import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../ride/RideRequest/domain/entity/expected_price_entity.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../entities/expected_price_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class CreateTripJoinOfferUseCase
    extends UseCase<DeleteMyTripJoinEntity, CreateTripJoinParams> {
  final ViewAllTripJoinRepo _repo;
  CreateTripJoinOfferUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> call(CreateTripJoinParams params) {
    return _repo.createTripJoinOffer(params);
  }
}

class CreateTripJoinParams {
  final String creatorPhoneNumber;
  final String subcategoryId;
  final bool isPremium;
  final bool isRepeat;
  final int passengers;
  final String vehicleCarBrandId;
  final String vehicleModelId;
  final DateTime startDate;
  final double startLongitude;
  final double startLatitude;
  final double targetLongitude;
  final double targetLatitude;

  CreateTripJoinParams({
    required this.creatorPhoneNumber,
    required this.subcategoryId,
    required this.isPremium,
    required this.isRepeat,
    required this.passengers,
    required this.vehicleCarBrandId,
    required this.vehicleModelId,
    required this.startDate,
    required this.startLongitude,
    required this.startLatitude,
    required this.targetLongitude,
    required this.targetLatitude,
  });

  Map<String, dynamic> toJson() {
    return {
      "creatorPhoneNumber": creatorPhoneNumber,
      "subcategoryId": subcategoryId,
      "isPremium": isPremium,
      "isRepeat": isRepeat,
      "passengers": passengers,
      "vehicleCarBrandId": vehicleCarBrandId,
      "vehicleModelId": vehicleModelId,
      "startDate": startDate.toIso8601String(),
      "startLocation": {
        "longitude": startLongitude,
        "latitude": startLatitude,
      },
      "targetLocation": {
        "longitude": targetLongitude,
        "latitude": targetLatitude,
      },
    };
  }
}

