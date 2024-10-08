import 'package:fourtyninehub/features/chance_feature/domain/entity/image_chance_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/user_chance_entity.dart';

class ChanceEntity {
  final String id;
  final List<ImageChanceEntity> images;
  final String description;
  final int price;
  final UserChanceEntity user;

  ChanceEntity(
      {required this.id,
      required this.images,
      required this.description,
      required this.price,
      required this.user,
      });
}
