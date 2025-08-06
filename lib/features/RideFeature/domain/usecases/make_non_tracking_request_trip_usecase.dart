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
    this.subcategoryId,
    this.fromTitle,
    this.toTitle,
    this.price,
    this.date,
    this.phone,
    this.passengers,
    this.isPremium,
    this.description,
    this.desc,
  });

  String? subcategoryId;
  String? fromTitle;
  String? toTitle;
  double? price;
  DateTime? date;
  String? phone;
  int? passengers;
  bool? isPremium;
  String? description;
  String? desc;

  Map<String, dynamic> toJson() {
    var json = {
        "subcategoryId": subcategoryId ?? "",
        "fromTitle": fromTitle ?? "",
        "toTitle": toTitle ?? "",
        "price": price ?? 0.0,
        "date": date?.toIso8601String(),
        "phone": phone ?? "",
        "passengers": passengers ?? 0,
        "isPremium": isPremium ?? false,
        "description": description ?? "",
        "desc": description ?? "",
      };
    json.removeWhere((key, value) => value == '');
    return json;
  }
}
