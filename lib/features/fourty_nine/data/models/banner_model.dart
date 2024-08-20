import 'package:fourtyninehub/features/fourty_nine/domain/entities/banner.dart';
import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel extends Banner {
  const BannerModel({
    super.id,
    super.banner,
    super.cover,
    super.nameAr,
    super.nameEn,
    super.isFavorite,
    super.numberOfAds,
  });
  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);

  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
