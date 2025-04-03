// Entity class (no JSON methods)
class GetFoodRequestEntity {
  final bool? status;
  final String? message;
  final GetFoodRequestDataEntity? data;

  GetFoodRequestEntity({
    this.status,
    this.message,
    this.data,
  });
}

class GetFoodRequestDataEntity {
  final List<OrderEntity>? orders;
  final String? restaurantSubscriptionType;
  final String? subcategoryId;

  GetFoodRequestDataEntity({
    this.orders,
    this.restaurantSubscriptionType,
    this.subcategoryId,
  });
}

class OrderEntity {
  final String? id;
  final UserIdEntity? userId;
  final String? restaurantId;
  final List<OrderItemEntity>? orders;
  final int? total;
  final bool? isPremium;
  final String? address;
  final String? phone;
  final String? createdAt;
  final String? updatedAt;
  final bool? completed;
  final String? currencyEn;
  final String? currencyAr;
  final String? openCallAndChat;

  OrderEntity({
    this.id,
    this.userId,
    this.restaurantId,
    this.orders,
    this.total,
    this.isPremium,
    this.address,
    this.phone,
    this.createdAt,
    this.updatedAt,
    this.completed,
    this.currencyEn,
    this.currencyAr,
    this.openCallAndChat,
  });
}

class UserIdEntity {
  final String? id;
  final String? firstName;
  final String? gender;

  UserIdEntity({
    this.id,
    this.firstName,
    this.gender,
  });
}

class OrderItemEntity {
  final FoodIdEntity? foodId;
  final int? quantity;
  final int? price;
  final int? totalPriceOfItem;
  final String? id;

  OrderItemEntity({
    this.foodId,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
    this.id,
  });
}

class FoodIdEntity {
  final String? id;
  final String? foodName;

  FoodIdEntity({
    this.id,
    this.foodName,
  });
}

