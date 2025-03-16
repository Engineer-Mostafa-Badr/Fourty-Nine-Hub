import '../../../domain/entities/dashboards/user_entity.dart';

class ProfilePictureKeyModel extends ProfilePictureKeyEntity {
  const ProfilePictureKeyModel({required super.id, required super.mediaKey});

  factory ProfilePictureKeyModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureKeyModel(
      id: json['_id'],
      mediaKey: json['mediaKey'],
    );
  }
}
