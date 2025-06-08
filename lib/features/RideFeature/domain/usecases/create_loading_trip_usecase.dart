import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/RideFeature/domain/repositories/shipping_repository.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_non_track_trip_use_case.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../../data/models/create_loading_trip_model.dart';
import '../entities/create_loading_trip_entity.dart';

class CreateLoadingTripUseCase
    extends UseCase<bool, CreateLoadingTripParams> {
  final ShippingRepository _repo;

  CreateLoadingTripUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(
      CreateLoadingTripParams params) {
    return _repo.createLoadingTrip(params);
  }
}

class CreateLoadingTripParams {
  final String subcategoryId;
  final String fromTitle;
  final String toTitle;
  final num price;
  final DateTime date;
  final String phone;
  final num passengers;
  final bool isPremium;
  final String description;
  final String desc;


  CreateLoadingTripParams({
    required this.subcategoryId,
    required this.fromTitle,
    required this.toTitle,
    required this.price,
    required this.date,
    required this.phone,
    required this.passengers,
    required this.isPremium,
    required this.description,
    required this.desc,

  });

  Map<String, dynamic> toJson() {
    var json = {
      "subcategoryId": subcategoryId,
      "fromTitle": fromTitle,
      "toTitle": toTitle,
      "price": price,
      "date": date.toIso8601String(),
      "phone": phone,
      "isPremium": isPremium,
      "description": desc
    };
    return json;
  }
}


