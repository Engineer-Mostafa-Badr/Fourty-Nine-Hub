import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  ActivityModel({required super.id, required super.name, required super.image, required super.nameEn,super.mainId,super.mainActivity});
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'] ?? '',
      mainId: json['mainActivityId'] ?? '',
      name: json['nameAr'] ?? '',
      nameEn: json['nameEn'] ?? '',
      image: json['url'] ?? '',
      mainActivity:json['main']!=null? ActivityModel.fromJson(json['main']):null,
    );
  }
}
