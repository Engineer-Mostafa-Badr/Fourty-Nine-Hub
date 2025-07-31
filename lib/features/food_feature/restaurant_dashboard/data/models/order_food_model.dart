
// Model class (extends entity and includes JSON methods)
import '../../domain/entity/order_food_entity.dart';

class GetFoodRequestModel extends GetFoodRequestEntity {
  GetFoodRequestModel({
    super.status,
    super.message,
    super.data,
  });

  factory GetFoodRequestModel.fromJson(Map<String, dynamic> json) {
    return GetFoodRequestModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null
          ? GetFoodRequestDataModel.fromJson(json['data'])
          : null,
    );
  }
}

class GetFoodRequestDataModel extends GetFoodRequestDataEntity {
  GetFoodRequestDataModel({
    super.orders,
    super.restaurantSubscriptionType,
    super.subcategoryId,
  });

  factory GetFoodRequestDataModel.fromJson(Map<String, dynamic> json) {
    return GetFoodRequestDataModel(
      orders: json['orders'] != null
          ? (json['orders'] as List)
          .map((i) => OrderModel.fromJson(i))
          .toList()
          : null,
      restaurantSubscriptionType:
      json['restaurantSubscriptionType'] != null
          ? RestaurantSubscriptionTypeModel.fromJson(
          json['restaurantSubscriptionType'])
          : null,
      subcategoryId: json['subcategoryId'],
    );
  }
}

class RestaurantSubscriptionTypeModel extends RestaurantSubscriptionTypeEntity {
  RestaurantSubscriptionTypeModel({super.ar, super.en});

  factory RestaurantSubscriptionTypeModel.fromJson(Map<String, dynamic> json) {
    return RestaurantSubscriptionTypeModel(
      ar: json['ar'],
      en: json['en'],
    );
  }
}

class OrderModel extends OrderEntity {
  OrderModel({
    super.id,
    super.userId,
    super.restaurantId,
    super.orders,
    super.total,
    super.isPremium,
    super.address,
    super.phone,
    super.createdAt,
    super.updatedAt,
    super.completed,
    super.userRate,
    super.currencyEn,
    super.currencyAr,
    super.openCallAndChat,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      userId: json['userId'] != null
          ? UserIdModel.fromJson(json['userId'])
          : null,
      restaurantId: json['restaurantId'],
      orders: json['orders'] != null
          ? (json['orders'] as List)
          .map((i) => OrderItemModel.fromJson(i))
          .toList()
          : null,
      total: json['total'],
      isPremium: json['isPremium'],
      address: json['address'],
      phone: json['phone'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      completed: json['completed'],
      userRate: json['userRate'],
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
      openCallAndChat: json['OpenCallAndChat'],
    );
  }
}

class UserIdModel extends UserIdEntity {
  UserIdModel({
    super.id,
    super.firstName,
    super.gender,
    super.userProfile,
  });

  factory UserIdModel.fromJson(Map<String, dynamic> json) {
    return UserIdModel(
      id: json['_id'],
      firstName: json['firstName'],
      gender: json['gender'],
      userProfile: json['USER_PROFILE'] != null
          ? UserProfileModel.fromJson(json['USER_PROFILE'])
          : null,
    );
  }
}

class UserProfileModel extends UserProfileEntity {
  UserProfileModel({
    super.id,
    super.userId,
    super.profilePictureKey,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['_id'],
      userId: json['userId'],
      profilePictureKey: json['profilePictureKey'] != null
          ? PictureModel.fromJson(json['profilePictureKey'])
          : null,
    );
  }
}

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
}

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    super.foodId,
    super.quantity,
    super.price,
    super.totalPriceOfItem,
    super.id,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      foodId: json['foodId'] != null
          ? FoodIdModel.fromJson(json['foodId'])
          : null,
      quantity: json['quantity'],
      price: json['price'],
      totalPriceOfItem: json['totalPriceOfItem'],
      id: json['_id'],
    );
  }
}

class FoodIdModel extends FoodIdEntity {
  FoodIdModel({
    super.id,
    super.foodName,
    super.picture,
  });

  factory FoodIdModel.fromJson(Map<String, dynamic> json) {
    return FoodIdModel(
      id: json['_id'],
      foodName: json['foodName'],
      picture: json['picture'] != null
          ? PictureModel.fromJson(json['picture'])
          : null,
    );
  }
}
