import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/error/failure.dart';

import '../../common/functions/helper/file_picker_helper.dart';
import '../../core/data/datasources/remote/api/api_consumer.dart';
import '../../core/data/datasources/remote/api/end_points.dart';
import '../../service_locator/service_locator.dart';

class UploadImage {
  /// Pick an image and upload it to the server
  Future<Either<Failure, bool>?> uploadImage({
    bool isGallery = true,
    String? mediaUrl,
    bool? confirm = false,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    try {
      // Pick image from gallery or camera
      final XFile? file =
          await FilePickerHelper().pickImage(isGallery: isGallery);
      if (file == null) return null;

      final bytes = await file.readAsBytes();
      final size = bytes.length;

      // Request signed URL from backend
      final signedURLResponse = await serviceLocator<ApiConsumer>().post(
        mediaUrl ?? EndPoints.mediaUrl,
        data: {
          "type": "image/${file.mimeType ?? 'png'}",
          "size": size,
          "subcategoryId":
              "62c8bb908e28a58a3edf59bd", // replace with your subcategoryId
        },
      );

      // Upload image
      signedURLResponse.fold((failure) {
        print("Failed to get signed URL: $failure");
      }, (data) async {
        log("Signed URL Response: ${jsonEncode(data)}");

        final mediaId = data['data']['mediaId'];
        final signedUrl = data['data']['signedUrl'];

        // Upload binary data
        await sendBinaryFileData(file: file, signedUrl: signedUrl);

        // Optionally confirm upload
        await serviceLocator<ApiConsumer>().put(
          EndPoints.confirmUpload(mediaId),
        );

        // Call callback with mediaId and file
        onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
        return const Right(true);
      });
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
    return null;
  }

  /// Helper to send the actual image bytes
  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
    Uint8List imageBytes = await file.readAsBytes();

    final options = Options(
      contentType: file.mimeType ?? "image/png",
      headers: {
        'Accept': "*/*",
        'Content-Type': 'application/octet-stream',
        'Content-Length': imageBytes.length,
        'Connection': 'keep-alive',
        'User-Agent': 'YourAppName',
      },
    );

    await Dio().put(
      signedUrl,
      data: Stream.fromIterable(imageBytes.map((e) => [e])),
      options: options,
    );
  }
}

class UploadVideo {
  /// Pick a video and upload it to the server
  Future<Either<Failure, bool>?> uploadVideo({
    bool isGallery = true,
    String? mediaUrl,
    bool? confirm = false,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    try {
      // Pick video from gallery or camera
      final XFile? file =
          await FilePickerHelper().pickVideo(isGallery: isGallery);

      if (file == null) return null;

      final bytes = await file.readAsBytes();
      final size = bytes.length;

      // Request signed URL from backend
      final signedURLResponse = await serviceLocator<ApiConsumer>().post(
        mediaUrl ?? EndPoints.mediaUrl,
        data: {
          "type": "video/${file.mimeType ?? 'mp4'}",
          "size": size,
          "subcategoryId":
              "62c8bb908e28a58a3edf59bd" // replace with your subcategoryId
        },
      );

      // Upload video
      signedURLResponse.fold((failure) {
        print("Failed to get signed URL: $failure");
      }, (data) async {
        log("Signed URL Response: ${jsonEncode(data)}");

        final mediaId = data['data']['mediaId'];
        final signedUrl = data['data']['signedUrl'];

        // Upload binary data
        await sendBinaryFileData(file: file, signedUrl: signedUrl);

        // Optionally confirm upload
        await serviceLocator<ApiConsumer>().put(
          EndPoints.confirmUpload(mediaId),
        );

        // Call callback with mediaId and file
        onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
        return const Right(true);
      });
    } catch (e) {
      print("Error uploading video: $e");
      return null;
    }
    return null;
  }

  /// Helper to send the actual video bytes
  Future<void> sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
    Uint8List videoBytes = await file.readAsBytes();

    final options = Options(
      contentType: file.mimeType ?? "video/mp4",
      headers: {
        'Accept': "*/*",
        'Content-Type': 'application/octet-stream',
        'Content-Length': videoBytes.length,
        'Connection': 'keep-alive',
        'User-Agent': 'YourAppName',
      },
    );

    await Dio().put(
      signedUrl,
      data: Stream.fromIterable(videoBytes.map((e) => [e])),
      options: options,
    );
  }
}

class UploadFileEntity {
  final String mediaId;
  final XFile file;

  UploadFileEntity({required this.mediaId, required this.file});
}

class UploadMediaHelper {
  /// Upload image or video
  static Future<Either<Failure, bool>?> uploadMedia({
    required bool isImage, // true => image, false => video
    required Function(UploadFileEntity) onUploaded,
  }) async {
    try {
      final XFile? file = isImage
          ? await FilePickerHelper().pickImage(isGallery: true)
          : await FilePickerHelper().pickVideo(isGallery: true);

      if (file == null) return null;

      final bytes = await file.readAsBytes();
      final size = bytes.length;

      // Request signed URL
      final signedURLResponse = await serviceLocator<ApiConsumer>().post(
        EndPoints.mediaUrl,
        data: {
          "type":
              "${isImage ? 'image' : 'video'}/${file.mimeType ?? (isImage ? 'png' : 'mp4')}",
          "size": size,
          "subcategoryId": "62c8bb908e28a58a3edf59bd",
        },
      );

      signedURLResponse.fold((failure) {
        print("Failed to get signed URL: $failure");
      }, (data) async {
        final mediaId = data['data']['mediaId'];
        final signedUrl = data['data']['signedUrl'];

        await _sendBinaryFileData(file: file, signedUrl: signedUrl);

        // Confirm upload
        await serviceLocator<ApiConsumer>()
            .put(EndPoints.confirmUpload(mediaId));

        // Return via callback
        onUploaded(UploadFileEntity(mediaId: mediaId, file: file));
      });

      return const Right(true);
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  static Future<void> _sendBinaryFileData({
    required XFile file,
    required String signedUrl,
  }) async {
    Uint8List bytes = await file.readAsBytes();
    final options = Options(
      contentType: file.mimeType ?? "application/octet-stream",
      headers: {
        'Accept': "*/*",
        'Content-Type': 'application/octet-stream',
        'Content-Length': bytes.length,
        'Connection': 'keep-alive',
        'User-Agent': 'YourAppName',
      },
    );

    await Dio().put(
      signedUrl,
      data: Stream.fromIterable(bytes.map((e) => [e])),
      options: options,
    );
  }
}
