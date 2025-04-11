import '../../domain/entities/logs_entity.dart';

class LogsRequestLogsModel extends LogsRequestLogsEntity {
  LogsRequestLogsModel({
    super.id,
    super.userId,
    super.restaurantId,
    super.orders,
    super.total,
    super.createdAt,
    super.subscriptionType,
    super.currencyEn,
    super.currencyAr,
    super.userRateRestaurant,
    super.restaurantRateUser,
  });

  factory LogsRequestLogsModel.fromJson(Map<String, dynamic> json) {
    return LogsRequestLogsModel(
      id: json['_id'],
      userId: json['userId'] != null ? UserIdLogsModel.fromJson(json['userId']) : null,
      restaurantId: json['restaurantId'] != null ? RestaurantIdLogsModel.fromJson(json['restaurantId']) : null,
      orders: json['orders'] != null ? List<OrderLogsModel>.from(json['orders'].map((x) => OrderLogsModel.fromJson(x))) : null,
      total: json['total'],
      createdAt: json['createdAt'],
      subscriptionType: json['subscriptionType'],
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
      userRateRestaurant: json['userRateRestaurant'],
      restaurantRateUser: json['restaurantRateUser'],
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

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'restaurantRate': restaurantRate,
      'USER_PROFILE': (userProfile as UserProfileLogsModel?)?.toJson(),
      'id': id,
    };
  }
}

class UserProfileLogsModel extends UserProfileLogsEntity {
  UserProfileLogsModel({
    super.profilePictureKey,
  });

  factory UserProfileLogsModel.fromJson(Map<String, dynamic> json) {
    return UserProfileLogsModel(
      profilePictureKey: json['profilePictureKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profilePictureKey': profilePictureKey,
    };
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
      subcategoryId: json['subcategoryId'] != null ? SubcategoryIdLogsModel.fromJson(json['subcategoryId']) : null,
      totalRating: json['totalRating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'subcategoryId': (subcategoryId as SubcategoryIdLogsModel?)?.toJson(),
      'totalRating': totalRating,
    };
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
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
    super.id,
  });

  factory FoodIdLogsModel.fromJson(Map<String, dynamic> json) {
    return FoodIdLogsModel(
      foodName: json['foodName'],
      id: json['id'],
    );
  }
}

class LogsRequestLogsResponse {
  final bool status;
  final List<LogsRequestLogsModel>? data;

  LogsRequestLogsResponse({
    required this.status,
    this.data,
  });

  factory LogsRequestLogsResponse.fromJson(Map<String, dynamic> json) {
    return LogsRequestLogsResponse(
      status: json['status'],
      data: json['data'] != null ? List<LogsRequestLogsModel>.from(json['data'].map((x) => LogsRequestLogsModel.fromJson(x))) : null,
    );
  }
}