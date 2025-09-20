import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_ratings_entity.dart';

import '../../domain/entities/driver_rating_entity.dart';
import 'driver_details_model.dart';
import 'driver_rating_model.dart';

class DriverRatingsModel extends DriverRatingsEntity{
  DriverRatingsModel({
    required super.driverDetailsEntity,
    required super.driverRatingEntities,
  });

  factory DriverRatingsModel.fromJson(Map<String, dynamic> json) {
    return DriverRatingsModel(
      driverDetailsEntity: DriverDetailsModel.fromJson(json['driverDetails']),
      driverRatingEntities: List<DriverRatingEntity>.from(json['ratings'].map((x) => DriverRatingModel.fromJson(x))),
    );
  }
}