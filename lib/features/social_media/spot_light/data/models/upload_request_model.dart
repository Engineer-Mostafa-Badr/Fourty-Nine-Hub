import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/upload_media_entity.dart';

class UploadRequestModel extends UploadRequestEntity {
  const UploadRequestModel({
    required super.uploadId,
    required super.uploadUrl,
    required super.uploadFields,
    required super.fileKey,
    required super.expiresAt,
  });

  factory UploadRequestModel.fromJson(Map<String, dynamic> json) {
    return UploadRequestModel(
      uploadId: json['uploadId'] ?? '',
      uploadUrl: json['uploadUrl'] ?? '',
      uploadFields: Map<String, String>.from(json['uploadFields'] ?? {}),
      fileKey: json['fileKey'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uploadId': uploadId,
      'uploadUrl': uploadUrl,
      'uploadFields': uploadFields,
      'fileKey': fileKey,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}