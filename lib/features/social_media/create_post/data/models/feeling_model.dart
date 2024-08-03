import 'package:fourtyninehub/features/social_media/create_post/domain/entities/feeling_entity.dart';

class FeelingModel extends FeelingEntity {
  FeelingModel({required super.id, required super.name, required super.image});
  factory FeelingModel.fromJson(Map<String, dynamic> json) {
    return FeelingModel(
      id: json['_id']??'',
      name: json['nameEn']??'',
      image: json['picture']??'',
    );
  }
}
