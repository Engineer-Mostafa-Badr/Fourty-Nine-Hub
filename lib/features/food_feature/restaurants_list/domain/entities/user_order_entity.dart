class UserOrderEntity {
  final String? id;
  final UserDataOrderEntity? user;
  final List<RestaurantOrderEntity>? restaurants;
  final int? subTotal;
  final bool? isPremium;
  final String? phone;
  final String? currencyEn;
  final String? currencyAr;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserOrderEntity({
    this.id,
    this.user,
    this.restaurants,
    this.subTotal,
    this.isPremium,
    this.phone,
    this.currencyEn,
    this.currencyAr,
    this.createdAt,
    this.updatedAt,
  });
}

class UserDataOrderEntity {
  final String? id;
  final String? email;
  final String? firstName;
  final String? lastName;
  final UserProfileOrderEntity? profile;

  UserDataOrderEntity({
    this.id,
    this.email,
    this.firstName,
    this.lastName,
    this.profile,
  });
}

class UserProfileOrderEntity {
  final String? profilePictureKey;

  UserProfileOrderEntity({
    this.profilePictureKey,
  });
}

class RestaurantOrderEntity {
  final RestaurantDataEntity? restaurant;
  final List<OrderItemEntity>? orders;
  final int? total;
  final String? id;

  RestaurantOrderEntity({
    this.restaurant,
    this.orders,
    this.total,
    this.id,
  });
}

class RestaurantDataEntity {
  final String? id;
  final String? name;
  final List<MediaEntity>? restaurantMedia;

  RestaurantDataEntity({
    this.id,
    this.name,
    this.restaurantMedia,
  });
}

class OrderItemEntity {
  final FoodEntity? food;
  final int? quantity;
  final int? price;
  final int? totalPriceOfItem;
  final String? id;

  OrderItemEntity({
    this.food,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
    this.id,
  });
}

class FoodEntity {
  final String? id;
  final MediaEntity? picture;

  FoodEntity({
    this.id,
    this.picture,
  });
}

class MediaEntity {
  final String? id;
  final String? mediaKey;

  MediaEntity({
    this.id,
    this.mediaKey,
  });
}
