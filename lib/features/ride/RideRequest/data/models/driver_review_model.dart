import '../../domain/entity/driver_review_entity.dart';

class DriverReviewModel extends DriverReviewEntity {
  DriverReviewModel(
      {required super.review,
      required super.rate,
      required super.userId,
      required super.driverId,
      required super.id});
}
