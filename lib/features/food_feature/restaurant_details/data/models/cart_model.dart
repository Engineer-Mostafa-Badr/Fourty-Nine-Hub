
class Cart {
  final bool status;
  final String id;
  final String userId;
  final List<CartItem> allItems;
  final double subTotal;
  final String createdAt;
  final String updatedAt;
  final String currencyAr; // Added currency field
  final String currencyEn; // Added currency field

  Cart({
    required this.status,
    required this.id,
    required this.userId,
    required this.allItems,
    required this.subTotal,
    required this.createdAt,
    required this.updatedAt,
    required this.currencyAr, // Initialize currency
    required this.currencyEn, // Initialize currency
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return Cart(
      status: json['status'],
      id: data['_id'],
      userId: data['userId'],
      allItems: List<CartItem>.from(
        data['allItems'].map((item) => CartItem.fromJson(item)),
      ),
      subTotal: (data['subTotal'] as num).toDouble(),
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
      currencyAr: data['currencyAr'], // Parse currency
      currencyEn: data['currencyEn'], // Parse currency
    );
  }
}

class CartItem {
  final String id;
  final CartRestaurant? restaurant; // Nullable
  final List<RestaurantItem> restaurantItems;
  final double total;

  CartItem({
    required this.id,
    this.restaurant, // Nullable
    required this.restaurantItems,
    required this.total,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      restaurant: json['restaurantId'] != null
          ? CartRestaurant.fromJson(json['restaurantId'])
          : null, // Handle null
      restaurantItems: json['restaurantItems'] != null
          ? List<RestaurantItem>.from(
        json['restaurantItems'].map((item) => RestaurantItem.fromJson(item)),
      )
          : [],
      total: (json['total'] as num).toDouble(),
    );
  }
}

class CartRestaurant {
  final String id;
  final String name;
  final List<Media> restaurantMedia;

  CartRestaurant({
    required this.id,
    required this.name,
    required this.restaurantMedia,
  });

  factory CartRestaurant.fromJson(Map<String, dynamic> json) {
    return CartRestaurant(
      id: json['_id'],
      name: json['name'],
      restaurantMedia: json['restaurantMedia'] != null
          ? List<Media>.from(
        json['restaurantMedia'].map((item) => Media.fromJson(item)),
      )
          : [],
    );
  }
}

class RestaurantItem {
  final String id;
  final Food? food; // Nullable
  final int quantity;
  final double price;
  final double totalPriceOfItem;

  RestaurantItem({
    required this.id,
    this.food, // Nullable
    required this.quantity,
    required this.price,
    required this.totalPriceOfItem,
  });

  factory RestaurantItem.fromJson(Map<String, dynamic> json) {
    return RestaurantItem(
      id: json['_id'],
      food: json['foodId'] != null
          ? Food.fromJson(json['foodId'])
          : null, // Handle null
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      totalPriceOfItem: (json['totalPriceOfItem'] as num).toDouble(),
    );
  }
}

class Food {
  final String id;
  final String foodName;
  final double price;
  final Media picture;

  Food({
    required this.id,
    required this.foodName,
    required this.price,
    required this.picture,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['_id'],
      foodName: json['foodName'],
      price: (json['price'] as num).toDouble(),
      picture: Media.fromJson(json['picture']),
    );
  }
}

class Media {
  final String id;
  final String mediaKey;

  Media({
    required this.id,
    required this.mediaKey,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}
