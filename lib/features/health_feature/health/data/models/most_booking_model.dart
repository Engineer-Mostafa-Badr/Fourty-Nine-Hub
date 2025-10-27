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
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      userId: json['userId'] ?? json['id'] ?? '',
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'])
          : null,
      subCategory: json['subCategoryId'] != null
          ? MostSubCategoryModel.fromJson(json['subCategoryId'])
          : (json['medicalSpecialization'] != null
              ? MostSubCategoryModel.fromJson(json['medicalSpecialization'])
              : (json['speciality'] != null
                  ? MostSubCategoryModel.fromJson(json['speciality'])
                  : null)),
      averageRating:
          json['averageRating']?.toDouble() ?? json['rating']?.toDouble(),
      totalRatings: json['totalRatings'] ?? 0,
      ratingText: json['ratingText'] ?? '',
      bookingCount: json['bookingCount'] ?? 0,
      viewCount: json['viewCount'] ?? 0,
      profilePicture: json['mediaId'] != null && json['mediaId'] is Map
          ? json['mediaId']['mediaKey'] ?? json['mediaId']['_id']
          : json['profilePicture'] ?? json['image'] ?? '',
      subscriptionType: json['subscriptionType'] ?? json['status'] ?? '',
      subscriptionRank:
          json['subscriptionRank'] ?? (json['status'] == 'pending' ? 0 : 1),
      waitingTimeAr: json['waitingTime'] != null
          ? (json['waitingTime'] is Map
              ? json['waitingTime']['ar']?.toString()
              : json['waitingTime'].toString())
          : (json['detections'] != null &&
                  json['detections'] is List &&
                  (json['detections'] as List).isNotEmpty
              ? '${(json['detections'] as List).first['detectionPeriod']} دقيقة'
              : ''),
      waitingTimeEn: json['waitingTime'] != null
          ? (json['waitingTime'] is Map
              ? json['waitingTime']['en']?.toString()
              : json['waitingTime'].toString())
          : (json['detections'] != null &&
                  json['detections'] is List &&
                  (json['detections'] as List).isNotEmpty
              ? '${(json['detections'] as List).first['detectionPeriod']} minutes'
              : ''),
      currencyAr: json['currencyAr']?.toString() ?? 'جنيه',
      currencyEn: json['currencyEn']?.toString() ?? 'EGP',
      isPremium: json['isPremium'] ?? false,
      appointmentType: json['appointmentType'] ?? 'clinic_visit',
      price: json['price'] ??
          (json['detections'] != null &&
                  json['detections'] is List &&
                  (json['detections'] as List).isNotEmpty
              ? (json['detections'] as List).first['price']
              : null),
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
          ? (json['governorate'] is Map<String, dynamic>
              ? MostGovernorateModel.fromJson(json['governorate'])
              : MostGovernorateModel(id: json['governorate'].toString()))
          : null,
      city: json['city'] != null
          ? (json['city'] is Map<String, dynamic>
              ? MostCityModel.fromJson(json['city'])
              : MostCityModel(id: json['city'].toString()))
          : null,
      address: json['address'] ?? '',
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
      id: json['_id'] ?? json['id'] ?? '',
      provinceId: json['province_id'] ?? 0,
      governorateNameAr:
          json['governorate_name_ar'] ?? json['governorateNameAr'] ?? '',
      governorateNameEn:
          json['governorate_name_en'] ?? json['governorateNameEn'] ?? '',
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
      id: json['_id'] ?? json['id'] ?? '',
      governorateId: json['governorate_id'] ?? 0,
      cityNameAr: json['city_name_ar'] ?? json['cityNameAr'] ?? '',
      cityNameEn: json['city_name_en'] ?? json['cityNameEn'] ?? '',
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
      id: json['_id'] ?? json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
    );
  }
}
