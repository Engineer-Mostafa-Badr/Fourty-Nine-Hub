import 'package:fourtyninehub/features/RideFeature/domain/entities/dashboards/update_trip_price_entity.dart';

class UpdateTripPriceModel extends UpdateTripPriceEntity{
  UpdateTripPriceModel({required super.tripId, required super.price});
  //fromJson
  factory UpdateTripPriceModel.fromJson(Map<String, dynamic> json) {
    return UpdateTripPriceModel(
        tripId: json['id'] ?? '',
        price: json['newPrice'] ?? 0);
  }
}