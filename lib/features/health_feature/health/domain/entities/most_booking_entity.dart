class MostBookingEntity {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? userId;
  final AddressEntity? address;
  final List<MostSubCategoryEntity>? subCategory;
  final double? averageRating;
  final int? totalRatings;
  final String? ratingText;
  final int? bookingCount;
  final int? viewCount;
  final String? profilePicture;
  final String? subscriptionType;
  final int? subscriptionRank;
  final String? waitingTime;
  final bool? isPremium;
  final String? appointmentType;
  final String? price;

  MostBookingEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.userId,
    this.address,
    this.subCategory,
    this.averageRating,
    this.totalRatings,
    this.ratingText,
    this.bookingCount,
    this.viewCount,
    this.profilePicture,
    this.subscriptionType,
    this.subscriptionRank,
    this.waitingTime,
    this.isPremium,
    this.appointmentType,
    this.price,
  });
}

class AddressEntity {
  final MostGovernorateEntity? governorate;
  final MostCityEntity? city;
  final String? address;

  AddressEntity({
    this.governorate,
    this.city,
    this.address,
  });
}

class MostGovernorateEntity {
  final String? id;
  final int? provinceId;
  final String? governorateNameAr;
  final String? governorateNameEn;

  MostGovernorateEntity({
    this.id,
    this.provinceId,
    this.governorateNameAr,
    this.governorateNameEn,
  });
}

class MostCityEntity {
  final String? id;
  final int? governorateId;
  final String? cityNameAr;
  final String? cityNameEn;

  MostCityEntity({
    this.id,
    this.governorateId,
    this.cityNameAr,
    this.cityNameEn,
  });
}

class MostSubCategoryEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  MostSubCategoryEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });
}