import 'dart:convert';

class ExpiredRequestsResponse {
  final bool status;
  final List<OrderData>? data;

  ExpiredRequestsResponse({
    required this.status,
    this.data,
  });

  factory ExpiredRequestsResponse.fromJson(Map<String, dynamic> json) {
    return ExpiredRequestsResponse(
      status: json['status'] ?? false,
      data: json['data'] != null
          ? List<OrderData>.from(json['data'].map((x) => OrderData.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class OrderData {
  final String? id;
  final User? user;
  final Restaurant? restaurant;
  final List<OrderItem>? orders;
  final int? total;
  final DateTime? createdAt;
  final String? subscriptionType;
  final String? currency;

  OrderData({
    this.id,
    this.user,
    this.restaurant,
    this.orders,
    this.total,
    this.createdAt,
    this.subscriptionType,
    this.currency,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'] ?? json['id'],
      user: json['userId'] != null ? User.fromJson(json['userId']) : null,
      restaurant: json['restaurantId'] != null
          ? Restaurant.fromJson(json['restaurantId'])
          : null,
      orders: json['orders'] != null
          ? List<OrderItem>.from(
          json['orders'].map((x) => OrderItem.fromJson(x)))
          : null,
      total: json['total'] != null ? json['total'] as int : null,
      createdAt:
      json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      subscriptionType: json['subscriptionType'],
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user?.toJson(),
      'restaurantId': restaurant?.toJson(),
      'orders': orders?.map((x) => x.toJson()).toList(),
      'total': total,
      'createdAt': createdAt?.toIso8601String(),
      'subscriptionType': subscriptionType,
      'currency': currency,
    };
  }
}

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final UserProfile? userProfile;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.gender,
    this.userProfile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      userProfile: json['USER_PROFILE'] != null
          ? UserProfile.fromJson(json['USER_PROFILE'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'USER_PROFILE': userProfile?.toJson(),
    };
  }
}

class UserProfile {
  final ProfilePictureKey? profilePictureKey;

  UserProfile({
    this.profilePictureKey,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profilePictureKey: json['profilePictureKey'] != null
          ? ProfilePictureKey.fromJson(json['profilePictureKey'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profilePictureKey': profilePictureKey?.toJson(),
    };
  }
}

class ProfilePictureKey {
  final String? id;
  final String? mediaKey;

  ProfilePictureKey({
    this.id,
    this.mediaKey,
  });

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKey(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}

class Restaurant {
  final String? id;
  final String? name;

  Restaurant({
    this.id,
    this.name,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class OrderItem {
  final String? id;
  final String? foodId;
  final int? quantity;
  final int? price;
  final int? totalPriceOfItem;

  OrderItem({
    this.id,
    this.foodId,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? json['id'],
      foodId: json['foodId'],
      quantity: json['quantity'] != null ? json['quantity'] as int : null,
      price: json['price'] != null ? json['price'] as int : null,
      totalPriceOfItem: json['totalPriceOfItem'] != null
          ? json['totalPriceOfItem'] as int
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'foodId': foodId,
      'quantity': quantity,
      'price': price,
      'totalPriceOfItem': totalPriceOfItem,
    };
  }
}
