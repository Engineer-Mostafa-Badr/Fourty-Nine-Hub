import 'package:fourtyninehub/features/social_media/tinder/data/models/get_fav_sub_category_model.dart';

class CategoryFavoritesResponse {
  final bool status;
  final List<CategoryFavoriteItem> data;

  CategoryFavoritesResponse({
    required this.status,
    required this.data,
  });

  factory CategoryFavoritesResponse.fromJson(Map<String, dynamic> json) {
    return CategoryFavoritesResponse(
      status: json['status'],
      data: List<CategoryFavoriteItem>.from(
        json['data']['favorites'].map((x) => CategoryFavoriteItem.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': {
        'favorites': List<dynamic>.from(data.map((x) => x.toJson())),
      },
    };
  }
}

class CategoryFavoriteItem {
  final String id;
  final String userId;
  final int numberOfAds;
  final FavoriteCategory categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryFavoriteItem({
    required this.id,
    required this.userId,
    required this.numberOfAds,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryFavoriteItem.fromJson(Map<String, dynamic> json) {
    print('Parsing CategoryFavoriteItem from JSON: $json');
    return CategoryFavoriteItem(
      id: json['_id'] ?? '',
      userId: json['user_id'] ?? '',
      numberOfAds: json['numberOfAds'] ?? 0,
      categoryId: FavoriteCategory.fromJson(json['category_id'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user_id': userId,
      'numberOfAds': numberOfAds,
      'category_id': categoryId.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class FavoriteCategory {
  final String id;
  final String? banner;
  final String? cover;
  final String? nameAr;
  final String? nameEn;

  FavoriteCategory({
    required this.id,
    this.banner,
    this.cover,
    this.nameAr,
    this.nameEn,
  });

  factory FavoriteCategory.fromJson(Map<String, dynamic> json) {
    return FavoriteCategory(
      id: json['_id'] ?? '',
      banner: json['banner'] as String?,
      cover: json['cover'] as String?,
      nameAr: json['nameAr'] as String?,
      nameEn: json['nameEn'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'banner': banner,
      'cover': cover,
      'nameAr': nameAr,
      'nameEn': nameEn,
    };
  }
}
