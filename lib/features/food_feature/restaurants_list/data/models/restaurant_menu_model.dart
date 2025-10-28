import 'dart:convert';

import '../../domain/entities/restaurant_menu.dart';

class RestaurantMenuModel extends RestaurantMenu {
  const RestaurantMenuModel({
    super.id,
    super.restaurantId,
    super.foodName,
    super.price,
    super.picture,
    super.photo,
    super.description,
    this.photoPath,
  });

  final String? photoPath;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (photoPath != null) {
      result.addAll({'photoPath': id});
    }
    if (photo != null) {
      result.addAll({'picture': photo});
    }
    if (restaurantId != null) {
      result.addAll({'restaurantId': restaurantId});
    }
    if (foodName != null) {
      result.addAll({'foodName': foodName});
    }
    if (price != null) {
      result.addAll({'price': price});
    }
    if (description != null) {
      result.addAll({'description': description});
    }

    if (photo != null) {
      result.addAll({'picture': photo});
    }

    return result;
  }

  factory RestaurantMenuModel.fromJson(Map<String, dynamic> map) {
    return RestaurantMenuModel(
      id: map['id'],
      photoPath: map['photoPath'],
      restaurantId: map['restaurantId'],
      foodName: map['foodName'],
      price: map['price']?.toDouble(),
      description: map['description'],
      picture: map['picture'] != null
          ? map['picture'] is String
              ? map['picture']
              : map['picture']['mediaKey']
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantMenuModel.fromMap(String source) =>
      RestaurantMenuModel.fromJson(json.decode(source));

  @override
  String toString() {
    return 'RestaurantMenuModel(id: $id, restaurantId: $restaurantId, foodName: $foodName, price: $price, picture: $picture, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantMenuModel &&
        other.id == id &&
        other.photo == photo &&
        other.photoPath == photoPath &&
        other.restaurantId == restaurantId &&
        other.foodName == foodName &&
        other.price == price &&
        other.description == description &&
        other.picture == picture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        restaurantId.hashCode ^
        foodName.hashCode ^
        price.hashCode ^
        description.hashCode ^
        picture.hashCode;
  }
}
