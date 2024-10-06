// Root Response Class
class RestaurantOrdersModel {
  final bool status;
  final String message;
  final List<RestaurantOrder> data;

  RestaurantOrdersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RestaurantOrdersModel.fromJson(Map<String, dynamic> json) {
    return RestaurantOrdersModel(
      status: json['status'],
      message: json['message'],
      data: List<RestaurantOrder>.from(
        json['data'].map((x) => RestaurantOrder.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

// RestaurantOrder Class
class RestaurantOrder {
  final String id;
  final UserInfo userInfo;
  final String restaurantId;
  final List<Order> orders;
  final double total;
  final bool isPremium;
  final String address;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String currency;

  RestaurantOrder({
    required this.id,
    required this.userInfo,
    required this.restaurantId,
    required this.orders,
    required this.total,
    required this.isPremium,
    required this.address,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.currency,
  });

  factory RestaurantOrder.fromJson(Map<String, dynamic> json) {
    return RestaurantOrder(
      id: json['_id'],
      userInfo: UserInfo.fromJson(json['userId']),
      restaurantId: json['restaurantId'],
      orders: List<Order>.from(json['orders'].map((x) => Order.fromJson(x))),
      total: (json['total'] as num).toDouble(),
      isPremium: json['isPremium'],
      address: json['address'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userInfo.toJson(),
    'restaurantId': restaurantId,
    'orders': List<dynamic>.from(orders.map((x) => x.toJson())),
    'total': total,
    'isPremium': isPremium,
    'address': address,
    'phone': phone,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'currency': currency,
  };
}

// Order Class
class Order {
  final Food foodId;
  final int quantity;
  final double price;
  final double totalPriceOfItem;
  final String id;

  Order({
    required this.foodId,
    required this.quantity,
    required this.price,
    required this.totalPriceOfItem,
    required this.id,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      foodId: Food.fromJson(json['foodId']),
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      totalPriceOfItem: (json['totalPriceOfItem'] as num).toDouble(),
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'foodId': foodId.toJson(),
    'quantity': quantity,
    'price': price,
    'totalPriceOfItem': totalPriceOfItem,
    '_id': id,
  };
}

// Food Class
class Food {
  final String id;
  final Picture picture;

  Food({
    required this.id,
    required this.picture,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      picture: Picture.fromJson(json['picture']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'picture': picture.toJson(),
  };
}

// Picture Class
class Picture {
  final String id;
  final String mediaKey;

  Picture({
    required this.id,
    required this.mediaKey,
  });

  factory Picture.fromJson(Map<String, dynamic> json) {
    return Picture(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'mediaKey': mediaKey,
  };
}

// UserInfo Class
class UserInfo {
  final String id;
  final String firstName;
  final String lastName;
  final UserProfile userProfile;

  UserInfo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userProfile,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userProfile: UserProfile.fromJson(json['USER_PROFILE']),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'firstName': firstName,
    'lastName': lastName,
    'USER_PROFILE': userProfile.toJson(),
  };
}

// UserProfile Class
class UserProfile {
  final ProfilePictureKey profilePictureKey;

  UserProfile({
    required this.profilePictureKey,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profilePictureKey: ProfilePictureKey.fromJson(json['profilePictureKey']),
    );
  }

  Map<String, dynamic> toJson() => {
    'profilePictureKey': profilePictureKey.toJson(),
  };
}

// ProfilePictureKey Class
class ProfilePictureKey {
  final String id;
  final String mediaKey;

  ProfilePictureKey({
    required this.id,
    required this.mediaKey,
  });

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKey(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'mediaKey': mediaKey,
  };
}
