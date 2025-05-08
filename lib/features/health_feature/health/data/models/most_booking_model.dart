import '../../domain/entities/most_booking_entity.dart';

class MostBookingModel extends MostBookingEntity {
  MostBookingModel({
    String? id,
    String? firstName,
    String? lastName,
    String? userId,
    AddressEntity? address,
    List<MostSubCategoryEntity>? subCategory,
    double? averageRating,
    int? totalRatings,
    String? ratingText,
    int? bookingCount,
    int? viewCount,
    String? profilePicture,
    String? subscriptionType,
    int? subscriptionRank,
    String? waitingTime,
    bool? isPremium,
    String? appointmentType,
    num? price,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          userId: userId,
          address: address,
          subCategory: subCategory,
          averageRating: averageRating,
          totalRatings: totalRatings,
          ratingText: ratingText,
          bookingCount: bookingCount,
          viewCount: viewCount,
          profilePicture: profilePicture,
          subscriptionType: subscriptionType,
          subscriptionRank: subscriptionRank,
          waitingTime: waitingTime,
          isPremium: isPremium,
          appointmentType: appointmentType,
          price: price,
        );

  factory MostBookingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MostBookingModel();

    return MostBookingModel(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userId: json['userId'],
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      subCategory: (json['subCategory'] as List<dynamic>?)
          ?.map((e) => MostSubCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      averageRating: json['averageRating']?.toDouble(),
      totalRatings: json['totalRatings'],
      ratingText: json['ratingText'],
      bookingCount: json['bookingCount'],
      viewCount: json['viewCount'],
      profilePicture: json['profilePicture'],
      subscriptionType: json['subscriptionType'],
      subscriptionRank: json['subscriptionRank'],
      waitingTime: json['waitingTime']?.toString(),
      isPremium: json['isPremium'],
      appointmentType: json['appointmentType'],
      price: json['price'],
    );
  }
}

class AddressModel extends AddressEntity {
  AddressModel({
    MostGovernorateEntity? governorate,
    MostCityEntity? city,
    String? address,
  }) : super(
          governorate: governorate,
          city: city,
          address: address,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      governorate: json['governorate'] != null
          ? MostGovernorateModel.fromJson(json['governorate'])
          : null,
      city: json['city'] != null ? MostCityModel.fromJson(json['city']) : null,
      address: json['address'],
    );
  }
}

class MostGovernorateModel extends MostGovernorateEntity {
  MostGovernorateModel({
    String? id,
    int? provinceId,
    String? governorateNameAr,
    String? governorateNameEn,
  }) : super(
          id: id,
          provinceId: provinceId,
          governorateNameAr: governorateNameAr,
          governorateNameEn: governorateNameEn,
        );

  factory MostGovernorateModel.fromJson(Map<String, dynamic> json) {
    return MostGovernorateModel(
      id: json['_id'],
      provinceId: json['province_id'],
      governorateNameAr: json['governorate_name_ar'],
      governorateNameEn: json['governorate_name_en'],
    );
  }
}

class MostCityModel extends MostCityEntity {
  MostCityModel({
    String? id,
    int? governorateId,
    String? cityNameAr,
    String? cityNameEn,
  }) : super(
          id: id,
          governorateId: governorateId,
          cityNameAr: cityNameAr,
          cityNameEn: cityNameEn,
        );

  factory MostCityModel.fromJson(Map<String, dynamic> json) {
    return MostCityModel(
      id: json['_id'],
      governorateId: json['governorate_id'],
      cityNameAr: json['city_name_ar'],
      cityNameEn: json['city_name_en'],
    );
  }
}

class MostSubCategoryModel extends MostSubCategoryEntity {
  MostSubCategoryModel({
    String? id,
    String? nameAr,
    String? nameEn,
  }) : super(
          id: id,
          nameAr: nameAr,
          nameEn: nameEn,
        );

  factory MostSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return MostSubCategoryModel(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }
}
