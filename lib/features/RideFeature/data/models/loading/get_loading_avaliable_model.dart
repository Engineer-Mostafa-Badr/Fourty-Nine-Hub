import 'package:fourtyninehub/features/RideFeature/domain/entities/loading/get_loading_avaliable_entity.dart';

class GetLoadingAvailableModel extends GetLoadingAvailableEntity {
  const GetLoadingAvailableModel({
    TripDetailsHistoryEntity? tripDetails,
    SubCategoryEntity? subCategory,
    ClientDetailsEntity? clientDetails,
    String? createdAt,
    TripStateEntity? state,
  }) : super(
    tripDetails: tripDetails,
    subCategory: subCategory,
    clientDetails: clientDetails,
    createdAt: createdAt,
    state: state,
  );

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
    String? id,
    bool? isPremium,
    num? price,
    String? cargoDescription,
    String? pickupTime,
    String? status,
    LocationTitleEntity? startLocation,
    LocationTitleEntity? targetLocation,
  }) : super(
    id: id,
    isPremium: isPremium,
    price: price,
    cargoDescription: cargoDescription,
    pickupTime: pickupTime,
    status: status,
    startLocation: startLocation,
    targetLocation: targetLocation,
  );

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
  const LocationTitleModel({String? title}) : super(title: title);

  factory LocationTitleModel.fromJson(Map<String, dynamic> json) {
    return LocationTitleModel(
      title: json['title'],
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    String? id,
    String? nameEn,
    String? nameAr,
    String? pictureUrl,
  }) : super(
    id: id,
    nameEn: nameEn,
    nameAr: nameAr,
    pictureUrl: pictureUrl,
  );

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
    String? id,
    String? firstName,
    String? gender,
    String? profilePictureUrl,
    RatingEntity? rating,
  }) : super(
    id: id,
    firstName: firstName,
    gender: gender,
    profilePictureUrl: profilePictureUrl,
    rating: rating,
  );

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
  const RatingModel({num? average, int? count})
      : super(average: average, count: count);

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      average: json['average'],
      count: json['count'],
    );
  }
}

class TripStateModel extends TripStateEntity {
  const TripStateModel({bool? isButtonEnabled})
      : super(isButtonEnabled: isButtonEnabled);

  factory TripStateModel.fromJson(Map<String, dynamic> json) {
    return TripStateModel(
      isButtonEnabled: json['isButtonEnabled'],
    );
  }
}
