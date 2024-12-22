import 'dart:convert';

import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant_mneu.dart';

class RestaurantMneuModel extends RestaurantMenu {
  const RestaurantMneuModel({
    super.id,
    super.restaurantId,
    super.foodName,
    super.price,
    super.picture,
    super.photo,
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

    if (photo != null) {
      result.addAll({'picture': photo});
    }

    return result;
  }

  factory RestaurantMneuModel.fromJson(Map<String, dynamic> map) {
    return RestaurantMneuModel(
      id: map['id'],
      photoPath: map['photoPath'],
      restaurantId: map['restaurantId'],
      foodName: map['foodName'],
      price: map['price']?.toDouble(),
      picture: map['picture'] != null
          ? map['picture'] is String? map['picture'] : map['picture']['mediaKey']
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantMneuModel.fromMap(String source) =>
      RestaurantMneuModel.fromJson(json.decode(source));

  @override
  String toString() {
    return 'RestaurantMneuModel(id: $id, restaurantId: $restaurantId, foodName: $foodName, price: $price, picture: $picture)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RestaurantMneuModel &&
        other.id == id &&
        other.photo == photo &&
        other.photoPath == photoPath &&
        other.restaurantId == restaurantId &&
        other.foodName == foodName &&
        other.price == price &&
        other.picture == picture;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        restaurantId.hashCode ^
        foodName.hashCode ^
        price.hashCode ^
        picture.hashCode;
  }
}
