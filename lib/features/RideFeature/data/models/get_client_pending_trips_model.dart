


import '../../domain/entities/get_client_pending_trips_entity.dart';

class ClientPendingTripModel extends ClientPendingTripEntity {
  ClientPendingTripModel({
    TripDetailsModel? tripDetails,
    YourDetailsModel? yourDetails,
  }) : super(tripDetails: tripDetails, yourDetails: yourDetails);

  factory ClientPendingTripModel.fromJson(Map<String, dynamic> json) {
    return ClientPendingTripModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsModel.fromJson(json['tripDetails'])
          : null,
      yourDetails: json['yourDetails'] != null
          ? YourDetailsModel.fromJson(json['yourDetails'])
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
    passengers: passengers,
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

class YourDetailsModel extends YourDetailsEntity {
  YourDetailsModel({
    String? id,
    String? firstName,
    String? lastName,
    String? pictureUrl,
    bool? verifiedBadge, // ✅ NEW FIELD
    RatingModel? rating,
  }) : super(
    id: id,
    firstName: firstName,
    lastName: lastName,
    pictureUrl: pictureUrl,
    verifiedBadge: verifiedBadge, // ✅ INCLUDE HERE
    rating: rating,
  );

  factory YourDetailsModel.fromJson(Map<String, dynamic> json) {
    return YourDetailsModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      pictureUrl: json['pictureUrl'],
      verifiedBadge: json['verifiedBadge'], // ✅ PARSE HERE
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}


class RatingModel extends RatingEntity {
  RatingModel({num? average, int? count})
      : super(average: average, count: count);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      count: json['count'],
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

