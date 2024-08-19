import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class Banner extends Equatable {
  @JsonKey(name: "_id")
  final String? id;
  @JsonKey(name: "banner")
  final String? banner;
  @JsonKey(name: "cover")
  final String? cover;
  @JsonKey(name: "nameAr")
  final String? nameAr;
  @JsonKey(name: "nameEn")
  final String? nameEn;
  @JsonKey(name: "isFavorite")
  final bool? isFavorite;
  @JsonKey(name: "numberOfAds")
  final int? numberOfAds;
  const Banner({
    this.id,
    this.banner,
    this.cover,
    this.nameAr,
    this.nameEn,
    this.isFavorite,
    this.numberOfAds,
  });
  @override
  List<Object?> get props => [
        id,
        banner,
        cover,
        nameAr,
        nameEn,
        isFavorite,
        numberOfAds,
      ];
}
