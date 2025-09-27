import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entities/delete_my_trip_join_entity.dart';
import '../repos/view_all_trip_join_repo.dart';

class CreatePickMeOfferUseCase
    extends UseCase<DeleteMyTripJoinEntity, CreatePickMeParams> {
  final ViewAllTripJoinRepo _repo;
  CreatePickMeOfferUseCase(this._repo);

  @override
  Future<Either<Failure, DeleteMyTripJoinEntity>> call(CreatePickMeParams params) {
    return _repo.createPickMeOffer(params);
  }
}

class CreatePickMeParams {
  final String creatorPhoneNumber;
  final String subcategoryId;
  final bool isPremium;
  final bool isRepeat;
  final int passengers;
  final DateTime startDate;
  final double startLongitude;
  final double startLatitude;
  final double targetLongitude;
  final double targetLatitude;

  CreatePickMeParams({
    required this.creatorPhoneNumber,
    required this.subcategoryId,
    required this.isPremium,
    required this.isRepeat,
    required this.passengers,
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

