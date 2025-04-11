// class LogsRequestLogsEntity {
//   final String? id;
//   final UserIdLogsEntity? userId;
//   final RestaurantIdLogsEntity? restaurantId;
//   final List<OrderLogsEntity>? orders;
//   final int? total;
//   final String? createdAt;
//   final String? subscriptionType;
//   final String? currencyEn;
//   final String? currencyAr;
//   final int? userRateRestaurant;
//   final int? restaurantRateUser;
//
//   LogsRequestLogsEntity({
//     this.id,
//     this.userId,
//     this.restaurantId,
//     this.orders,
//     this.total,
//     this.createdAt,
//     this.subscriptionType,
//     this.currencyEn,
//     this.currencyAr,
//     this.userRateRestaurant,
//     this.restaurantRateUser,
//   });
// }
//
// class UserIdLogsEntity {
//   final String? firstName;
//   final String? lastName;
//   final String? gender;
//   final int? restaurantRate;
//   final UserProfileLogsEntity? userProfile;
//   final String? id;
//
//   UserIdLogsEntity({
//     this.firstName,
//     this.lastName,
//     this.gender,
//     this.restaurantRate,
//     this.userProfile,
//     this.id,
//   });
// }
//
// class UserProfileLogsEntity {
//   final String? profilePictureKey;
//
//   UserProfileLogsEntity({
//     this.profilePictureKey,
//   });
// }
//
// class RestaurantIdLogsEntity {
//   final String? id;
//   final String? name;
//   final SubcategoryIdLogsEntity? subcategoryId;
//   final double? totalRating;
//
//   RestaurantIdLogsEntity({
//     this.id,
//     this.name,
//     this.subcategoryId,
//     this.totalRating,
//   });
// }
//
// class SubcategoryIdLogsEntity {
//   final String? id;
//   final String? nameAr;
//   final String? nameEn;
//
//   SubcategoryIdLogsEntity({
//     this.id,
//     this.nameAr,
//     this.nameEn,
//   });
// }
//
// class OrderLogsEntity {
//   final FoodIdLogsEntity? foodId;
//   final int? quantity;
//   final int? price;
//   final int? totalPriceOfItem;
//   final String? id;
//
//   OrderLogsEntity({
//     this.foodId,
//     this.quantity,
//     this.price,
//     this.totalPriceOfItem,
//     this.id,
//   });
// }
//
// class FoodIdLogsEntity {
//   final String? foodName;
//   final String? id;
//
//   FoodIdLogsEntity({
//     this.foodName,
//     this.id,
//   });
// }

class LogsRequestLogsEntity {
  final String? id;
  final UserIdLogsEntity? userId;
  final RestaurantIdLogsEntity? restaurantId;
  final List<OrderLogsEntity>? orders;
  final int? total;
  final String? createdAt;
  final String? subscriptionType;
  final String? currencyEn;
  final String? currencyAr;
  final int? userRateRestaurant;
  final int? restaurantRateUser;

  LogsRequestLogsEntity({
    this.id,
    this.userId,
    this.restaurantId,
    this.orders,
    this.total,
    this.createdAt,
    this.subscriptionType,
    this.currencyEn,
    this.currencyAr,
    this.userRateRestaurant,
    this.restaurantRateUser,
  });

  LogsRequestLogsEntity copyWith({
    String? id,
    UserIdLogsEntity? userId,
    RestaurantIdLogsEntity? restaurantId,
    List<OrderLogsEntity>? orders,
    int? total,
    String? createdAt,
    String? subscriptionType,
    String? currencyEn,
    String? currencyAr,
    int? userRateRestaurant,
    int? restaurantRateUser,
  }) {
    return LogsRequestLogsEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      orders: orders ?? this.orders,
      total: total ?? this.total,
      createdAt: createdAt ?? this.createdAt,
      subscriptionType: subscriptionType ?? this.subscriptionType,
      currencyEn: currencyEn ?? this.currencyEn,
      currencyAr: currencyAr ?? this.currencyAr,
      userRateRestaurant: userRateRestaurant ?? this.userRateRestaurant,
      restaurantRateUser: restaurantRateUser ?? this.restaurantRateUser,
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
  final String? profilePictureKey;

  UserProfileLogsEntity({
    this.profilePictureKey,
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
  final String? id;

  FoodIdLogsEntity({
    this.foodName,
    this.id,
  });
}