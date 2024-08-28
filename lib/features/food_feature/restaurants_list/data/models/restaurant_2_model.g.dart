// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_2_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant2Model _$Restaurant2ModelFromJson(Map<String, dynamic> json) =>
    Restaurant2Model(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      address: json['address'] as String?,
      countryCode: json['countryCode'] as String?,
      datumId: json['id'] as String?,
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
      deliveryTime: json['deliveryTime'] as String?,
      deliveryFee: (json['deliveryFee'] as num?)?.toInt(),
      menu: (json['MENU'] as List<dynamic>?)
          ?.map((e) => RestaurantMneuModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      numberOfReviews: (json['numberOfReviews'] as num?)?.toInt(),
      restaurantMedia: (json['restaurantMedia'] as List<dynamic>?)
          ?.map((e) => RestaurantMediaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRating: (json['totalRating'] as num?)?.toInt(),
      workFrom: json['workFrom'] as String?,
      workTo: json['workTo'] as String?,
    );

Map<String, dynamic> _$Restaurant2ModelToJson(Restaurant2Model instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'restaurantMedia': instance.restaurantMedia,
      'government': instance.government,
      'city': instance.city,
      'address': instance.address,
      'isActive': instance.isActive,
      'workFrom': instance.workFrom,
      'workTo': instance.workTo,
      'totalRating': instance.totalRating,
      'countryCode': instance.countryCode,
      'deliveryTime': instance.deliveryTime,
      'deliveryFee': instance.deliveryFee,
      'numberOfReviews': instance.numberOfReviews,
      'MENU': instance.menu,
      'id': instance.datumId,
      'subcategoryId': instance.subcategoryId,
      'mainCategoryId': instance.mainCategoryId,
    };
