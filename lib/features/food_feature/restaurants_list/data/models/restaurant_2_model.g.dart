// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_2_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant2Model _$Restaurant2ModelFromJson(Map<String, dynamic> json) =>
    Restaurant2Model(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      number: json['phone'] as String?,
      subscriptionType: json['subscriptionType'] as String?,
      city: json['city'] == null
          ? null
          : CityModel.fromJson(json['city'] as Map<String, dynamic>),
      mainCategoryId: json['mainCategoryId'] == null
          ? null
          : FoodCategoryModel.fromJson(
              json['mainCategoryId'] as Map<String, dynamic>),
      subcategoryId: json['subcategoryId'] == null
          ? null
          : SubCategoryModel.fromJson(
              json['subcategoryId'] as Map<String, dynamic>),
      government: json['government'] == null
          ? null
          : GovernmentModel.fromJson(
              json['government'] as Map<String, dynamic>),
      isActive: json['isActive'] as bool?,
      menu: (json['MENU'] as List<dynamic>?)
          ?.map((e) => RestaurantMneuModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfReviews: (json['numberOfReviews'] as num?)?.toInt(),
      restaurantMedia: (json['restaurantMedia'] as List<dynamic>?)
          ?.map((e) => RestaurantMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRating: (json['totalRating'] as num?)?.toDouble(),
      description: json['description'] as String?,
      isFavorite: json['isFavorite'] as bool?,
      enableOrDisableChat: json['enableOrDisableChat'].toString(),
    );

Map<String, dynamic> _$Restaurant2ModelToJson(Restaurant2Model instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'phone': instance.number,
      'restaurantMedia':
          instance.restaurantMedia?.map((e) => e.toJson()).toList(),
      'government': instance.government?.toJson(),
      'city': instance.city?.toJson(),
      'isActive': instance.isActive,
      'subscriptionType': instance.subscriptionType,
      'totalRating': instance.totalRating,
      'numberOfReviews': instance.numberOfReviews,
      'MENU': instance.menu?.map((e) => e.toJson()).toList(),
      'subcategoryId': instance.subcategoryId?.toJson(),
      'mainCategoryId': instance.mainCategoryId?.toJson(),
      'isFavorite': instance.isFavorite,
      'enableOrDisableChat': instance.enableOrDisableChat,
      'description': instance.description,
    };
