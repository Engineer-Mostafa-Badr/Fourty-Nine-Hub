import 'package:fourtyninehub/features/chance_feature/data/model/image_chance_model.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/main_category_mpdel.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/sup_category_model.dart';
import 'package:fourtyninehub/features/chance_feature/data/model/user_chance_model.dart';

import '../../domain/entity/chance_entity.dart';

class ChanceModel extends ChanceEntity {
  ChanceModel({
    required super.id,
    required super.images,
    required super.description,
    required super.price,
    required super.user,
    required super.subCategoryId,
    required super.mainCategoryId,
    required super.title,
  });

  factory ChanceModel.fromJson(Map<String, dynamic> json) {
    return ChanceModel(
      id: json['_id'] ?? '',
      images: (json['images'] as List)
          .map((image) => ImageChanceModel.fromJson(image))
          .toList(),
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      user: UserChanceModel.fromJson(
        json["user"],
      ),
      subCategoryId: SupCategoryModel.fromJson(json["subCategoryId"]),
      mainCategoryId: MainCategoryModel.fromJson(json["mainCategoryId"]),
      title: json['title'] ?? '',
    );
  }
}
