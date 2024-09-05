import 'package:fourtyninehub/features/account_taps/account/data/models/favouite_category_model/category_id.dart';

import '../../../../fourty_nine/data/models/main_category_model.dart';
import '../../domain/entities/favourite_category_entity.dart';

class FavouriteCategoryModel extends FavouriteCategoryEntity {
  FavouriteCategoryModel({
    required super.id,
    required super.numberOfAds,
    required super.updatedAt,
    required super.createdAt,
    required super.userId,
    required super.categoryId,
  });

  factory FavouriteCategoryModel.fromJson(Map<String, dynamic> json) {
    return FavouriteCategoryModel(
      id: json['id'] as String?,
      categoryId: json['category_id'] == null
          ? null
          : CategoryId.fromJson(json['category_id'] as Map<String, dynamic>),
      userId: json['user_id'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      numberOfAds: json['numberOfAds'] as int?,
    );
  }
}
