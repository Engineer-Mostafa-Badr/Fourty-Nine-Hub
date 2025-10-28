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

// Updated IsRestaurantModel to include rejection/block/ban details
class IsRestaurantModel {
  final bool? isRestaurant;
  final String? status; // pending, approved, rejected, blocked, banned
  final String? restaurantId;
  final String? subCategoryId;
  final String? reason; // Reason for rejection/block/ban
  final String? bannedUntil; // Date when ban expires
  final int? banDurationDays; // Ban duration in days

  IsRestaurantModel({
    this.isRestaurant,
    this.status,
    this.restaurantId,
    this.subCategoryId,
    this.reason,
    this.bannedUntil,
    this.banDurationDays,
  });

  // Convert the model to a map
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (isRestaurant != null) {
      result.addAll({'isRestaurant': isRestaurant});
    }
    if (status != null) {
      result.addAll({'status': status});
    }
    if (restaurantId != null) {
      result.addAll({'restaurantId': restaurantId});
    }
    if (subCategoryId != null) {
      result.addAll({'subCategoryId': subCategoryId});
    }
    if (reason != null) {
      result.addAll({'reason': reason});
    }
    if (bannedUntil != null) {
      result.addAll({'bannedUntil': bannedUntil});
    }
    if (banDurationDays != null) {
      result.addAll({'banDurationDays': banDurationDays});
    }

    return result;
  }

  // Create the model from a map
  factory IsRestaurantModel.fromMap(Map<String, dynamic> map) {
    return IsRestaurantModel(
      isRestaurant: map['isRestaurant'],
      status: map['status'],
      restaurantId: map['restaurantId'],
      subCategoryId: map['subCategoryId'],
      reason: map['reason'],
      bannedUntil: map['bannedUntil'],
      banDurationDays: map['banDurationDays'],
    );
  }

  // Convert the model to JSON
  String toJson() => json.encode(toMap());

  // Create the model from JSON
  factory IsRestaurantModel.fromJson(String source) =>
      IsRestaurantModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IsRestaurantModel(isRestaurant: $isRestaurant, status: $status, restaurantId: $restaurantId, subCategoryId: $subCategoryId, reason: $reason, bannedUntil: $bannedUntil, banDurationDays: $banDurationDays)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IsRestaurantModel &&
        other.isRestaurant == isRestaurant &&
        other.status == status &&
        other.restaurantId == restaurantId &&
        other.subCategoryId == subCategoryId &&
        other.reason == reason &&
        other.bannedUntil == bannedUntil &&
        other.banDurationDays == banDurationDays;
  }

  @override
  int get hashCode {
    return isRestaurant.hashCode ^
        status.hashCode ^
        restaurantId.hashCode ^
        subCategoryId.hashCode ^
        reason.hashCode ^
        bannedUntil.hashCode ^
        banDurationDays.hashCode;
  }
}
