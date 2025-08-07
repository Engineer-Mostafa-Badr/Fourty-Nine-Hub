import 'package:fourtyninehub/features/RideFeature/data/models/loading/get_loading_accepted_model.dart';

class GetLoadingAcceptedModel extends GetLoadingAcceptedEntity {
  GetLoadingAcceptedModel({
    super.tripDetails,
    super.client,
  });

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
    super.id,
    super.status,
    super.isPremium,
    super.price,
    super.date,
    super.cargoDescription,
    super.createdAt,
    super.location,
    super.category,
  });

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
  LocationModel({super.fromTitle, super.toTitle});

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      fromTitle: json['fromTitle'],
      toTitle: json['toTitle'],
    );
  }
}

class CategoryModel extends CategoryEntity {
  CategoryModel({super.id, super.nameAr, super.nameEn, super.picture});

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
    super.id,
    super.firstName,
    super.gender,
    super.profilePictureKey,
    super.rating,
  });

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
  RatingModel({super.averageRating, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      averageRating: json['averageRating'],
      count: json['count'],
    );
  }
}
