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
  });
}