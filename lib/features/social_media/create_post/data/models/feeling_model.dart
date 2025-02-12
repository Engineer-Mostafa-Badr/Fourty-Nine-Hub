import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';

class FeelingModel extends FeelingEntity {
  FeelingModel({required super.id, required super.name, required super.nameEn, required super.image});
  factory FeelingModel.fromJson(Map<String, dynamic> json) {
    return FeelingModel(
      id: json['_id'] ?? '',
      name: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      image: json['url'] ?? '',
    );
  }
}
