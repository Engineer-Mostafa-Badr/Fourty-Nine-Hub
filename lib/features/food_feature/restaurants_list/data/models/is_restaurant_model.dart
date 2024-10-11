import 'dart:convert';

class IsRestaurantModel {
  final bool? isRestaurant;
  final bool? approved;
  final String? restaurantId;

  IsRestaurantModel({
    this.isRestaurant,
    this.approved,
    this.restaurantId,
  });

  // Convert the model to a map
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (isRestaurant != null) {
      result.addAll({'isRestaurant': isRestaurant});
    }
    if (approved != null) {
      result.addAll({'Approved': approved});
    }
    if (restaurantId != null) {
      result.addAll({'restaurantId': restaurantId});
    }

    return result;
  }

  // Create the model from a map
  factory IsRestaurantModel.fromMap(Map<String, dynamic> map) {
    return IsRestaurantModel(
      isRestaurant: map['isRestaurant'],
      approved: map['Approved'],
      restaurantId: map['restaurantId'],
    );
  }

  // Convert the model to JSON
  String toJson() => json.encode(toMap());

  // Create the model from JSON
  factory IsRestaurantModel.fromJson(String source) =>
      IsRestaurantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IsRestaurantModel(isRestaurant: $isRestaurant, Approved: $approved, restaurantId: $restaurantId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsRestaurantModel &&
        other.isRestaurant == isRestaurant &&
        other.approved == approved &&
        other.restaurantId == restaurantId;
  }

  @override
  int get hashCode {
    return isRestaurant.hashCode ^
    approved.hashCode ^
    restaurantId.hashCode;
  }
}
