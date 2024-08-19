// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
      id: json['_id'] as String?,
      banner: json['banner'] as String?,
      cover: json['cover'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      isFavorite: json['isFavorite'] as bool?,
      numberOfAds: (json['numberOfAds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'banner': instance.banner,
      'cover': instance.cover,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'isFavorite': instance.isFavorite,
      'numberOfAds': instance.numberOfAds,
    };
