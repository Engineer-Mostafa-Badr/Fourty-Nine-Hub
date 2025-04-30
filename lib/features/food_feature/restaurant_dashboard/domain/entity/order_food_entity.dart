class GetFoodRequestEntity {
  final bool? status;
  final String? message;
  final GetFoodRequestDataEntity? data;

  GetFoodRequestEntity({this.status, this.message, this.data});
}

class GetFoodRequestDataEntity {
  final List<OrderEntity>? orders;
  final RestaurantSubscriptionTypeEntity? restaurantSubscriptionType;
  final String? subcategoryId;

  GetFoodRequestDataEntity({
    this.orders,
    this.restaurantSubscriptionType,
    this.subcategoryId,
  });
}

class RestaurantSubscriptionTypeEntity {
  final String? ar;
  final String? en;

  RestaurantSubscriptionTypeEntity({this.ar, this.en});
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
  final int? userRate;
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
    this.userRate,
    this.currencyEn,
    this.currencyAr,
    this.openCallAndChat,
  });
}

class UserIdEntity {
  final String? id;
  final String? firstName;
  final String? gender;
  final UserProfileEntity? userProfile;

  UserIdEntity({this.id, this.firstName, this.gender, this.userProfile});
}

class UserProfileEntity {
  final String? id;
  final String? userId;
  final PictureEntity? profilePictureKey;

  UserProfileEntity({this.id, this.userId, this.profilePictureKey});
}

class PictureEntity {
  final String? id;
  final String? mediaKey;

  PictureEntity({this.id, this.mediaKey});
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
  final PictureEntity? picture;

  FoodIdEntity({this.id, this.foodName, this.picture});
}
