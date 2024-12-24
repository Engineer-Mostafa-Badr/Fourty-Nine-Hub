import 'package:fourtyninehub/features/chance_feature/domain/entity/image_chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_categry_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sup_category_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/user_chance_entity.dart';

class ChanceEntity {
  final String id;
  final List<ImageChanceEntity> images;
  final String description;
  final int price;
  final UserChanceEntity user;
  final SubCategoryEntity subCategoryId;
  final MainCategoryEntity mainCategoryId;
  final String title;

  ChanceEntity({
    required this.id,
    required this.images,
    required this.description,
    required this.price,
    required this.user,
    required this.subCategoryId,
    required this.mainCategoryId,
    required this.title,
  });
}
