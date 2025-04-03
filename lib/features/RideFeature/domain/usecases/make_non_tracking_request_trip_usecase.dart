import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/error/failure.dart';

class MakeNonTrackingRequestTripUsecase {
  final RideRepository _repo;
  MakeNonTrackingRequestTripUsecase(this._repo);

  Future<Either<Failure, bool>> call(
      MakeNonTrackingRequestTripUsecaseParam params) {
    return _repo.makeNonTrackingRequestTrip(params);
  }
}

class MakeNonTrackingRequestTripUsecaseParam {
  MakeNonTrackingRequestTripUsecaseParam({
    required this.subcategoryId,
    required this.fromTitle,
    required this.toTitle,
    required this.price,
    required this.date,
    required this.phone,
    required this.passengers,
    required this.isPremium,
    required this.description,
  });

  final String subcategoryId;
  final String fromTitle;
  final String toTitle;
  final double price;
  final DateTime? date;
  final String phone;
  final int passengers;
  final bool isPremium;
  final String description;

  Map<String, dynamic> toJson() => {
        "subcategoryId": subcategoryId,
        "fromTitle": fromTitle,
        "toTitle": toTitle,
        "price": price,
        "date": date?.toIso8601String(),
        "phone": phone,
        "passengers": passengers,
        "isPremium": isPremium,
        "description": description,
      };
}
