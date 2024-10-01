// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fourtyninehub/core/enums/ride_services_enum.dart';

class RideThumbnailEntity {
  String? id;
  String? image;
  String? name;
  RideServicesEnum? service;
  bool? isFavorite;
  num? numberOfAds;
  RideThumbnailEntity({
    this.id,
    this.image,
    this.name,
    this.service,
    this.isFavorite,
    this.numberOfAds,
  });

  @override
  String toString() {
    return 'RideThumbnailEntity(id: $id, image: $image, name: $name, service: $service, isFavorite: $isFavorite, numberOfAds: $numberOfAds)';
  }
}
