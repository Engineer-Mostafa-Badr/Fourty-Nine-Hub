// // GENERATED CODE - DO NOT MODIFY BY HAND
//
// part of 'restaurant_mneu_model.dart';
//
// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************
//
// RestaurantMneuModel _$RestaurantMneuModelFromJson(Map<String, dynamic> json) =>
//     RestaurantMneuModel(
//       id: json['_id'] as String?,
//       restaurantId: json['restaurantId'] as String?,
//       foodName: json['foodName'] as String?,
//       price: (json['price'] as num?)?.toInt(),
//       picture: json['picture'] == null
//           ? null
//           : RestaurantMediaModel.fromJson(
//               json['picture'] as Map<String, dynamic>),
//       menuId: json['id'] as String?,
//     );
//
// Map<String, dynamic> _$RestaurantMneuModelToJson(
//         RestaurantMneuModel instance) =>
//     <String, dynamic>{
//       '_id': instance.id,
//       'restaurantId': instance.restaurantId,
//       'foodName': instance.foodName,
//       'price': instance.price,
//       'picture': instance.picture,
//       'id': instance.menuId,
//     };
