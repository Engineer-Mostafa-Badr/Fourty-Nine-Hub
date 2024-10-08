import 'package:fourtyninehub/features/chance_feature/data/model/image_chance_model.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/user_chance_model.dart';

import '../../domain/entity/chance_entity.dart';

class ChanceModel extends ChanceEntity {
  ChanceModel(
      {required super.id,
      required super.images,
      required super.description,
      required super.price,
      required super.isActive,
      required super.isRejected,
      required super.isBlocked,
      required super.isBanned,
      required super.subCategoryId,
      required super.mainCategoryId,
      required super.userId,
      required super.cycles,
      required super.totalContributions,
      required super.createdAt,
      required super.user});

  factory ChanceModel.fromJson(Map<String, dynamic> json) {
      return ChanceModel(
          id: json['_id'] ??'',
          images: (json['images'] as List)
              .map((image) => ImageChanceModel.fromJson(image))
              .toList(),
          description: json['description'] ??'',
          price: json['price'] ??0,
          isActive: json['isActive'] ??false,
          isRejected: json['isRejected'] ??false,
          isBlocked: json['isBlocked'] ??false,
          isBanned: json['isBanned'] ??false,
          subCategoryId: json['subCategoryId'] ??'',
          mainCategoryId: json['mainCategoryId'] ??'',
          userId: json['userId'] ??'',
          cycles: json['cycles'] ??[],
          totalContributions: json['totalContributions'] ??0,
          createdAt: DateTime.parse(json['createdAt'] ??''),
          user: UserChanceModel.fromJson(json['user']),
      );
  }
}
