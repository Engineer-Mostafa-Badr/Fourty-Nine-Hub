import 'dart:convert';

// Model for the main response
class RestaurantResponseModel {
  final bool? status;
  final IsRestaurantModel? data;

  RestaurantResponseModel({
    this.status,
    this.data,
  });

  // Convert the model to a map
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'data': data?.toMap(),
    };
  }

  // Create the model from a map
  factory RestaurantResponseModel.fromMap(Map<String, dynamic> map) {
    return RestaurantResponseModel(
      status: map['status'],
      data: map['data'] != null ? IsRestaurantModel.fromMap(map['data']) : null,
    );
  }

  // Convert the model to JSON
  String toJson() => json.encode(toMap());

  // Create the model from JSON
  factory RestaurantResponseModel.fromJson(String source) =>
      RestaurantResponseModel.fromMap(json.decode(source));
}

// Updated IsRestaurantModel to include isActive
class IsRestaurantModel {
  final bool? isRestaurant;
  final bool? approved;
  final String? restaurantId;
  final bool? isActive; // New field

  IsRestaurantModel({
    this.isRestaurant,
    this.approved,
    this.restaurantId,
    this.isActive, // Include in constructor
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
    if (isActive != null) { // Add isActive to the map
      result.addAll({'isActive': isActive});
    }

    return result;
  }

  // Create the model from a map
  factory IsRestaurantModel.fromMap(Map<String, dynamic> map) {
    return IsRestaurantModel(
      isRestaurant: map['isRestaurant'],
      approved: map['Approved'],
      restaurantId: map['restaurantId'],
      isActive: map['isActive'], // Parse isActive
    );
  }

  // Convert the model to JSON
  String toJson() => json.encode(toMap());

  // Create the model from JSON
  factory IsRestaurantModel.fromJson(String source) =>
      IsRestaurantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IsRestaurantModel(isRestaurant: $isRestaurant, Approved: $approved, restaurantId: $restaurantId, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsRestaurantModel &&
        other.isRestaurant == isRestaurant &&
        other.approved == approved &&
        other.restaurantId == restaurantId &&
        other.isActive == isActive; // Check isActive
  }

  @override
  int get hashCode {
    return isRestaurant.hashCode ^
    approved.hashCode ^
    restaurantId.hashCode ^
    isActive.hashCode; // Include isActive in hashCode
  }
}
