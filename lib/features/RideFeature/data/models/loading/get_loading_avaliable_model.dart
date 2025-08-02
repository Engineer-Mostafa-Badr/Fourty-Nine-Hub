import 'package:fourtyninehub/features/RideFeature/domain/entities/loading/get_loading_avaliable_entity.dart';

class GetLoadingAvailableModel extends GetLoadingAvailableEntity {
  const GetLoadingAvailableModel({
    super.tripDetails,
    super.subCategory,
    super.clientDetails,
    super.createdAt,
    super.state,
  });

  factory GetLoadingAvailableModel.fromJson(Map<String, dynamic> json) {
    return GetLoadingAvailableModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsHistoryModel.fromJson(json['tripDetails'])
          : null,
      subCategory: json['subCategory'] != null
          ? SubCategoryModel.fromJson(json['subCategory'])
          : null,
      clientDetails: json['clientDetails'] != null
          ? ClientDetailsModel.fromJson(json['clientDetails'])
          : null,
      createdAt: json['createdAt'],
      state: json['state'] != null
          ? TripStateModel.fromJson(json['state'])
          : null,
    );
  }
}

class TripDetailsHistoryModel extends TripDetailsHistoryEntity {
  const TripDetailsHistoryModel({
    super.id,
    super.isPremium,
    super.price,
    super.cargoDescription,
    super.pickupTime,
    super.status,
    super.startLocation,
    super.targetLocation,
  });

  factory TripDetailsHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsHistoryModel(
      id: json['id'],
      isPremium: json['isPremium'],
      price: json['price'],
      cargoDescription: json['cargoDescription'],
      pickupTime: json['pickupTime'],
      status: json['status'],
      startLocation: json['startLocation'] != null
          ? LocationTitleModel.fromJson(json['startLocation'])
          : null,
      targetLocation: json['targetLocation'] != null
          ? LocationTitleModel.fromJson(json['targetLocation'])
          : null,
    );
  }
}

class LocationTitleModel extends LocationTitleEntity {
  const LocationTitleModel({super.title});

  factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
    return LocationTitleModel(
      title: json['title'],
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    super.id,
    super.nameEn,
    super.nameAr,
    super.pictureUrl,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameEn: json['nameEn'],
      nameAr: json['nameAr'],
      pictureUrl: json['pictureUrl'],
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  const ClientDetailsModel({
    super.id,
    super.firstName,
    super.gender,
    super.profilePictureUrl,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      id: json['id'],
      firstName: json['firstName'],
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class RatingModel extends RatingEntity {
  const RatingModel({super.average, super.count});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      count: json['count'],
    );
  }
}

class TripStateModel extends TripStateEntity {
  const TripStateModel({super.isButtonEnabled});

  factory TripStateModel.fromJson(Map<String, dynamic> json) {
    return TripStateModel(
      isButtonEnabled: json['isButtonEnabled'],
    );
  }
}
