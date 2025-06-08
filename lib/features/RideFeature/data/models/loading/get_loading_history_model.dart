import 'package:fourtyninehub/features/RideFeature/domain/entities/loading/get_loading_history_entity.dart';

class GetLoadingHistoryModel extends GetLoadingHistoryEntity {
  GetLoadingHistoryModel({
    TripDetailsHistoryEntity? tripDetails,
    SubCategoryEntity? subCategory,
    ClientDetailsEntity? clientDetails,
    DriverDetailsEntity? driverDetails,
  }) : super(
    tripDetails: tripDetails,
    subCategory: subCategory,
    clientDetails: clientDetails,
    driverDetails: driverDetails,
  );

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
    String? id,
    String? status,
    bool? isPremium,
    num? price,
    String? cargoDescription,
    String? pickupTime,
    String? createdAt,
    LocationTitleEntity? startLocation,
    LocationTitleEntity? targetLocation,
    RateEntity? yourRateClient,
    RateEntity? clientRateYou,
  }) : super(
    id: id,
    status: status,
    isPremium: isPremium,
    price: price,
    cargoDescription: cargoDescription,
    pickupTime: pickupTime,
    createdAt: createdAt,
    startLocation: startLocation,
    targetLocation: targetLocation,
    yourRateClient: yourRateClient,
    clientRateYou: clientRateYou,
  );

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
  LocationTitleModel({String? title}) : super(title: title);

  factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
    return LocationTitleModel(title: json['title']);
  }
}

class RateModel extends RateEntity {
  RateModel({num? rate}) : super(rate: rate);

  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(rate: json['rate']);
  }
}

class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    String? id,
    String? nameAr,
    String? nameEn,
    String? pictureUrl,
  }) : super(
    id: id,
    nameAr: nameAr,
    nameEn: nameEn,
    pictureUrl: pictureUrl,
  );

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
    String? id,
    String? firstName,
    String? gender,
    String? profilePictureUrl,
    bool? verifiedBadge,
    RatingEntity? rating,
  }) : super(
    id: id,
    firstName: firstName,
    gender: gender,
    profilePictureUrl: profilePictureUrl,
    verifiedBadge: verifiedBadge,
    rating: rating,
  );

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
    String? id,
    String? driverUserId,
    String? firsName,
    String? profilePictureUrl,
    RatingEntity? rating,
  }) : super(
    id: id,
    driverUserId: driverUserId,
    firsName: firsName,
    profilePictureUrl: profilePictureUrl,
    rating: rating,
  );

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
  RatingModel({num? average, int? count}) : super(average: average, count: count);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      count: json['count'],
    );
  }
}
