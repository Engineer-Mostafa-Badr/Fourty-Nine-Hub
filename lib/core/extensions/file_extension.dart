import 'dart:io';
import 'dart:typed_data';

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

  /// generate jpeg thumbnail
  Future<Uint8List?> generateThumbnail() async {
    final thumbnailAsUint8List = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 320,
      // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
    return thumbnailAsUint8List!;
  }
}