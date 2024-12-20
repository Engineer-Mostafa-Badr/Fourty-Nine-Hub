import 'car_id.dart';

class TripRequestOfferModel {
  double? priceOffer;
  String? firstName;
  CarId? carId;
  int? allCountTrip;
  int? averageRating;
  int? arrivalTimeToClient;
  int? distance;
  String? model;
  String? brand;
  bool? comfort;
  String? profilePicture;
  String? subcategoryId;
  String? id;
  TripRequestOfferModel({
    this.priceOffer,
    this.firstName,
    this.carId,
    this.allCountTrip,
    this.averageRating,
    this.arrivalTimeToClient,
    this.id,
    this.distance,
    this.model,
    this.brand,
    this.comfort,
    this.profilePicture,
    this.subcategoryId,
  });

  factory TripRequestOfferModel.fromJson(Map<String, dynamic> json) {
    return TripRequestOfferModel(
      priceOffer: double.parse(json['priceOffer'].toString()),
      firstName: json['firstName'] as String?,
      id: json['_id'],
      carId: json['carId'] == null
          ? null
          : CarId.fromJson(json['carId'] as Map<String, dynamic>),
      allCountTrip: json['allCountTrip'] as int?,
      averageRating: json['averageRating'] as int?,
      arrivalTimeToClient: json['arrivalTimeToClient'] as int?,
      distance: json['distance'] as int?,
      model: json['model'] as String?,
      brand: json['brand'] as String?,
      comfort: json['comfort'] as bool?,
      profilePicture: json['profilePicture'] as String?,
      subcategoryId: json['subcategoryId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'priceOffer': priceOffer,
        'firstName': firstName,
        'carId': carId?.toJson(),
        'allCountTrip': allCountTrip,
        'averageRating': averageRating,
        'arrivalTimeToClient': arrivalTimeToClient,
        'distance': distance,
        'model': model,
        'brand': brand,
        'comfort': comfort,
        'profilePicture': profilePicture,
        'subcategoryId': subcategoryId,
      };
}
