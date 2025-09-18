import 'package:fourtyninehub/features/RideFeature/domain/entities/driver_rating_entity.dart';

import 'driver_details_entity.dart';

class DriverRatingsEntity {
  final DriverDetailsEntity driverDetailsEntity;
  final List<DriverRatingEntity> driverRatingEntities;

  DriverRatingsEntity({required this.driverDetailsEntity, required this.driverRatingEntities});
}