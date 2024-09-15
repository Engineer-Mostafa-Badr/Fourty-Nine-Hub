import 'package:fourtyninehub/features/ads_feature/create_company_ad/domain/entities/media_entity.dart';

class MediaModel extends MediaEntity {
  MediaModel(
      {required super.sId,
      required super.user,
      required super.subcategoryId,
      required super.mediaKey,
      required super.successUpload,
      required super.createdAt,
      required super.photo});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
        sId: json['_id'] ?? '',
        user: json['user'] ?? '',
        subcategoryId: json['subcategoryId'] ?? '',
        mediaKey: json['mediaKey'] ?? '',
        successUpload: json['successUpload'] ?? false,
        createdAt: json['createdAt'] ?? '',
        photo: json['photo'] ?? '');
  }
}
