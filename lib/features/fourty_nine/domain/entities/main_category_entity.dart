import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/api/end_points.dart';

import '../../../subcategories/domain/entities/sub_category_entity.dart';

class MainCategoryEntity extends Equatable {
  final String id;
  final String name;
  final String image;
  final List<SubCategoryEntity>? subcategories;
  @protected
  final String? banner;
  @protected
  final String? cover;
  final bool isFavorite;
  final int total;

  const MainCategoryEntity({
    required this.id,
    required this.name,
    required this.image,
    this.subcategories,
    this.banner,
    this.cover,
    required this.isFavorite,
    required this.total,
  });

  String? get bannerUrl =>
      banner == null ? null : '${EndPoints.storageBaseUrl}$banner';
  String? get coverUrl =>
      cover == null ? null : '${EndPoints.storageBaseUrl}$cover';

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        banner,
        cover,
        isFavorite,
        total,
      ];
}
