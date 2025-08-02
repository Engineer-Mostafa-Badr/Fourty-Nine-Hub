


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
    super.id,
    super.status,
    super.isPremium,
    super.price,
    super.passengers,
    super.date,
    super.note,
    LocationModel? super.location,
    CategoryModel? super.category,
    super.createdAt,
  });

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
    super.id,
    super.firstName,
    super.lastName,
    super.pictureUrl,
    super.verifiedBadge, // ✅ NEW FIELD
    RatingModel? super.rating,
  });

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
  RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      count: json['count'],
    );
  }
}

class LocationModel extends LocationEntity {
  LocationModel({super.fromTitle, super.toTitle});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({super.nameAr, super.nameEn, super.picture});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      picture: json['picture'],
    );
  }
}

