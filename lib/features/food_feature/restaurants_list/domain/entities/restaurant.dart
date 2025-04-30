class GetAllRestaurantEntity {
  final String? id;
  final String? name;
  final SubcategoryIdEntity? subcategoryId;
  final MainCategoryIdEntity? mainCategoryId;
  final UserIdEntity? userId;
  final List<RestaurantMediaEntity>? restaurantMedia;
  final GetAllGovernmentEntity? government;
  final GetAllCityEntity? city;
  final bool? isActive;
  final bool? isPremium;
  final num? totalRating;
  final num? numberOfReviews;
  final String? phone;
  final num? totalViews;
  final SubscriptionTypeEntity? subscriptionType;
  bool? isFavorite;
  final String? enableOrDisableChat;
  final RateNameEntity? rateName;
  final List<MenuEntity>? menu;

  GetAllRestaurantEntity({
    this.id,
    this.name,
    this.subcategoryId,
    this.mainCategoryId,
    this.userId,
    this.restaurantMedia,
    this.government,
    this.city,
    this.isActive,
    this.isPremium,
    this.totalRating,
    this.numberOfReviews,
    this.phone,
    this.totalViews,
    this.subscriptionType,
    this.isFavorite,
    this.enableOrDisableChat,
    this.rateName,
    this.menu,
  });
  GetAllRestaurantEntity copyWith({
    String? id,
    String? name,
    SubcategoryIdEntity? subcategoryId,
    MainCategoryIdEntity? mainCategoryId,
    UserIdEntity? userId,
    List<RestaurantMediaEntity>? restaurantMedia,
    GetAllGovernmentEntity? government,
    GetAllCityEntity? city,
    bool? isActive,
    bool? isPremium,
    num? totalRating,
    num? numberOfReviews,
    String? phone,
    num? totalViews,
    SubscriptionTypeEntity? subscriptionType,
    bool? isFavorite,
    String? enableOrDisableChat,
    RateNameEntity? rateName,
    List<MenuEntity>? menu,
  }) {
    return GetAllRestaurantEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      userId: userId ?? this.userId,
      restaurantMedia: restaurantMedia ?? this.restaurantMedia,
      government: government ?? this.government,
      city: city ?? this.city,
      isActive: isActive ?? this.isActive,
      isPremium: isPremium ?? this.isPremium,
      totalRating: totalRating ?? this.totalRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      phone: phone ?? this.phone,
      totalViews: totalViews ?? this.totalViews,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      isFavorite: isFavorite ?? this.isFavorite,
      enableOrDisableChat: enableOrDisableChat ?? this.enableOrDisableChat,
      rateName: rateName ?? this.rateName,
      menu: menu ?? this.menu,
    );
  }
}

// SubcategoryId Entity
class SubcategoryIdEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  SubcategoryIdEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });
}

// MainCategoryId Entity
class MainCategoryIdEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  MainCategoryIdEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });
}

// UserId Entity
class UserIdEntity {
  final String? id;
  final bool? twitterDocumentation;

  UserIdEntity({
    this.id,
    this.twitterDocumentation,
  });
}

// RestaurantMedia Entity
class RestaurantMediaEntity {
  final String? id;
  final String? mediaKey;

  RestaurantMediaEntity({
    this.id,
    this.mediaKey,
  });
}

// Government Entity
class GetAllGovernmentEntity {
  final String? governorateNameAr;
  final String? governorateNameEn;

  GetAllGovernmentEntity({
    this.governorateNameAr,
    this.governorateNameEn,
  });
}

// City Entity
class GetAllCityEntity {
  final String? cityNameAr;
  final String? cityNameEn;

  GetAllCityEntity({
    this.cityNameAr,
    this.cityNameEn,
  });
}

// SubscriptionType Entity
class SubscriptionTypeEntity {
  final String? ar;
  final String? en;

  SubscriptionTypeEntity({
    this.ar,
    this.en,
  });
}

// RateName Entity
class RateNameEntity {
  final String? ar;
  final String? en;

  RateNameEntity({
    this.ar,
    this.en,
  });
}

// Menu Entity
class MenuEntity {
  final String? id;
  final String? restaurantId;
  final String? foodName;
  final num? price;
  final PictureEntity? picture;
  final String? currencyEn;
  final String? currencyAr;

  MenuEntity({
    this.id,
    this.restaurantId,
    this.foodName,
    this.price,
    this.picture,
    this.currencyEn,
    this.currencyAr,
  });
}

// Picture Entity
class PictureEntity {
  final String? id;
  final String? mediaKey;

  PictureEntity({
    this.id,
    this.mediaKey,
  });
}