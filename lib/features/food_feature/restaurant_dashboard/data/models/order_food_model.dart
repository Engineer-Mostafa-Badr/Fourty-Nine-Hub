
// Model class (extends entity and includes JSON methods)
import '../../domain/entity/order_food_entity.dart';

class GetFoodRequestModel extends GetFoodRequestEntity {
  GetFoodRequestModel({
    bool? status,
    String? message,
    GetFoodRequestDataEntity? data,
  }) : super(
    status: status,
    message: message,
    data: data,
  );

  factory GetFoodRequestModel.fromJson(Map<String, dynamic> json) {
    return GetFoodRequestModel(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? GetFoodRequestDataModel.fromJson(json['data']) : null,
    );
  }
}

class GetFoodRequestDataModel extends GetFoodRequestDataEntity {
  GetFoodRequestDataModel({
    List<OrderEntity>? orders,
    String? restaurantSubscriptionType,
    String? subcategoryId,
  }) : super(
    orders: orders,
    restaurantSubscriptionType: restaurantSubscriptionType,
    subcategoryId: subcategoryId,
  );

  factory GetFoodRequestDataModel.fromJson(Map<String, dynamic> json) {
    return GetFoodRequestDataModel(
      orders: json['orders'] != null
          ? (json['orders'] as List).map((i) => OrderModel.fromJson(i)).toList()
          : null,
      restaurantSubscriptionType: json['restaurantSubscriptionType'],
      subcategoryId: json['subcategoryId'],
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
    currencyEn: currencyEn,
    currencyAr: currencyAr,
    openCallAndChat: openCallAndChat,
  );

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'],
      userId: json['userId'] != null ? UserIdModel.fromJson(json['userId']) : null,
      restaurantId: json['restaurantId'],
      orders: json['orders'] != null
          ? (json['orders'] as List).map((i) => OrderItemModel.fromJson(i)).toList()
          : null,
      total: json['total'],
      isPremium: json['isPremium'],
      address: json['address'],
      phone: json['phone'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      completed: json['completed'],
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
  }) : super(
    id: id,
    firstName: firstName,
    gender: gender,
  );

  factory UserIdModel.fromJson(Map<String, dynamic> json) {
    return UserIdModel(
      id: json['_id'],
      firstName: json['firstName'],
      gender: json['gender'],
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
      foodId: json['foodId'] != null ? FoodIdModel.fromJson(json['foodId']) : null,
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
  }) : super(
    id: id,
    foodName: foodName,
  );

  factory FoodIdModel.fromJson(Map<String, dynamic> json) {
    return FoodIdModel(
      id: json['_id'],
      foodName: json['foodName'],
    );
  }
}