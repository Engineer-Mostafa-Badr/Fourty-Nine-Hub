import '../../domain/entities/restaurant.dart';

class GetAllRestaurantModel extends GetAllRestaurantEntity {
  GetAllRestaurantModel({
    super.id,
    super.name,
    super.subcategoryId,
    super.mainCategoryId,
    super.userId,
    super.restaurantMedia,
    super.government,
    super.city,
    super.isActive,
    super.isPremium,
    super.totalRating,
    super.numberOfReviews,
    super.phone,
    super.totalViews,
    super.subscriptionType,
    super.isFavorite,
    super.enableOrDisableChat,
    super.rateName,
    super.menu,
  });

  factory GetAllRestaurantModel.fromJson(Map<String, dynamic> json) {
    return GetAllRestaurantModel(
      id: json['_id'],
      name: json['name'],
      subcategoryId: json['subcategoryId'] != null
          ? SubcategoryIdModel.fromJson(json['subcategoryId'])
          : null,
      mainCategoryId: json['mainCategoryId'] != null
          ? MainCategoryIdModel.fromJson(json['mainCategoryId'])
          : null,
      userId:
      json['userId'] != null ? UserIdModel.fromJson(json['userId']) : null,
      restaurantMedia: json['restaurantMedia'] != null
          ? (json['restaurantMedia'] as List)
          .map((e) => RestaurantMediaModel.fromJson(e))
          .toList()
          : null,
      government: json['government'] != null
          ? GovernmentModel.fromJson(json['government'])
          : null,
      city: json['city'] != null ? CityModel.fromJson(json['city']) : null,
      isActive: json['isActive'],
      isPremium: json['isPremium'],
      totalRating: json['totalRating'],
      numberOfReviews: json['numberOfReviews'],
      phone: json['phone'],
      totalViews: json['totalViews'],
      subscriptionType: json['subscriptionType'] != null
          ? SubscriptionTypeModel.fromJson(json['subscriptionType'])
          : null,
      isFavorite: json['isFavorite'],
      enableOrDisableChat: json['enableOrDisableChat'],
      rateName: json['rateName'] != null
          ? RateNameModel.fromJson(json['rateName'])
          : null,
      menu: json['MENU'] != null
          ? (json['MENU'] as List).map((e) => MenuModel.fromJson(e)).toList()
          : null,
    );
  }

}

// SubcategoryId Model
class SubcategoryIdModel extends SubcategoryIdEntity {
  SubcategoryIdModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory SubcategoryIdModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryIdModel(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}

// MainCategoryId Model
class MainCategoryIdModel extends MainCategoryIdEntity {
  MainCategoryIdModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory MainCategoryIdModel.fromJson(Map<String, dynamic> json) {
    return MainCategoryIdModel(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}

// UserId Model
class UserIdModel extends UserIdEntity {
  UserIdModel({
    super.id,
    super.twitterDocumentation,
  });

  factory UserIdModel.fromJson(Map<String, dynamic> json) {
    return UserIdModel(
      id: json['_id'],
      twitterDocumentation: json['twitter_documentation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'twitter_documentation': twitterDocumentation,
    };
  }
}

// RestaurantMedia Model
class RestaurantMediaModel extends RestaurantMediaEntity {
  RestaurantMediaModel({
    super.id,
    super.mediaKey,
  });

  factory RestaurantMediaModel.fromJson(Map<String, dynamic> json) {
    return RestaurantMediaModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}

// Government Model
class GovernmentModel extends GetAllGovernmentEntity {
  GovernmentModel({
    super.governorateNameAr,
    super.governorateNameEn,
  });

  factory GovernmentModel.fromJson(Map<String, dynamic> json) {
    return GovernmentModel(
      governorateNameAr: json['governorate_name_ar'],
      governorateNameEn: json['governorate_name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'governorate_name_ar': governorateNameAr,
      'governorate_name_en': governorateNameEn,
    };
  }
}

// City Model
class CityModel extends GetAllCityEntity {
  CityModel({
    super.cityNameAr,
    super.cityNameEn,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      cityNameAr: json['city_name_ar'],
      cityNameEn: json['city_name_en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_name_ar': cityNameAr,
      'city_name_en': cityNameEn,
    };
  }
}

// SubscriptionType Model
class SubscriptionTypeModel extends SubscriptionTypeEntity {
  SubscriptionTypeModel({
    super.ar,
    super.en,
  });

  factory SubscriptionTypeModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionTypeModel(
      ar: json['ar'],
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }
}

// RateName Model
class RateNameModel extends RateNameEntity {
  RateNameModel({
    super.ar,
    super.en,
  });

  factory RateNameModel.fromJson(Map<String, dynamic> json) {
    return RateNameModel(
      ar: json['ar'],
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }
}

// Menu Model
class MenuModel extends MenuEntity {
  MenuModel({
    super.id,
    super.restaurantId,
    super.foodName,
    super.price,
    super.picture,
    super.currencyEn,
    super.currencyAr,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['_id'],
      restaurantId: json['restaurantId'],
      foodName: json['foodName'],
      price: json['price'],
      picture:
      json['picture'] != null ? PictureModel.fromJson(json['picture']) : null,
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
    );
  }


}

// Picture Model
class PictureModel extends PictureEntity {
  PictureModel({
    super.id,
    super.mediaKey,
  });

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}

