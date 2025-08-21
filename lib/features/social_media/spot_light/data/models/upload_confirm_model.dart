import 'package:fourtyninehub/features/social_media/spot_light/data/models/spotlight_media_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/upload_media_entity.dart';

class UploadConfirmModel extends UploadConfirmEntity {
  const UploadConfirmModel({
    required super.mediaId,
    required super.mediaUrl,
    super.thumbnailUrl,
    required super.status,
  });

  factory UploadConfirmModel.fromJson(Map<String, dynamic> json) {
    return UploadConfirmModel(
      mediaId: json['mediaId'] ?? '',
      mediaUrl: json['mediaUrl'] ?? '',
      thumbnailUrl: json['thumbnailUrl'],
      status: SpotlightMediaModel.parseMediaStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mediaId': mediaId,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'status': status.toString().split('.').last,
    };
  }
}
