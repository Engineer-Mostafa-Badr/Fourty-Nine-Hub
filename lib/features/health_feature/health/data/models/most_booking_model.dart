import '../../domain/entities/most_booking_entity.dart';

class MostBookingModel extends MostBookingEntity {
  MostBookingModel({
    super.id,
    super.firstName,
    super.lastName,
    super.userId,
    super.address,
    super.subCategory,
    super.averageRating,
    super.totalRatings,
    super.ratingText,
    super.bookingCount,
    super.viewCount,
    super.profilePicture,
    super.subscriptionType,
    super.subscriptionRank,
    super.waitingTimeAr,
    super.waitingTimeEn,
    super.currencyAr,
    super.currencyEn,
    super.isPremium,
    super.appointmentType,
    super.price,
  });

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
      waitingTimeAr: json['waitingTime']['ar']?.toString(),
      waitingTimeEn: json['waitingTime']['en']?.toString(),
      currencyAr: json['currencyAr']?.toString(),
      currencyEn: json['currencyEn']?.toString(),
      isPremium: json['isPremium'],
      appointmentType: json['appointmentType'],
      price: json['price'],
    );
  }
}

class AddressModel extends AddressEntity {
  AddressModel({
    super.governorate,
    super.city,
    super.address,
  });

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
    super.id,
    super.provinceId,
    super.governorateNameAr,
    super.governorateNameEn,
  });

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
    super.id,
    super.governorateId,
    super.cityNameAr,
    super.cityNameEn,
  });

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
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory MostSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return MostSubCategoryModel(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }
}
