import 'package:fourtyninehub/features/RideFeature/domain/entities/loading/get_loading_history_entity.dart';

class GetLoadingHistoryModel extends GetLoadingHistoryEntity {
  GetLoadingHistoryModel({
    super.tripDetails,
    super.subCategory,
    super.clientDetails,
    super.driverDetails,
  });

  factory GetLoadingHistoryModel.fromJson(Map<String, dynamic> json) {
    return GetLoadingHistoryModel(
      tripDetails: json['tripDetails'] != null
          ? TripDetailsHistoryModel.fromJson(json['tripDetails'])
          : null,
      subCategory: json['subCategory'] != null
          ? SubCategoryModel.fromJson(json['subCategory'])
          : null,
      clientDetails: json['clientDetails'] != null
          ? ClientDetailsModel.fromJson(json['clientDetails'])
          : null,
      driverDetails: json['driverDetails'] != null
          ? DriverDetailsModel.fromJson(json['driverDetails'])
          : null,
    );
  }
}

class TripDetailsHistoryModel extends TripDetailsHistoryEntity {
  TripDetailsHistoryModel({
    super.id,
    super.status,
    super.isPremium,
    super.price,
    super.cargoDescription,
    super.pickupTime,
    super.createdAt,
    super.startLocation,
    super.targetLocation,
    super.yourRateClient,
    super.clientRateYou,
  });

  factory TripDetailsHistoryModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsHistoryModel(
      id: json['id'],
      status: json['status'],
      isPremium: json['isPremium'],
      price: json['price'],
      cargoDescription: json['cargoDescription'],
      pickupTime: json['pickupTime'],
      createdAt: json['createdAt'],
      startLocation: json['startLocation'] != null
          ? LocationTitleModel.fromJson(json['startLocation'])
          : null,
      targetLocation: json['targetLocation'] != null
          ? LocationTitleModel.fromJson(json['targetLocation'])
          : null,
      yourRateClient: json['yourRateClient'] != null
          ? RateModel.fromJson(json['yourRateClient'])
          : null,
      clientRateYou: json['clientRateYou'] != null
          ? RateModel.fromJson(json['clientRateYou'])
          : null,
    );
  }
}

class LocationTitleModel extends LocationTitleEntity {
  LocationTitleModel({super.title});

  factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
    return LocationTitleModel(title: json['title']);
  }
}

class RateModel extends RateEntity {
  RateModel({super.rate});

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(rate: json['rate']);
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    super.id,
    super.nameAr,
    super.nameEn,
    super.pictureUrl,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
      pictureUrl: json['pictureUrl'],
    );
  }
}

class ClientDetailsModel extends ClientDetailsEntity {
  ClientDetailsModel({
    super.id,
    super.firstName,
    super.gender,
    super.profilePictureUrl,
    super.verifiedBadge,
    super.rating,
  });

  factory ClientDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClientDetailsModel(
      id: json['id'],
      firstName: json['firstName'],
      gender: json['gender'],
      profilePictureUrl: json['profilePictureUrl'],
      verifiedBadge: json['verifiedBadge'],
      rating: json['rating'] != null
          ? RatingModel.fromJson(json['rating'])
          : null,
    );
  }
}

class DriverDetailsModel extends DriverDetailsEntity {
  DriverDetailsModel({
    super.id,
    super.driverUserId,
    super.firsName,
    super.profilePictureUrl,
    super.rating,
  });

  factory DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsModel(
      id: json['id'],
      driverUserId: json['driverUserId'],
      firsName: json['firsName'],
      profilePictureUrl: json['profilePictureUrl'],
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
