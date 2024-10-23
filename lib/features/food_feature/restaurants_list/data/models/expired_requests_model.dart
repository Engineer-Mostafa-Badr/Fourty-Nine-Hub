
// Main response class
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
      data: (json['data'] as List?)
              ?.map((x) => OrderData.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

// Order data class
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
      id: json['_id'] ?? json['id'] ?? '',
      user: json['userId'] != null
          ? User.fromJson(json['userId'] as Map<String, dynamic>)
          : User(),
      restaurant: json['restaurantId'] != null
          ? Restaurant.fromJson(json['restaurantId'] as Map<String, dynamic>)
          : Restaurant(),
      orders: (json['orders'] as List?)
              ?.map((x) => OrderItem.fromJson(x as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] is int ? json['total'] as int : 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : DateTime.tryParse(''),
      subscriptionType: json['subscriptionType'] ?? '',
      currency: json['currency'] ?? '',
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

// User class
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
      id: json['_id'] ?? json['id'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      userProfile: json['USER_PROFILE'] != null
          ? UserProfile.fromJson(json['USER_PROFILE'] as Map<String, dynamic>)
          : UserProfile(),
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

// UserProfile class
class UserProfile {
  final ProfilePictureKey? profilePictureKey;

  UserProfile({this.profilePictureKey});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profilePictureKey: json['profilePictureKey'] != null
          ? ProfilePictureKey.fromJson(
              json['profilePictureKey'] as Map<String, dynamic>)
          : ProfilePictureKey(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profilePictureKey': profilePictureKey?.toJson(),
    };
  }
}

// ProfilePictureKey class
class ProfilePictureKey {
  final String? id;
  final String? mediaKey;

  ProfilePictureKey({this.id, this.mediaKey});

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKey(
      id: json['_id'] ?? json['id'] ?? '',
      mediaKey: json['mediaKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'mediaKey': mediaKey,
    };
  }
}

// Restaurant class
class Restaurant {
  final String? id;
  final String? name;
  final Subcategory? subcategory;

  Restaurant({this.id, this.name, this.subcategory});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Unknown Restaurant',
      subcategory: json['subcategoryId'] != null
          ? Subcategory.fromJson(json['subcategoryId'] as Map<String, dynamic>)
          : Subcategory(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'subcategoryId': subcategory?.toJson(),
    };
  }
}

// Subcategory class
class Subcategory {
  final String? id;
  final String? nameAr;
  final String? nameEn;

  Subcategory({this.id, this.nameAr, this.nameEn});

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    return Subcategory(
      id: json['_id'] ?? json['id'] ?? '',
      nameAr: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}

// OrderItem class
class OrderItem {
  final String? id;
  final Food? food;
  final int? quantity;
  final int? price;
  final int? totalPriceOfItem;

  OrderItem({
    this.id,
    this.food,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['_id'] ?? json['id'] ?? "",
      food: json['foodId'] != null
          ? Food.fromJson(json['foodId'] as Map<String, dynamic>)
          : Food(),
      quantity: json['quantity'] ?? 0,
      price: json['price'] ?? 0,
      totalPriceOfItem: json['totalPriceOfItem'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'foodId': food?.toJson(),
      'quantity': quantity,
      'price': price,
      'totalPriceOfItem': totalPriceOfItem,
    };
  }
}

// Food class
class Food {
  final String? id;
  final String? foodName;

  Food({this.id, this.foodName});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'] ?? json['id'] ?? '',
      foodName: json['foodName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'foodName': foodName,
    };
  }
}
