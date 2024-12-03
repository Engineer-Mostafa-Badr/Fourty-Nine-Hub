// Root Response Class
class RestaurantOrdersModel {
  final bool status;
  final String message;
  final RestaurantData data;

  RestaurantOrdersModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RestaurantOrdersModel.fromJson(Map<String, dynamic> json) {
    return RestaurantOrdersModel(
      status: json['status'],
      message: json['message'],
      data: RestaurantData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

// RestaurantData Class
class RestaurantData {
  final List<RestaurantOrder> orders;
  final String restaurantSubscriptionType;
  final String subcategoryId;

  RestaurantData({
    required this.orders,
    required this.restaurantSubscriptionType,
    required this.subcategoryId,
  });

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      orders: List<RestaurantOrder>.from(
        json['orders'].map((x) => RestaurantOrder.fromJson(x)),
      ),
      restaurantSubscriptionType: json['restaurantSubscriptionType'],
      subcategoryId: json['subcategoryId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'orders': List<dynamic>.from(orders.map((x) => x.toJson())),
    'restaurantSubscriptionType': restaurantSubscriptionType,
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
  final String? address; // Nullable because it might not always be present
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String currencyAr;
  final String currencyEn;
  final String openCallAndChat;

  RestaurantOrder({
    required this.id,
    required this.userInfo,
    required this.restaurantId,
    required this.orders,
    required this.total,
    required this.isPremium,
    this.address, // Nullable address
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.currencyAr,
    required this.currencyEn,
    required this.openCallAndChat,
  });

  factory RestaurantOrder.fromJson(Map<String, dynamic> json) {
    return RestaurantOrder(
      id: json['_id'],
      userInfo: UserInfo.fromJson(json['userId']),
      restaurantId: json['restaurantId'],
      orders: List<Order>.from(json['orders'].map((x) => Order.fromJson(x))),
      total: (json['total'] as num).toDouble(),
      isPremium: json['isPremium'],
      address: json['address'], // Nullable field
      phone: json['phone'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      currencyAr: json['currencyAr'],
      currencyEn: json['currencyEn'],
      openCallAndChat: json['OpenCallAndChat'] ?? 'disable', // Default to 'disable' if not present
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': userInfo.toJson(),
    'restaurantId': restaurantId,
    'orders': List<dynamic>.from(orders.map((x) => x.toJson())),
    'total': total,
    'isPremium': isPremium,
    'address': address, // Nullable field
    'phone': phone,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'currencyAr': currencyAr,
    'currencyEn': currencyEn,
    'OpenCallAndChat': openCallAndChat,
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
      foodId:json['foodId']!=null? Food.fromJson(json['foodId']):Food(id: '', foodName: ''),
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
  final String foodName;

  Food({
    required this.id,
    required this.foodName,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'],
      foodName: json['foodName'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'foodName': foodName,
  };
}

// UserInfo Class
class UserInfo {
  final String id;
  final String firstName;
  final String gender;

  UserInfo({
    required this.id,
    required this.firstName,
    required this.gender,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'],
      firstName: json['firstName'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'firstName': firstName,
    'gender': gender,
  };
}
