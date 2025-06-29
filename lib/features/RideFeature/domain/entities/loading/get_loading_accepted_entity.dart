import 'package:fourtyninehub/features/RideFeature/data/models/loading/get_loading_accepted_model.dart';

class GetLoadingAcceptedModel extends GetLoadingAcceptedEntity {
  GetLoadingAcceptedModel({
    TripDetailsEntity? tripDetails,
    ClientEntity? client,
  }) : super(tripDetails: tripDetails, client: client);

  factory GetLoadingAcceptedModel.fromJson(Map<String, dynamic> json) {
    final trip = json['tripDetails'];
    final client = json['client'];

    return GetLoadingAcceptedModel(
      tripDetails: trip != null ? TripDetailsModel.fromJson(trip) : null,
      client: client != null ? ClientModel.fromJson(client) : null,
    );
  }
}

class TripDetailsModel extends TripDetailsEntity {
  TripDetailsModel({
    String? id,
    String? status,
    bool? isPremium,
    num? price,
    String? date,
    String? cargoDescription,
    String? createdAt,
    LocationEntity? location,
    CategoryEntity? category,
  }) : super(
    id: id,
    status: status,
    isPremium: isPremium,
    price: price,
    date: date,
    cargoDescription: cargoDescription,
    createdAt: createdAt,
    location: location,
    category: category,
  );

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      id: json['id'],
      status: json['status'],
      isPremium: json['isPremium'],
      price: json['price'],
      date: json['date'],
      cargoDescription: json['cargoDescription'],
      createdAt: json['createdAt'],
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
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
  CategoryModel({String? id, String? nameAr, String? nameEn, String? picture})
      : super(id: id, nameAr: nameAr, nameEn: nameEn, picture: picture);

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      picture: json['picture'],
    );
  }
}

class ClientModel extends ClientEntity {
  ClientModel({
    String? id,
    String? firstName,
    String? gender,
    String? profilePictureKey,
    RatingEntity? rating,
  }) : super(
    id: id,
    firstName: firstName,
    gender: gender,
    profilePictureKey: profilePictureKey,
    rating: rating,
  );

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id'],
      firstName: json['firstName'],
      gender: json['gender'],
      profilePictureKey: json['profilePictureKey'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class RatingModel extends RatingEntity {
  RatingModel({num? averageRating, int? count})
      : super(averageRating: averageRating, count: count);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      averageRating: json['averageRating'],
      count: json['count'],
    );
  }
}
