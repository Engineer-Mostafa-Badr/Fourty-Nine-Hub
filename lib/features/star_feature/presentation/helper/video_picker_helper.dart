import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/bunny_video_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoPickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick video file from gallery or camera
  Future<File?> pickVideo({
    bool fromGallery = true,
    Duration? maxDuration,
  }) async {
    try {
      // Request permissions
      if (!await _requestPermissions()) {
        return null;
      }

      XFile? pickedFile;

      if (fromGallery) {
        // Pick from gallery
        pickedFile = await _imagePicker.pickVideo(
          source: ImageSource.gallery,
          maxDuration: maxDuration,
        );
      } else {
        // Pick from camera
        pickedFile = await _imagePicker.pickVideo(
          source: ImageSource.camera,
          maxDuration: maxDuration ?? const Duration(minutes: 5),
        );
      }

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      print('Error picking video: $e');
      return null;
    }
  }

  /// Pick multiple video files (gallery only)
  Future<List<File>> pickMultipleVideos() async {
    try {
      if (!await _requestPermissions()) {
        return [];
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      }

      return [];
    } catch (e) {
      print('Error picking multiple videos: $e');
      return [];
    }
  }

  /// Pick image file for thumbnail
  Future<File?> pickThumbnail({
    bool fromGallery = true,
    int imageQuality = 85,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      if (!await _requestPermissions()) {
        return null;
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }

      return null;
    } catch (e) {
      print('Error picking thumbnail: $e');
      return null;
    }
  }

  /// Pick both video and thumbnail together
  Future<VideoThumbnailPair?> pickVideoWithThumbnail({
    bool fromGallery = true,
    Duration? maxVideoDuration,
  }) async {
    try {
      // First pick video
      final video = await pickVideo(
        fromGallery: fromGallery,
        maxDuration: maxVideoDuration,
      );

      if (video == null) return null;

      // Then pick thumbnail
      final thumbnail = await pickThumbnail(fromGallery: true);

      if (thumbnail == null) {
        // If no thumbnail selected, we still return the video
        // The user can pick thumbnail separately
        return VideoThumbnailPair(video: video, thumbnail: null);
      }

      return VideoThumbnailPair(video: video, thumbnail: thumbnail);
    } catch (e) {
      print('Error picking video with thumbnail: $e');
      return null;
    }
  }

  /// Check and request necessary permissions
  Future<bool> _requestPermissions() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need specific permissions
      final status = await [
        Permission.camera,
        Permission.photos, // For Android 13+
        Permission.storage, // For older versions
      ].request();

      return status.values.any((permission) =>
          permission == PermissionStatus.granted ||
          permission == PermissionStatus.limited);
    } else if (Platform.isIOS) {
      // For iOS
      final status = await [
        Permission.camera,
        Permission.photos,
      ].request();

      return status.values.any((permission) =>
          permission == PermissionStatus.granted ||
          permission == PermissionStatus.limited);
    }

    return true; // For other platforms
  }

  /// Get video file info
  Future<VideoFileInfo?> getVideoInfo(File videoFile) async {
    try {
      final stats = await videoFile.stat();
      final sizeInBytes = stats.size;
      final sizeInMB = sizeInBytes / (1024 * 1024);

      return VideoFileInfo(
        file: videoFile,
        sizeInBytes: sizeInBytes,
        sizeInMB: sizeInMB,
        name: videoFile.path.split('/').last,
      );
    } catch (e) {
      print('Error getting video info: $e');
      return null;
    }
  }

  /// Validate video file
  bool isValidVideoFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    const validExtensions = ['mp4', 'mov', 'avi', 'mkv', '3gp', 'webm'];
    return validExtensions.contains(extension);
  }

  /// Validate image file
  bool isValidImageFile(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    const validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return validExtensions.contains(extension);
  }

  Future<int?> getVideoDuration(File videoFile) async {
    try {
      final controller = VideoPlayerController.file(videoFile);
      await controller.initialize();

      final duration = controller.value.duration.inSeconds;
      await controller.dispose();

      return duration;
    } catch (e) {
      print('Error getting video duration: $e');
      return null;
    }
  }
}

/// Data class to hold video and thumbnail pair
class VideoThumbnailPair {
  final File video;
  final File? thumbnail;

  VideoThumbnailPair({
    required this.video,
    this.thumbnail,
  });

  bool get hasThumbnail => thumbnail != null;
}

/// Data class for video file information
class VideoFileInfo {
  final File file;
  final int sizeInBytes;
  final double sizeInMB;
  final String name;
  final int? duration; // إضافة duration

  VideoFileInfo({
    required this.file,
    required this.sizeInBytes,
    required this.sizeInMB,
    required this.name,
    this.duration, // إضافة duration
  });

  String get formattedDuration {
    if (duration == null) return 'Unknown';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

// إضافة هذا إلى ملف video_picker_helper.dart

extension VideoValidation on VideoPickerHelper {
  // فحص الفيديو قبل الرفع
  Future<Map<String, dynamic>> validateVideoForUpload(File videoFile) async {
    final result = <String, dynamic>{
      'isValid': false,
      'errors': <String>[],
      'warnings': <String>[],
      'info': <String, dynamic>{},
    };

    try {
      // فحص حجم الملف
      final fileSizeInBytes = await videoFile.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      result['info']['sizeInBytes'] = fileSizeInBytes;
      result['info']['sizeInMB'] = fileSizeInMB.toStringAsFixed(2);

      // فحص امتداد الملف
      final extension = videoFile.path.split('.').last.toLowerCase();
      result['info']['extension'] = extension;

      // فحص نوع الملف
      const supportedFormats = ['mp4', 'mov', 'avi', 'mkv'];
      if (!supportedFormats.contains(extension)) {
        result['errors'].add('Unsupported video format: $extension');
      }

      // فحص حجم الملف (الحد الأقصى 500 ميجا)
      if (fileSizeInMB > 500) {
        result['errors'].add(
            'File too large: ${fileSizeInMB.toStringAsFixed(2)}MB (max 500MB)');
      } else if (fileSizeInMB > 100) {
        result['warnings'].add(
            'Large file: ${fileSizeInMB.toStringAsFixed(2)}MB - upload may take longer');
      }

      // فحص اسم الملف
      final fileName = videoFile.path.split('/').last;
      result['info']['fileName'] = fileName;

      if (fileName.contains(' ')) {
        result['warnings'].add('File name contains spaces - may cause issues');
      }

      // إذا لم توجد أخطاء، الملف صالح
      if ((result['errors'] as List).isEmpty) {
        result['isValid'] = true;
      }
    } catch (e) {
      result['errors'].add('Error validating file: $e');
    }

    return result;
  }

  // طباعة معلومات مفصلة عن الرفع
  void logUploadDetails(BunnyUploadDetails details) {
    print("🔍 === BUNNY UPLOAD DETAILS ===");
    print("📹 Video ID: ${details.videoId}");
    print("📚 Library ID: ${details.libraryId}");
    print("🔑 Signature: ${details.signature.substring(0, 20)}...");
    print("⏰ Expiration: ${details.expirationTime}");
    print("⏱️  Current Time: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}");
    print(
        "✅ Time Valid: ${details.expirationTime > DateTime.now().millisecondsSinceEpoch ~/ 1000}");
    print("================================");
  }
}
