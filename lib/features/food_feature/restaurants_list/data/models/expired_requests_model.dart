
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
      data: json['data'] != null
          ? List<OrderData>.from(
          json['data'].map((x) => OrderData.fromJson(x as Map<String, dynamic>)))
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
    try {
      return OrderData(
        id: json['_id'] ?? json['id'],
        user: json['userId'] != null
            ? User.fromJson(json['userId'] as Map<String, dynamic>)
            : null,
        restaurant: json['restaurantId'] != null
            ? Restaurant.fromJson(json['restaurantId'] as Map<String, dynamic>)
            : null,
        orders: json['orders'] != null
            ? List<OrderItem>.from(
            json['orders'].map((x) => OrderItem.fromJson(x as Map<String, dynamic>)))
            : null,
        total: json['total'] is int ? json['total'] as int : null,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
        subscriptionType: json['subscriptionType'] as String?,
        currency: json['currency'] as String?,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing OrderData: $e');
      return OrderData(); // Return an empty OrderData object
    }
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
    try {
      return User(
        id: json['_id'] ?? json['id'],
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        gender: json['gender'] as String?,
        userProfile: json['USER_PROFILE'] != null
            ? UserProfile.fromJson(json['USER_PROFILE'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing User: $e');
      return User(); // Return an empty User object
    }
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

  UserProfile({
    this.profilePictureKey,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    try {
      return UserProfile(
        profilePictureKey: json['profilePictureKey'] != null
            ? ProfilePictureKey.fromJson(json['profilePictureKey'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing UserProfile: $e');
      return UserProfile(); // Return an empty UserProfile object
    }
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

  ProfilePictureKey({
    this.id,
    this.mediaKey,
  });

  factory ProfilePictureKey.fromJson(Map<String, dynamic> json) {
    try {
      return ProfilePictureKey(
        id: json['_id'] ?? json['id'],
        mediaKey: json['mediaKey'] as String?,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing ProfilePictureKey: $e');
      return ProfilePictureKey(); // Return an empty ProfilePictureKey object
    }
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

  Restaurant({
    this.id,
    this.name,
    this.subcategory,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    try {
      return Restaurant(
        id: json['_id'] ?? json['id'],
        name: json['name'] as String?,
        subcategory: json['subcategoryId'] != null
            ? Subcategory.fromJson(json['subcategoryId'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing Restaurant: $e');
      return Restaurant(); // Return an empty Restaurant object
    }
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

  Subcategory({
    this.id,
    this.nameAr,
    this.nameEn,
  });

  factory Subcategory.fromJson(Map<String, dynamic> json) {
    try {
      return Subcategory(
        id: json['_id'] ?? json['id'],
        nameAr: json['nameAr'] as String?,
        nameEn: json['nameEn'] as String?,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing Subcategory: $e');
      return Subcategory(); // Return an empty Subcategory object
    }
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
  final Food? food; // Changed from String? foodId to Food? food
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
    try {
      return OrderItem(
        id: json['_id'] ?? json['id'],
        food: json['foodId'] != null
            ? Food.fromJson(json['foodId'] as Map<String, dynamic>)
            : null,
        quantity: json['quantity'] is int ? json['quantity'] as int : null,
        price: json['price'] is int ? json['price'] as int : null,
        totalPriceOfItem:
        json['totalPriceOfItem'] is int ? json['totalPriceOfItem'] as int : null,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing OrderItem: $e');
      return OrderItem(); // Return an empty OrderItem object
    }
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

  Food({
    this.id,
    this.foodName,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    try {
      return Food(
        id: json['_id'] ?? json['id'],
        foodName: json['foodName'] as String?,
      );
    } catch (e) {
      // Log the error if necessary
      print('Error parsing Food: $e');
      return Food(); // Return an empty Food object
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'foodName': foodName,
    };
  }
}
