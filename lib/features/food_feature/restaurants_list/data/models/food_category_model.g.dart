// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodCategoryModel _$FoodCategoryModelFromJson(Map<String, dynamic> json) =>
    FoodCategoryModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      parent: $enumDecodeNullable(_$ParentEnumMap, json['parent']),
      picture: json['picture'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
      fromAsset: json['fromAsset'] as bool? ?? false,
      isSelected: json['isSelected'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      numberOfRestaurant: (json['numberOfRestaurant'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FoodCategoryModelToJson(FoodCategoryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      '_id': instance.id,
      'parent': _$ParentEnumMap[instance.parent],
      'picture': instance.picture,
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'numberOfRestaurant': instance.numberOfRestaurant,
      'isFavorite': instance.isFavorite,
      'isSelected': instance.isSelected,
      'fromAsset': instance.fromAsset,
    };

const _$ParentEnumMap = {
  Parent.THE_62_C8_B57_E9332225799_FE3308: '62c8b57e9332225799fe3308',
};
