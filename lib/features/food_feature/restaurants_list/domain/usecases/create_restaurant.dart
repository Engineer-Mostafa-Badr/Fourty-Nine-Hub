import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../../../core/error/failure.dart';
import '../../data/models/restaurant_menu_model.dart';
import '../repositories/restaurant_list_repo.dart';

class CreateRestaurantUseCase {
  final RestaurantListRepo _restaurantRepo;
  CreateRestaurantUseCase(this._restaurantRepo);

  Future<Either<Failure, bool>> call(CreateRestaurantParams params) async {
    return _restaurantRepo.createRestaurant(params);
  }
}

class CreateRestaurantParams {
  String? name = '';
  String? number = '';
  String? subcategoryId = '';
  List<String>? restaurantMedia = [];
  List<String>? licenseMedia = [];
  String? government = "";
  String? city = "";
  String? deliveryTime = "";
  String? deliveryFee = "";
  String? countryCode = "";
  String? workTo = "";
  String? workFrom = "";
  String? expireOwnerIdMedia = "";
  String? ownerIdBackMedia = "";
  String? ownerIdFrontMedia = "";
  List<RestaurantMenuModel>? mneu;
  CreateRestaurantParams({
    this.number,
    this.name,
    this.subcategoryId,
    this.restaurantMedia,
    this.licenseMedia,
    this.government,
    this.city,
    this.deliveryTime,
    this.deliveryFee,
    this.countryCode,
    this.workTo,
    this.workFrom,
    this.expireOwnerIdMedia,
    this.ownerIdBackMedia,
    this.ownerIdFrontMedia,
    this.mneu,
  });

  CreateRestaurantParams copyWith({
    String? name,
    String? number,
    String? subcategoryId,
    List<String>? restaurantMedia,
    List<String>? licenseMedia,
    String? government,
    String? city,
    String? deliveryTime,
    String? deliveryFee,
    String? countryCode,
    String? workTo,
    String? workFrom,
    String? expireOwnerIdMedia,
    String? ownerIdBackMedia,
    String? ownerIdFrontMedia,
    List<RestaurantMenuModel>? mneu,
  }) {
    return CreateRestaurantParams(
      name: name ?? this.name,
      number: number ?? this.number,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      restaurantMedia: restaurantMedia ?? this.restaurantMedia,
      licenseMedia: licenseMedia ?? this.licenseMedia,
      government: government ?? this.government,
      city: city ?? this.city,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      countryCode: countryCode ?? this.countryCode,
      workTo: workTo ?? this.workTo,
      workFrom: workFrom ?? this.workFrom,
      expireOwnerIdMedia: expireOwnerIdMedia ?? this.expireOwnerIdMedia,
      ownerIdBackMedia: ownerIdBackMedia ?? this.ownerIdBackMedia,
      ownerIdFrontMedia: ownerIdFrontMedia ?? this.ownerIdFrontMedia,
      mneu: mneu ?? this.mneu,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (number != null) {
      result.addAll({'phone': number});
    }
    if (subcategoryId != null) {
      result.addAll({'subcategoryId': subcategoryId});
    }
    if (restaurantMedia != null) {
      result.addAll({'restaurantMedia': restaurantMedia});
    }
    if (licenseMedia != null) {
      result.addAll({'licenseMedia': licenseMedia});
    }
    if (government != null) {
      result.addAll({'government': government});
    }
    if (city != null) {
      result.addAll({'city': city});
    }
    if (deliveryTime != null) {
      result.addAll({'deliveryTime': deliveryTime});
    }
    if (deliveryFee != null) {
      result.addAll({'deliveryFee': deliveryFee});
    }
    if (countryCode != null) {
      result.addAll({'countryCode': countryCode});
    }
    if (workTo != null) {
      result.addAll({'workTo': workTo});
    }
    if (workFrom != null) {
      result.addAll({'workFrom': workFrom});
    }
    if (expireOwnerIdMedia != null) {
      result.addAll({'expireOwnerIdMedia': expireOwnerIdMedia});
    }
    if (ownerIdBackMedia != null) {
      result.addAll({'ownerIdBackMedia': ownerIdBackMedia});
    }
    if (ownerIdFrontMedia != null) {
      result.addAll({'ownerIdFrontMedia': ownerIdFrontMedia});
    }
    if (mneu != null) {
      result.addAll({'menu': mneu!.map((x) => x.toMap()).toList()});
    }

    return result;
  }

  factory CreateRestaurantParams.fromMap(Map<String, dynamic> map) {
    return CreateRestaurantParams(
      name: map['name'],
      number: map['phone'],
      subcategoryId: map['subcategoryId'],
      restaurantMedia: List<String>.from(map['restaurantMedia']),
      licenseMedia: List<String>.from(map['licenseMedia']),
      government: map['government'],
      city: map['city'],
      deliveryTime: map['deliveryTime'],
      deliveryFee: map['deliveryFee'],
      countryCode: map['countryCode'],
      workTo: map['workTo'],
      workFrom: map['workFrom'],
      expireOwnerIdMedia: map['expireOwnerIdMedia'],
      ownerIdBackMedia: map['ownerIdBackMedia'],
      ownerIdFrontMedia: map['ownerIdFrontMedia'],
      mneu: map['mneu'] != null
          ? List<RestaurantMenuModel>.from(
              map['mneu']?.map((x) => RestaurantMenuModel.fromJson(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateRestaurantParams.fromJson(String source) =>
      CreateRestaurantParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CreateRestaurantParams(name: $name,phone: $number, subcategoryId: $subcategoryId, restaurantMedia: $restaurantMedia, licenseMedia: $licenseMedia, government: $government, city: $city, deliveryTime: $deliveryTime, deliveryFee: $deliveryFee, countryCode: $countryCode, workTo: $workTo, workFrom: $workFrom, expireOwnerIdMedia: $expireOwnerIdMedia, ownerIdBackMedia: $ownerIdBackMedia, ownerIdFrontMedia: $ownerIdFrontMedia, mneu: $mneu)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateRestaurantParams &&
        other.name == name &&
        other.number == number &&
        other.subcategoryId == subcategoryId &&
        listEquals(other.restaurantMedia, restaurantMedia) &&
        listEquals(other.licenseMedia, licenseMedia) &&
        other.government == government &&
        other.city == city &&
        other.deliveryTime == deliveryTime &&
        other.deliveryFee == deliveryFee &&
        other.countryCode == countryCode &&
        other.workTo == workTo &&
        other.workFrom == workFrom &&
        other.expireOwnerIdMedia == expireOwnerIdMedia &&
        other.ownerIdBackMedia == ownerIdBackMedia &&
        other.ownerIdFrontMedia == ownerIdFrontMedia &&
        listEquals(other.mneu, mneu);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        number.hashCode ^
        subcategoryId.hashCode ^
        restaurantMedia.hashCode ^
        licenseMedia.hashCode ^
        government.hashCode ^
        city.hashCode ^
        deliveryTime.hashCode ^
        deliveryFee.hashCode ^
        countryCode.hashCode ^
        workTo.hashCode ^
        workFrom.hashCode ^
        expireOwnerIdMedia.hashCode ^
        ownerIdBackMedia.hashCode ^
        ownerIdFrontMedia.hashCode ^
        mneu.hashCode;
  }
}
