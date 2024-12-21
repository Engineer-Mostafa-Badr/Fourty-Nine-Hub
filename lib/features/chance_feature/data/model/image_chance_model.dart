import 'package:fourtyninehub/features/chance_feature/domain/entity/image_chance_entity.dart';

class ImageChanceModel extends ImageChanceEntity {
  ImageChanceModel(
      {required super.id,
      required super.user,
      required super.subcategoryId,
      required super.photo});

  factory ImageChanceModel.fromJson(Map<String, dynamic> json) {
    return ImageChanceModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      subcategoryId: json['subcategoryId'] ?? '',
      photo: json['photo'] ?? '',
    );
  }
}
