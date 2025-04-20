import '../../domain/entities/logs_entity.dart';

class LogsRequestLogsModel extends LogsRequestLogsEntity {
  LogsRequestLogsModel({
    super.id,
    super.userId,
    super.restaurantId,
    super.orders,
    super.total,
    super.createdAt,
    super.seen,
    super.subscriptionType,
    super.currencyEn,
    super.currencyAr,
    super.userRateRestaurant,
    super.restaurantRateUser,
    super.userRateRestaurantName,
    super.restaurantRateUserName,
  });

  factory LogsRequestLogsModel.fromJson(Map<String, dynamic> json) {
    return LogsRequestLogsModel(
      id: json['_id'],
      userId: json['userId'] != null ? UserIdLogsModel.fromJson(json['userId']) : null,
      restaurantId: json['restaurantId'] != null ? RestaurantIdLogsModel.fromJson(json['restaurantId']) : null,
      orders: json['orders'] != null
          ? List<OrderLogsModel>.from(json['orders'].map((x) => OrderLogsModel.fromJson(x)))
          : null,
      total: json['total'],
      createdAt: json['createdAt'],
      seen: json['seen'],
      subscriptionType: json['subscriptionType'],
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
      userRateRestaurant: json['userRateRestaurant'] != null
          ? UserRateRestaurantModel.fromJson(json['userRateRestaurant'])
          : null,
      restaurantRateUser: json['restaurantRateUser'],
      userRateRestaurantName: json['userRateRestaurantName'],
      restaurantRateUserName: json['restaurantRateUserName'],
    );
  }
}

class UserIdLogsModel extends UserIdLogsEntity {
  UserIdLogsModel({
    super.firstName,
    super.lastName,
    super.gender,
    super.restaurantRate,
    super.userProfile,
    super.id,
  });

  factory UserIdLogsModel.fromJson(Map<String, dynamic> json) {
    return UserIdLogsModel(
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      restaurantRate: json['restaurantRate'],
      userProfile: json['USER_PROFILE'] != null ? UserProfileLogsModel.fromJson(json['USER_PROFILE']) : null,
      id: json['id'],
    );
  }
}

class UserProfileLogsModel extends UserProfileLogsEntity {
  UserProfileLogsModel({super.profilePictureKey});

  factory UserProfileLogsModel.fromJson(Map<String, dynamic> json) {
    return UserProfileLogsModel(
      profilePictureKey: json['profilePictureKey'] != null
          ? ProfilePictureKeyModel.fromJson(json['profilePictureKey'])
          : null,
    );
  }
}

class ProfilePictureKeyModel extends ProfilePictureKeyEntity {
  ProfilePictureKeyModel({
    super.id,
    super.mediaKey,
  });

  factory ProfilePictureKeyModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKeyModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}

class RestaurantIdLogsModel extends RestaurantIdLogsEntity {
  RestaurantIdLogsModel({
    super.id,
    super.name,
    super.subcategoryId,
    super.totalRating,
  });

  factory RestaurantIdLogsModel.fromJson(Map<String, dynamic> json) {
    return RestaurantIdLogsModel(
      id: json['_id'],
      name: json['name'],
      subcategoryId: json['subcategoryId'] != null
          ? SubcategoryIdLogsModel.fromJson(json['subcategoryId'])
          : null,
      totalRating: (json['totalRating'] ?? 0).toDouble(),
    );
  }
}

class SubcategoryIdLogsModel extends SubcategoryIdLogsEntity {
  SubcategoryIdLogsModel({
    super.id,
    super.nameAr,
    super.nameEn,
  });

  factory SubcategoryIdLogsModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryIdLogsModel(
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
    );
  }
}

class OrderLogsModel extends OrderLogsEntity {
  OrderLogsModel({
    super.foodId,
    super.quantity,
    super.price,
    super.totalPriceOfItem,
    super.id,
  });

  factory OrderLogsModel.fromJson(Map<String, dynamic> json) {
    return OrderLogsModel(
      foodId: json['foodId'] != null ? FoodIdLogsModel.fromJson(json['foodId']) : null,
      quantity: json['quantity'],
      price: json['price'],
      totalPriceOfItem: json['totalPriceOfItem'],
      id: json['_id'],
    );
  }
}

class FoodIdLogsModel extends FoodIdLogsEntity {
  FoodIdLogsModel({
    super.foodName,
    super.picture,
    super.id,
  });

  factory FoodIdLogsModel.fromJson(Map<String, dynamic> json) {
    return FoodIdLogsModel(
      foodName: json['foodName'],
      picture: json['picture'] != null ? FoodPictureModel.fromJson(json['picture']) : null,
      id: json['id'],
    );
  }
}

class FoodPictureModel extends FoodPictureEntity {
  FoodPictureModel({
    super.id,
    super.mediaKey,
  });

  factory FoodPictureModel.fromJson(Map<String, dynamic> json) {
    return FoodPictureModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}

class UserRateRestaurantModel extends UserRateRestaurantEntity {
  UserRateRestaurantModel({
    super.id,
    super.userId,
    super.restaurantId,
    super.comment,
    super.rate,
    super.createdAt,
    super.updatedAt,
  });

  factory UserRateRestaurantModel.fromJson(Map<String, dynamic> json) {
    return UserRateRestaurantModel(
      id: json['_id'],
      userId: json['userId'],
      restaurantId: json['restaurantId'],
      comment: json['comment'],
      rate: json['rate'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}
