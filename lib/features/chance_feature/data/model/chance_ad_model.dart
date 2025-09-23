import '../../domain/entity/chance_ad_entity.dart';
import 'image_chance_model.dart';
import 'main_category_mpdel.dart';
import 'sup_category_model.dart';
import 'user_chance_model.dart';

class ChanceAdModel extends ChanceAdEntity {
  ChanceAdModel({
    required super.id,
    required super.winnerId,
    required super.images,
    required super.description,
    required super.title,
    required super.price,
    required super.isActive,
    required super.isRejected,
    required super.isBlocked,
    required super.isBanned,
    required super.subCategoryId,
    required super.mainCategoryId,
    required super.userId,
    required super.totalContributions,
    required super.contributors,
    required super.isComplete,
    required super.cycleWinner,
    required super.adPercentage,
    required super.views,
    required super.createdAt,
    required super.updatedAt,
    super.contributorsCount,
    super.isFavorite,
    super.userContribution,
  });

  factory ChanceAdModel.fromJson(Map<String, dynamic> json) {
    return ChanceAdModel(
      id: json['_id'] ?? '',
      winnerId: json['winnerId'],
      images: (json['images'] as List? ?? [])
          .map((image) => ImageChanceModel.fromJson(image))
          .toList(),
      description: json['description'] ?? '',
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isActive: json['isActive'] ?? false,
      isRejected: json['isRejected'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      isBanned: json['isBanned'] ?? false,
      subCategoryId: json['subCategoryId'] is Map<String, dynamic>
          ? SupCategoryModel.fromJson(json['subCategoryId'])
          : json['subCategoryId'] as String? ?? '',
      mainCategoryId: json['mainCategoryId'] is Map<String, dynamic>
          ? MainCategoryModel.fromJson(json['mainCategoryId'])
          : json['mainCategoryId'] as String? ?? '',
      userId: json['userId'] is Map<String, dynamic>
          ? UserChanceModel.fromJson(json['userId'])
          : json['userId'] as String? ?? '',
      totalContributions:
          (json['totalContributions'] as num?)?.toDouble() ?? 0.0,
      contributors: json['contributors'] ?? 0,
      isComplete: json['isComplete'] ?? false,
      cycleWinner: json['cycleWinner'] ?? 0,
      adPercentage: (json['adPercentage'] as num?)?.toDouble() ?? 0.0,
      views: json['views'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      contributorsCount: json['contributorsCount'],
      isFavorite: json['isFavorite'] ?? false,
      userContribution: (json['userContribution'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'winnerId': winnerId,
      'images': images.map((image) => (image as ImageChanceModel).toJson()).toList(),
      'description': description,
      'title': title,
      'price': price,
      'isActive': isActive,
      'isRejected': isRejected,
      'isBlocked': isBlocked,
      'isBanned': isBanned,
      'subCategoryId': subCategoryId,
      'mainCategoryId': mainCategoryId,
      'userId': userId,
      'totalContributions': totalContributions,
      'contributors': contributors,
      'isComplete': isComplete,
      'cycleWinner': cycleWinner,
      'adPercentage': adPercentage,
      'views': views,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      if (contributorsCount != null) 'contributorsCount': contributorsCount,
      'isFavorite': isFavorite,
      if (userContribution != null) 'userContribution': userContribution,
    };
  }
}
