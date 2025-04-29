// Main response class
class ExpiredRequestsResponse {
  final bool status;
  final List<OrderData> data;

  ExpiredRequestsResponse({
    required this.status,
    required this.data,
  });

  factory ExpiredRequestsResponse.fromJson(Map<String, dynamic> json) {
    return ExpiredRequestsResponse(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((x) => OrderData.fromJson(x as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((x) => x.toJson()).toList(),
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
  final SubscriptionType? subscriptionType;
  final String? currencyEn;
  final String? currencyAr;

  OrderData({
    this.id,
    this.user,
    this.restaurant,
    this.orders,
    this.total,
    this.createdAt,
    this.subscriptionType,
    this.currencyEn,
    this.currencyAr,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['_id'],
      user: json['userId'] != null
          ? User.fromJson(json['userId'])
          : null,
      restaurant: json['restaurantId'] != null
          ? Restaurant.fromJson(json['restaurantId'])
          : null,
      orders: (json['orders'] as List<dynamic>?)
          ?.map((x) => OrderItem.fromJson(x))
          .toList() ??
          [],
      total: json['total'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      subscriptionType: json['subscriptionType'] != null
          ? SubscriptionType.fromJson(json['subscriptionType'])
          : null,
      currencyEn: json['currencyEn'],
      currencyAr: json['currencyAr'],
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
      'subscriptionType': subscriptionType?.toJson(),
      'currencyEn': currencyEn,
      'currencyAr': currencyAr,
    };
  }
}

// Subscription Type class
class SubscriptionType {
  final String? ar;
  final String? en;

  SubscriptionType({this.ar, this.en});

  factory SubscriptionType.fromJson(Map<String, dynamic> json) {
    return SubscriptionType(
      ar: json['ar'],
      en: json['en'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }
}

// User class
class User {
  final String? firstName;
  final String? lastName;
  final String? gender;
  final UserProfile? userProfile;
  final String? id;

  User({
    this.firstName,
    this.lastName,
    this.gender,
    this.userProfile,
    this.id,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      userProfile: json['USER_PROFILE'] != null
          ? UserProfile.fromJson(json['USER_PROFILE'])
          : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'USER_PROFILE': userProfile?.toJson(),
      'id': id,
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

// ProfilePictureKey class
class ProfilePictureKey {
  final String? id;
  final String? mediaKey;

  ProfilePictureKey({this.id, this.mediaKey});

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

// Restaurant class
class Restaurant {
  final String? name;
  final Subcategory? subcategory;
  final String? id;

  Restaurant({this.name, this.subcategory, this.id});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['name'],
      subcategory: json['subcategoryId'] != null
          ? Subcategory.fromJson(json['subcategoryId'])
          : null,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subcategoryId': subcategory?.toJson(),
      'id': id,
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
      id: json['_id'],
      nameAr: json['nameAr'],
      nameEn: json['nameEn'],
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
  final Food? food;
  final int? quantity;
  final int? price;
  final int? totalPriceOfItem;
  final String? id;

  OrderItem({
    this.food,
    this.quantity,
    this.price,
    this.totalPriceOfItem,
    this.id,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      food: json['foodId'] != null ? Food.fromJson(json['foodId']) : null,
      quantity: json['quantity'],
      price: json['price'],
      totalPriceOfItem: json['totalPriceOfItem'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'foodId': food?.toJson(),
      'quantity': quantity,
      'price': price,
      'totalPriceOfItem': totalPriceOfItem,
      '_id': id,
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
      id: json['_id'],
      foodName: json['foodName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'foodName': foodName,
    };
  }
}
