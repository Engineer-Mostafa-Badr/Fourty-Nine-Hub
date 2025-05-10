import '../../domain/entities/get_client_accepted_trips_entity.dart';

class ClientAcceptedTripModel extends ClientAcceptedTripEntity {
  ClientAcceptedTripModel({
    TripDetailsModel? tripDetails,
    DriverDetailsModel? driverDetails,
  }) : super(tripDetails: tripDetails, driverDetails: driverDetails);

  factory ClientAcceptedTripModel.fromJson(Map<String, dynamic> json) {
    return ClientAcceptedTripModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
    );
  }
}

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    String? id,
    String? status,
    bool? isPremium,
    num? price,
    num? passengers,
    String? date,
    String? note,
    LocationModel? location,
    CategoryModel? category,
    String? createdAt,
  }) : super(
    id: id,
    status: status,
    isPremium: isPremium,
    price: price,
    date: date,
    note: note,
    location: location,
    category: category,
    createdAt: createdAt,
  );

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      status: json['status'],
      isPremium: json['isPremium'],
      price: json['price'],
      passengers: json['passengers']?.toInt(),

      date: json['date'],
      note: json['note'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      createdAt: json['createdAt'],
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({String? fromTitle, String? toTitle})
      : super(fromTitle: fromTitle, toTitle: toTitle);

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({String? nameAr, String? nameEn, String? picture})
      : super(nameAr: nameAr, nameEn: nameEn, picture: picture);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      picture: json['picture'],
    );
  }
}

class DriverDetailsModel extends DriverDetailsEntity {
  DriverDetailsModel({
    String? id,
    String? firstName,
    String? picture,
    RatingModel? rating,
  }) : super(
    id: id,
    firstName: firstName,
    picture: picture,
    rating: rating,
  );

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'],
      firstName: json['firstName'],
      picture: json['picture'],
      rating:
      json['rating'] != null ? RatingModel.fromJson(json['rating']) : null,
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({double? average, int? count})
      : super(average: average, count: count);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'] != null
          ? (json['average'] as num).toDouble()
          : null,
      count: json['count'],
    );
  }
}
