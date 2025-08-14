import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_media_entity.dart';

class UploadRequestEntity extends Equatable {
  final String uploadId;
  final String uploadUrl;
  final Map<String, String> uploadFields;
  final String fileKey;
  final DateTime expiresAt;

  const UploadRequestEntity({
    required this.uploadId,
    required this.uploadUrl,
    required this.uploadFields,
    required this.fileKey,
    required this.expiresAt,
  });

  @override
  List<Object?> get props => [
        uploadId,
        uploadUrl,
        uploadFields,
        fileKey,
        expiresAt,
      ];
}

class UploadConfirmEntity extends Equatable {
  final String mediaId;
  final String mediaUrl;
  final String? thumbnailUrl;
  final MediaStatus status;

  const UploadConfirmEntity({
    required this.mediaId,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.status,
  });

  @override
  List<Object?> get props => [
        mediaId,
        mediaUrl,
        thumbnailUrl,
        status,
      ];
}
