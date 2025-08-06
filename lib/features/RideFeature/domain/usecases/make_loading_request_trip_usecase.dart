import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/ride_repository.dart';

import '../../../../../core/error/failure.dart';

class MakeLoadingRequestTripUsecase {
  final RideRepository _repo;
  MakeLoadingRequestTripUsecase(this._repo);

  Future<Either<Failure, bool>> call(
      MakeLoadingRequestTripUsecaseParam params) {
    return _repo.makeLoadingRequestTrip(params);
  }
}

class MakeLoadingRequestTripUsecaseParam {
  MakeLoadingRequestTripUsecaseParam({
    this.subcategoryId,
    this.fromTitle,
    this.toTitle,
    this.price,
    this.date,
    this.phone,
    this.isPremium,
    this.desc,
  });

  String? subcategoryId;
  String? fromTitle;
  String? toTitle;
  double? price;
  DateTime? date;
  String? phone;
  bool? isPremium;
  String? desc;

  Map<String, dynamic> toJson() => {
        "categoryId": subcategoryId ?? "",
        "startLocation": fromTitle ?? "",
        "targetLocation": toTitle ?? "",
        "price": price ?? 0.0,
        "time": date?.toIso8601String(),
        "phone": phone ?? "",
        "isPremium": isPremium ?? false,
        "desc": desc ?? "",
      };
}
