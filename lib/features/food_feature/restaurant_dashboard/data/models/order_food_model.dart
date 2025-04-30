
// Model class (extends entity and includes JSON methods)
import '../../domain/entity/order_food_entity.dart';

class GetFoodRequestModel extends GetFoodRequestEntity {
  GetFoodRequestModel({
    bool? status,
    String? message,
    GetFoodRequestDataEntity? data,
  }) : super(status: status, message: message, data: data);

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
    List<OrderEntity>? orders,
    RestaurantSubscriptionTypeEntity? restaurantSubscriptionType,
    String? subcategoryId,
  }) : super(
    orders: orders,
    restaurantSubscriptionType: restaurantSubscriptionType,
    subcategoryId: subcategoryId,
  );

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
  RestaurantSubscriptionTypeModel({String? ar, String? en})
      : super(ar: ar, en: en);

  factory RestaurantSubscriptionTypeModel.fromJson(Map<String, dynamic> json) {
    return RestaurantSubscriptionTypeModel(
      ar: json['ar'],
      en: json['en'],
    );
  }
}

class OrderModel extends OrderEntity {
  OrderModel({
    String? id,
    UserIdEntity? userId,
    String? restaurantId,
    List<OrderItemEntity>? orders,
    int? total,
    bool? isPremium,
    String? address,
    String? phone,
    String? createdAt,
    String? updatedAt,
    bool? completed,
    int? userRate,
    String? currencyEn,
    String? currencyAr,
    String? openCallAndChat,
  }) : super(
    id: id,
    userId: userId,
    restaurantId: restaurantId,
    orders: orders,
    total: total,
    isPremium: isPremium,
    address: address,
    phone: phone,
    createdAt: createdAt,
    updatedAt: updatedAt,
    completed: completed,
    userRate: userRate,
    currencyEn: currencyEn,
    currencyAr: currencyAr,
    openCallAndChat: openCallAndChat,
  );

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
    String? id,
    String? firstName,
    String? gender,
    UserProfileEntity? userProfile,
  }) : super(
    id: id,
    firstName: firstName,
    gender: gender,
    userProfile: userProfile,
  );

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
    String? id,
    String? userId,
    PictureEntity? profilePictureKey,
  }) : super(
    id: id,
    userId: userId,
    profilePictureKey: profilePictureKey,
  );

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
    String? id,
    String? mediaKey,
  }) : super(id: id, mediaKey: mediaKey);

  factory PictureModel.fromJson(Map<String, dynamic> json) {
    return PictureModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    FoodIdEntity? foodId,
    int? quantity,
    int? price,
    int? totalPriceOfItem,
    String? id,
  }) : super(
    foodId: foodId,
    quantity: quantity,
    price: price,
    totalPriceOfItem: totalPriceOfItem,
    id: id,
  );

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
    String? id,
    String? foodName,
    PictureEntity? picture,
  }) : super(id: id, foodName: foodName, picture: picture);

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
