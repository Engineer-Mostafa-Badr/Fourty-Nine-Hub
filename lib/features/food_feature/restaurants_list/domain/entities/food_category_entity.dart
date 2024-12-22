import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class FoodCategoryEntity extends Equatable {
  final String? name;
  final String? image;
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "parent")
  final Parent? parent;
  @JsonKey(name: "picture")
  final String? picture;
  @JsonKey(name: "nameAr")
  final String? nameAr;
  @JsonKey(name: "nameEn")
  final String? nameEn;
  @JsonKey(name: "numberOfRestaurant")
  final int? numberOfRestaurant;
  @JsonKey(name: "isFavorite")
  bool? isFavorite;
  bool? isSelected;
  bool? fromAsset;

  FoodCategoryEntity({
    this.id,
    this.name,
    this.image,
    this.isFavorite = false,
    this.isSelected = false,
    this.fromAsset = false,
    this.parent,
    this.picture,
    this.nameAr,
    this.nameEn,
    this.numberOfRestaurant,
  });
  @override
  List<Object?> get props => [
        id,
        name,
        image,
        parent,
        picture,
        nameAr,
        nameEn,
        numberOfRestaurant,
      ];
}

enum Parent {
  @JsonValue("62c8b57e9332225799fe3308")
  THE_62_C8_B57_E9332225799_FE3308
}
