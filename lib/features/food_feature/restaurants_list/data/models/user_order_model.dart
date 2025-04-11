
import '../../domain/entities/user_order_entity.dart';

class UserOrderModel extends UserOrderEntity {
  UserOrderModel({
    super.id,
    super.user,
    super.restaurants,
    super.subTotal,
    super.isPremium,
    super.phone,
    super.currencyEn,
    super.currencyAr,
    super.createdAt,
    super.updatedAt,
  });

  factory UserOrderModel.fromJson(Map<String, dynamic> json) {
    return UserOrderModel(
      id: json['_id'],
      user: json['userId'] != null ? UserModel.fromJson(json['userId']) : null,
      restaurants: (json['restaurants'] as List<dynamic>?)
          ?.map((e) => RestaurantOrderModel.fromJson(e))
          .toList(),
      subTotal: json['subTotal'],
      isPremium: json['isPremium'],
      phone: json['phone'],
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }
}

class UserModel extends UserDataOrderEntity {
  UserModel({
    super.id,
    super.email,
    super.firstName,
    super.lastName,
    super.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profile: json['USER_PROFILE'] != null
          ? UserProfileModel.fromJson(json['USER_PROFILE'])
          : null,
    );
  }
}

class UserProfileModel extends UserProfileOrderEntity {
  UserProfileModel({super.profilePictureKey});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(profilePictureKey: json['profilePictureKey']);
  }
}

class RestaurantOrderModel extends RestaurantOrderEntity {
  RestaurantOrderModel({
    super.id,
    super.orders,
    super.restaurant,
    super.total,
  });

  factory RestaurantOrderModel.fromJson(Map<String, dynamic> json) {
    return RestaurantOrderModel(
      id: json['_id'],
      total: json['total'],
      restaurant: json['restaurantId'] != null
          ? UserRestaurantModel.fromJson(json['restaurantId'])
          : null,
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}

class UserRestaurantModel extends RestaurantDataEntity {
  UserRestaurantModel({
    super.id,
    super.name,
    super.restaurantMedia,
  });

  factory UserRestaurantModel.fromJson(Map<String, dynamic> json) {
    return UserRestaurantModel(
      id: json['id'],
      name: json['name'],
      restaurantMedia: (json['restaurantMedia'] as List<dynamic>?)
          ?.map((e) => MediaModel.fromJson(e))
          .toList(),
    );
  }
}

class OrderItemModel extends OrderItemEntity {
  OrderItemModel({
    super.id,
    super.food,
    super.quantity,
    super.price,
    super.totalPriceOfItem,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['_id'],
      quantity: json['quantity'],
      price: json['price'],
      totalPriceOfItem: json['totalPriceOfItem'],
      food: json['foodId'] != null ? FoodModel.fromJson(json['foodId']) : null,
    );
  }
}

class FoodModel extends FoodEntity {
  FoodModel({
    super.id,
    super.picture,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      id: json['id'],
      picture: json['picture'] != null ? MediaModel.fromJson(json['picture']) : null,
    );
  }
}

class MediaModel extends MediaEntity {
  MediaModel({
    super.id,
    super.mediaKey,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}
