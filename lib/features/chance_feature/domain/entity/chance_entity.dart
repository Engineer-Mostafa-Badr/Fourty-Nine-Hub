import 'package:fourtyninehub/features/chance_feature/domain/entity/image_chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/user_chance_entity.dart';

class ChanceEntity {
  final String id;
  final List<ImageChanceEntity> images;
  final String description;
  final num price;
  final bool isActive;
  final bool isRejected;
  final bool isBlocked;
  final bool isBanned;
  final String subCategoryId;
  final String mainCategoryId;
  final String userId;
  final List<dynamic> cycles;
  final int totalContributions;
  final DateTime createdAt;
  final List<UserChanceEntity> user;

  ChanceEntity(
      {required this.id,
      required this.images,
      required this.description,
      required this.price,
      required this.isActive,
      required this.isRejected,
      required this.isBlocked,
      required this.isBanned,
      required this.subCategoryId,
      required this.mainCategoryId,
      required this.userId,
      required this.cycles,
      required this.totalContributions,
      required this.createdAt,
      required this.user});
}
