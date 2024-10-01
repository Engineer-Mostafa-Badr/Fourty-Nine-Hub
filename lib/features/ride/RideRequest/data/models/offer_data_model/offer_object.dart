import 'car_id.dart';

class OfferObject {
  int? priceOffer;
  String? firstName;
  CarId? carId;
  int? allCountTrip;
  int? averageRating;
  int? arrivalTimeToClient;
  int? distance;
  String? model;
  bool? comfort;
  String? brand;
  String? profilePicture;

  OfferObject({
    this.priceOffer,
    this.firstName,
    this.carId,
    this.allCountTrip,
    this.averageRating,
    this.arrivalTimeToClient,
    this.distance,
    this.model,
    this.comfort,
    this.brand,
    this.profilePicture,
  });

  factory OfferObject.fromJson(Map<String, dynamic> json) => OfferObject(
        priceOffer: json['priceOffer'] as int?,
        firstName: json['firstName'] as String?,
        carId: json['carId'] == null
            ? null
            : CarId.fromJson(json['carId'] as Map<String, dynamic>),
        allCountTrip: json['allCountTrip'] as int,
        averageRating: json['averageRating'] as int?,
        arrivalTimeToClient: json['arrivalTimeToClient'] as int?,
        distance: json['distance'] as int?,
        model: json['model'] as String?,
        comfort: json['comfort'] as bool?,
        brand: json['brand'] as String?,
        profilePicture: json['profilePicture'] as String?,
      );

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
        'profilePicture': profilePicture,
      };
}

// {
//   "data": {
//     "offerObject": {
//       "priceOffer": 50, 
//       "firstName": "walal", 
//       "carId": {
//         "_id": "669874705319c6256d7c7670",
//         "Brand": "Volkswagen", 
//         "Model": "Beetle"
//       }, 
//       "allCountTrip": 0, 
//       "averageRating": 0, 
//       "arrivalTimeToClient": 3600, 
//       "distance": 5000, 
//       "model": "Beetle", 
//       "brand": "Volkswagen", 
//       "comfort": false, 
//       "profilePicture": "https://49hub-reels.s3.eu-central-1.amazonaws.com/ride/twitter/66a4118c8a30f11ecd8f9edd/eeed6270-6a1c-4d76-a3ed-4bb015e1160c.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAZI2LDRJFLQMKAMUH%2F20240927%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Date=20240927T150813Z&X-Amz-Expires=3600&X-Amz-Signature=9948ecf66e5098ec3c166f0e0778c8fcbdb60cf6e811febf02733c432323bd59&X-Amz-SignedHeaders=host&x-id=GetObject"
//     }, 
//     "userId": "66c349d7a684ab473f1c1ed7"
//   }
// }