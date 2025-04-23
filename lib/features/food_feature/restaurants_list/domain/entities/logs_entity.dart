class LogsRequestLogsEntity {
  final String? id;
  final UserIdLogsEntity? userId;
  final RestaurantIdLogsEntity? restaurantId;
  final List<OrderLogsEntity>? orders;
  final int? total;
  final String? createdAt;
  final bool? seen;
  final String? subscriptionType;
  final String? currencyEn;
  final String? currencyAr;
  final UserRateRestaurantEntity? userRateRestaurant;
  final dynamic restaurantRateUser;
  final String? userRateRestaurantName;
  final String? restaurantRateUserName;

  LogsRequestLogsEntity({
    this.id,
    this.userId,
    this.restaurantId,
    this.orders,
    this.total,
    this.createdAt,
    this.seen,
    this.subscriptionType,
    this.currencyEn,
    this.currencyAr,
    this.userRateRestaurant,
    this.restaurantRateUser,
    this.userRateRestaurantName,
    this.restaurantRateUserName,
  });

  LogsRequestLogsEntity copyWith({
    String? id,
    UserIdLogsEntity? userId,
    RestaurantIdLogsEntity? restaurantId,
    List<OrderLogsEntity>? orders,
    int? total,
    String? createdAt,
    bool? seen,
    String? subscriptionType,
    String? currencyEn,
    String? currencyAr,
    UserRateRestaurantEntity? userRateRestaurant,
    dynamic restaurantRateUser,
    String? userRateRestaurantName,
    String? restaurantRateUserName,
  }) {
    return LogsRequestLogsEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      orders: orders ?? this.orders,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      seen: seen ?? this.seen,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      currencyEn: currencyEn ?? this.currencyEn,
      currencyAr: currencyAr ?? this.currencyAr,
      userRateRestaurant: userRateRestaurant ?? this.userRateRestaurant,
      restaurantRateUser: restaurantRateUser ?? this.restaurantRateUser,
      userRateRestaurantName: userRateRestaurantName ?? this.userRateRestaurantName,
      restaurantRateUserName: restaurantRateUserName ?? this.restaurantRateUserName,
    );
  }
}

class UserIdLogsEntity {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final int? restaurantRate;
  final UserProfileLogsEntity? userProfile;
  final String? id;

  UserIdLogsEntity({
    this.firstName,
    this.lastName,
    this.gender,
    this.restaurantRate,
    this.userProfile,
    this.id,
  });
}

class UserProfileLogsEntity {
  final ProfilePictureKeyEntity? profilePictureKey;

  UserProfileLogsEntity({
    this.profilePictureKey,
  });
}

class ProfilePictureKeyEntity {
  final String? id;
  final String? mediaKey;

  ProfilePictureKeyEntity({
    this.id,
    this.mediaKey,
  });
}

class RestaurantIdLogsEntity {
  final String? id;
  final String? name;
  final SubcategoryIdLogsEntity? subcategoryId;
  final double? totalRating;

  RestaurantIdLogsEntity({
    this.id,
    this.name,
    this.subcategoryId,
    this.totalRating,
  });
}

class SubcategoryIdLogsEntity {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  SubcategoryIdLogsEntity({
    this.id,
    this.nameAr,
    this.nameEn,
  });
}

class OrderLogsEntity {
  final FoodIdLogsEntity? foodId;
  final int? quantity;
  final int? price;
  final int? totalPriceOfItem;
  final String? id;

  OrderLogsEntity({
    this.foodId,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
    this.id,
  });
}

class FoodIdLogsEntity {
  final String? foodName;
  final FoodPictureEntity? picture;
  final String? id;

  FoodIdLogsEntity({
    this.foodName,
    this.picture,
    this.id,
  });
}

class FoodPictureEntity {
  final String? id;
  final String? mediaKey;

  FoodPictureEntity({
    this.id,
    this.mediaKey,
  });
}

class UserRateRestaurantEntity {
  final String? id;
  final String? userId;
  final String? restaurantId;
  final String? comment;
  final int? rate;
  final String? createdAt;
  final String? updatedAt;

  UserRateRestaurantEntity({
    this.id,
    this.userId,
    this.restaurantId,
    this.comment,
    this.rate,
    this.createdAt,
    this.updatedAt,
  });

  // Add the copyWith method
  UserRateRestaurantEntity copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? comment,
    int? rate,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserRateRestaurantEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      comment: comment ?? this.comment,
      rate: rate ?? this.rate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


