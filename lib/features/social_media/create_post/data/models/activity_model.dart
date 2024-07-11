import 'package:fourtyninehub/features/social_media/create_post/domain/entities/activity_entity.dart';

class ActivityModel extends ActivityEntity {
  ActivityModel({required super.id, required super.name, required super.image});
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
