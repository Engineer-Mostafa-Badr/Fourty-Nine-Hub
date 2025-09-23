import 'image_chance_entity.dart';

class ChanceAdEntity {
  final String id;
  final dynamic winnerId;
  final List<ImageChanceEntity> images;
  final String description;
  final String title;
  final double price;
  final bool isActive;
  final bool isRejected;
  final bool isBlocked;
  final bool isBanned;
  final dynamic subCategoryId;
  final dynamic mainCategoryId;
  final dynamic userId;
  final double totalContributions;
  final int contributors;
  final bool isComplete;
  final int cycleWinner;
  final double adPercentage;
  final int views;
  final String createdAt;
  final String updatedAt;
  final int? contributorsCount;
  final bool isFavorite;
  final double? userContribution;

  ChanceAdEntity({
    required this.id,
    required this.winnerId,
    required this.images,
    required this.description,
    required this.title,
    required this.price,
    required this.isActive,
    required this.isRejected,
    required this.isBlocked,
    required this.isBanned,
    required this.subCategoryId,
    required this.mainCategoryId,
    required this.userId,
    required this.totalContributions,
    required this.contributors,
    required this.isComplete,
    required this.cycleWinner,
    required this.adPercentage,
    required this.views,
    required this.createdAt,
    required this.updatedAt,
    this.contributorsCount,
    this.isFavorite = false,
    this.userContribution,
  });

  ChanceAdEntity copyWith({
    String? id,
    dynamic winnerId,
    List<ImageChanceEntity>? images,
    String? description,
    String? title,
    double? price,
    bool? isActive,
    bool? isRejected,
    bool? isBlocked,
    bool? isBanned,
    dynamic subCategoryId,
    dynamic mainCategoryId,
    dynamic userId,
    double? totalContributions,
    int? contributors,
    bool? isComplete,
    int? cycleWinner,
    double? adPercentage,
    int? views,
    String? createdAt,
    String? updatedAt,
    int? contributorsCount,
    bool? isFavorite,
    double? userContribution,
  }) {
    return ChanceAdEntity(
      id: id ?? this.id,
      winnerId: winnerId ?? this.winnerId,
      images: images ?? this.images,
      description: description ?? this.description,
      title: title ?? this.title,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
      isRejected: isRejected ?? this.isRejected,
      isBlocked: isBlocked ?? this.isBlocked,
      isBanned: isBanned ?? this.isBanned,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      mainCategoryId: mainCategoryId ?? this.mainCategoryId,
      userId: userId ?? this.userId,
      totalContributions: totalContributions ?? this.totalContributions,
      contributors: contributors ?? this.contributors,
      isComplete: isComplete ?? this.isComplete,
      cycleWinner: cycleWinner ?? this.cycleWinner,
      adPercentage: adPercentage ?? this.adPercentage,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contributorsCount: contributorsCount ?? this.contributorsCount,
      isFavorite: isFavorite ?? this.isFavorite,
      userContribution: userContribution ?? this.userContribution,
    );
  }
}