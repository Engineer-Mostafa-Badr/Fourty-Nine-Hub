import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/core/enums/ride_services_enum.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';

class RideThumbnailModel extends RideThumbnailEntity {
  RideThumbnailModel(
      {required super.id,
      required super.image,
      required super.name,
      required super.service});

  factory RideThumbnailModel.fromJson(Map<String, dynamic> json) {
    return RideThumbnailModel(
      id: json['_id'] ?? '',
      image: json['picture'] ?? '',
      name: getLang() == 'ar' ? json['nameAr'] ?? '' : json['nameEn'] ?? '',
      service: ((json['nameEn'] ?? '') as String).toRideServiceEnum,
    );
  }
}
