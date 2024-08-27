import 'dart:io';
import 'dart:typed_data';

import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

enum FileType {
  video,
  image,
  unknown;
}

extension FileTypeChecker on File {
  FileType _getFileType() {
    final extension = path.split('.').last.toLowerCase();

    switch (extension) {
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'm4v':
      case '3gp':
        return FileType.video;

      case 'jpg':
      case 'jpeg':
      case 'png':
        return FileType.image;

      default:
        return FileType.unknown;
    }
  }

  FileType get fileType => _getFileType();

  bool get isPhoto => fileType == FileType.image;

  bool get isVideo => fileType == FileType.video;

  Future<Uint8List?> generateThumbnail({
    Map<String, String>? headers,
    String? thumbnailPath,
    ImageFormat imageFormat = ImageFormat.JPEG,
    int maxHeight = 0,
    int maxWidth = 0,
    int timeMs = 0,
    int quality = 10,
  }) async {
    try {
      final thumbnailData = await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: imageFormat,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        timeMs: timeMs,
        quality: quality,
      );
      return thumbnailData;
    } catch (e) {
      CliLogger.error("thumbnail generation error: $e");
      return null;
    }
  }
}
