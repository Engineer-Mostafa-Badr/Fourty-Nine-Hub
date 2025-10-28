import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../core/data/datasources/remote/api/end_points.dart';

class BunnyUploadDetails {
  final String videoId;
  final String libraryId;
  final String signature;
  final int expirationTime;

  BunnyUploadDetails({
    required this.videoId,
    required this.libraryId,
    required this.signature,
    required this.expirationTime,
  });

  factory BunnyUploadDetails.fromJson(Map<String, dynamic> json) {
    return BunnyUploadDetails(
      videoId: json['videoId'] ?? '',
      libraryId: json['libraryId'] ?? '',
      signature: json['signature'] ?? '',
      expirationTime: json['expirationTime'] ?? 0,
    );
  }
}

class BunnyVideoResponse {
  final BunnyUploadDetails uploadVideoDetails;
  final String mediaId;

  BunnyVideoResponse({
    required this.uploadVideoDetails,
    required this.mediaId,
  });

  factory BunnyVideoResponse.fromJson(Map<String, dynamic> json) {
    return BunnyVideoResponse(
      uploadVideoDetails: BunnyUploadDetails.fromJson(json['uploadVideoDetails']),
      mediaId: json['mediaId'] ?? '',
    );
  }
}

class VideoUploadEntity {
  final String title;
  final String description;
  final String videoMediaId;
  final String thumbnailMediaId;
  final String category;
  final int duration;

  VideoUploadEntity({
    required this.title,
    required this.description,
    required this.videoMediaId,
    required this.thumbnailMediaId,
    required this.category,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'video': videoMediaId,
      'thumbnail': thumbnailMediaId,
      'category': category,
      'duration': duration,
    };
  }
}

class BunnyVideoUploader {
  static const String BUNNY_TUS_ENDPOINT = "https://video.bunnycdn.com/tusupload";
  String? lastVideoMediaId;
  String? lastThumbnailMediaId;

  String _base64UrlEncode(String text) {
    final bytes = utf8.encode(text);
    return base64Url.encode(bytes);
  }

  Future<Either<Failure, bool>> uploadVideoToBunny({
    required File videoFile,
    required BunnyUploadDetails uploadDetails,
    required Function(double) onProgress,
  }) async {
    try {
      print("🎬 Starting TUS upload to Bunny CDN");
      print("📁 File size: ${await videoFile.length()} bytes");
      print("🔑 Video ID: ${uploadDetails.videoId}");
      print("📚 Library ID: ${uploadDetails.libraryId}");
      print("⏰ Expiration: ${uploadDetails.expirationTime}");
      print("⏱️ Current Time: ${DateTime.now().millisecondsSinceEpoch ~/ 1000}");

      final dio = Dio();
      final fileBytes = await videoFile.readAsBytes();
      final fileName = videoFile.path.split('/').last;

      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      if (currentTime >= uploadDetails.expirationTime) {
        print("❌ Signature expired before upload");
        return Left(ServerFailure(message: 'Upload signature expired. Please try again.'));
      }

      final createResponse = await dio.post(
        BUNNY_TUS_ENDPOINT,
        options: Options(
          headers: {
            'AuthorizationSignature': uploadDetails.signature,
            'AuthorizationExpire': uploadDetails.expirationTime.toString(),
            'VideoId': uploadDetails.videoId,
            'LibraryId': uploadDetails.libraryId,
            'Tus-Resumable': '1.0.0',
            'Upload-Length': fileBytes.length.toString(),
            'Upload-Metadata': 'filename ${_base64UrlEncode(fileName)}',
            'Content-Type': 'application/offset+octet-stream',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print("📤 Create session response: ${createResponse.statusCode}");

      if (createResponse.statusCode != 201) {
        print("❌ Failed to create upload session: ${createResponse.statusCode}");
        print("Response: ${createResponse.data}");
        return await _directUploadMethod(
          videoFile: videoFile,
          uploadDetails: uploadDetails,
          onProgress: onProgress,
        );
      }

      var uploadUrl = createResponse.headers.value('location');
      if (uploadUrl == null || uploadUrl.isEmpty) {
        print("❌ No upload URL received");
        return await _directUploadMethod(
          videoFile: videoFile,
          uploadDetails: uploadDetails,
          onProgress: onProgress,
        );
      }

      if (!uploadUrl.startsWith('http')) {
        uploadUrl = 'https://video.bunnycdn.com$uploadUrl';
        print("🔧 Fixed relative URL to: $uploadUrl");
      }

      print("🔗 Upload URL: $uploadUrl");

      final uploadResponse = await dio.patch(
        uploadUrl,
        data: fileBytes,
        onSendProgress: (sent, total) {
          if (total != -1) {
            final progress = sent / total;
            print("📊 Video upload progress: ${(progress * 100).toInt()}%");
            onProgress(progress);
          }
        },
        options: Options(
          headers: {
            'Tus-Resumable': '1.0.0',
            'Upload-Offset': '0',
            'Content-Type': 'application/offset+octet-stream',
            'Content-Length': fileBytes.length.toString(),
            'AuthorizationSignature': uploadDetails.signature,
            'AuthorizationExpire': uploadDetails.expirationTime.toString(),
            'VideoId': uploadDetails.videoId,
            'LibraryId': uploadDetails.libraryId,
          },
          validateStatus: (status) => status != null && status < 500,
          sendTimeout: const Duration(minutes: 30),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      print("📤 Upload response: ${uploadResponse.statusCode}");
      print("📋 Response headers: ${uploadResponse.headers}");

      if (uploadResponse.statusCode == 204 ||
          uploadResponse.statusCode == 200 ||
          uploadResponse.statusCode == 201) {
        print("✅ Video uploaded successfully to Bunny CDN");
        return const Right(true);
      } else {
        print("❌ Upload failed: ${uploadResponse.statusCode}");
        print("Response: ${uploadResponse.data}");
        return await _directUploadMethod(
          videoFile: videoFile,
          uploadDetails: uploadDetails,
          onProgress: onProgress,
        );
      }
    } catch (e) {
      print("❌ Exception during upload: $e");
      if (e is DioException) {
        print("Dio Error Type: ${e.type}");
        print("Response: ${e.response?.data}");
        print("Status Code: ${e.response?.statusCode}");
        if (e.message?.contains('No host specified') ?? false || e.response?.statusCode == 401) {
          return await _directUploadMethod(
            videoFile: videoFile,
            uploadDetails: uploadDetails,
            onProgress: onProgress,
          );
        }
      }
      return Left(UnknownFailure('Video upload failed: ${e.toString()}'));
    }
  }

  Future<Either<Failure, bool>> _directUploadMethod({
    required File videoFile,
    required BunnyUploadDetails uploadDetails,
    required Function(double) onProgress,
  }) async {
    try {
      print("🔄 Trying alternative upload method using multipart");

      final dio = Dio();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          videoFile.path,
          filename: videoFile.path.split('/').last,
        ),
      });

      final uploadUrl =
          'https://video.bunnycdn.com/library/${uploadDetails.libraryId}/videos/${uploadDetails.videoId}';

      final response = await dio.post(
        uploadUrl,
        data: formData,
        onSendProgress: (sent, total) {
          if (total != -1) {
            final progress = sent / total;
            print("📊 Alternative upload progress: ${(progress * 100).toInt()}%");
            onProgress(progress);
          }
        },
        options: Options(
          headers: {
            'AccessKey': uploadDetails.signature,
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
          sendTimeout: const Duration(minutes: 30),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      print("📤 Alternative upload response: ${response.statusCode}");

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        print("✅ Alternative upload successful");
        return const Right(true);
      } else {
        print("❌ Alternative upload failed: ${response.statusCode}");
        print("Response: ${response.data}");
        return await _binaryUploadMethod(
          videoFile: videoFile,
          uploadDetails: uploadDetails,
          onProgress: onProgress,
        );
      }
    } catch (e) {
      print("❌ Alternative upload exception: $e");
      return await _binaryUploadMethod(
        videoFile: videoFile,
        uploadDetails: uploadDetails,
        onProgress: onProgress,
      );
    }
  }

  Future<Either<Failure, bool>> _binaryUploadMethod({
    required File videoFile,
    required BunnyUploadDetails uploadDetails,
    required Function(double) onProgress,
  }) async {
    try {
      print("🔄 Trying binary upload method");

      final dio = Dio();
      final fileBytes = await videoFile.readAsBytes();
      final uploadUrl =
          'https://video.bunnycdn.com/library/${uploadDetails.libraryId}/videos/${uploadDetails.videoId}';

      final response = await dio.put(
        uploadUrl,
        data: Stream.fromIterable(fileBytes.map((e) => [e])),
        onSendProgress: (sent, total) {
          if (total != -1) {
            final progress = sent / total;
            final progressPercent = (progress * 100).toInt();
            if (progressPercent % 1 == 0) {
              print("📊 Video upload progress: $progressPercent%");
              onProgress(progress);
            }
          }
        },
        options: Options(
          headers: {
            'AccessKey': uploadDetails.signature,
            'Content-Type': 'video/mp4',
            'Content-Length': fileBytes.length.toString(),
          },
          validateStatus: (status) => status != null && status < 500,
          sendTimeout: const Duration(minutes: 30),
          receiveTimeout: const Duration(minutes: 5),
        ),
      );

      print("📤 Binary upload response: ${response.statusCode}");

      if (response.statusCode == 200 ||
          response.statusCode == 204 ||
          response.statusCode == 201) {
        print("✅ Binary upload successful");
        return const Right(true);
      } else {
        print("❌ Binary upload failed: ${response.statusCode}");
        return Left(ServerFailure(
          message: 'All upload methods failed. Please try again later.',
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      print("❌ Binary upload exception: $e");
      return Left(UnknownFailure('All upload attempts failed: ${e.toString()}'));
    }
  }

  Future<Either<Failure, bool>> uploadCompleteVideo({
    required BuildContext context,
    required String title,
    required String description,
    required File videoFile,
    required File thumbnailFile,
    required String subCategoryId,
    required String categoryId,
    required int videoDuration,
    Function(String)? onStatusUpdate,
    Function(double)? onProgress,
  }) async {
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount < maxRetries) {
      try {
        print("🔥 Starting complete video upload (attempt ${retryCount + 1})");

        onStatusUpdate?.call(
            context.isArabic ? 'إنشاء فيديو...' : 'Creating video entry...');
        final bunnyResponse = await createBunnyVideo(title: title);

        if (bunnyResponse.isLeft()) {
          print("❌ Failed to create Bunny video entry");
          return bunnyResponse.fold((l) => Left(l), (r) => const Right(false));
        }

        final bunnyData = bunnyResponse.getOrElse(() => throw Exception());
        lastVideoMediaId = bunnyData.mediaId;
        print("✅ Bunny video entry created: ${bunnyData.mediaId}");

        onStatusUpdate?.call(
            context.isArabic ? 'رفع الصورة المصغرة...' : 'Uploading thumbnail...');
        String? thumbnailMediaId;

        final uploadFile = UploadFile();
        await uploadFile.uploadImageSilent(
          subCategoryId: subCategoryId,
          context: context,
          file: thumbnailFile,
          onUploaded: (uploadEntity) {
            thumbnailMediaId = uploadEntity.mediaId;
            lastThumbnailMediaId = uploadEntity.mediaId;
            print("✅ Thumbnail uploaded: $thumbnailMediaId");
          },
        );

        if (thumbnailMediaId == null) {
          print("❌ Thumbnail upload failed");
          if (retryCount < maxRetries - 1) {
            retryCount++;
            await Future.delayed(const Duration(seconds: 2));
            continue;
          }
          return Left(UnknownFailure('Failed to upload thumbnail after retries'));
        }

        onStatusUpdate?.call(context.isArabic
            ? 'رفع الفيديو إلى Bunny CDN...'
            : 'Uploading video to Bunny CDN...');
        final videoUploadResult = await uploadVideoWithTokenRefresh(
          videoFile: videoFile,
          initialUploadDetails: bunnyData.uploadVideoDetails,
          title: title,
          onProgress: onProgress ?? (double progress) {},
          onStatusUpdate: onStatusUpdate ?? (String status) {},
          context: context,
        );

        if (videoUploadResult.isRight()) {
          onStatusUpdate?.call(
              context.isArabic ? 'إنهاء الرفع...' : 'Finalizing upload...');
          print("✅ Video upload completed successfully");
          return const Right(true);
        } else {
          print("❌ Video upload failed");
          if (retryCount < maxRetries - 1) {
            retryCount++;
            onStatusUpdate?.call(context.isArabic
                ? 'فشل الرفع، جاري إعادة المحاولة...'
                : 'Upload failed, retrying...');
            await Future.delayed(const Duration(seconds: 3));
            continue;
          } else {
            return videoUploadResult;
          }
        }
      } catch (e) {
        print("❌ Upload attempt ${retryCount + 1} failed: $e");
        if (retryCount < maxRetries - 1) {
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          continue;
        } else {
          return Left(
              UnknownFailure('Upload failed after $maxRetries attempts: ${e.toString()}'));
        }
      }
    }

    return Left(UnknownFailure('Upload failed after maximum retries'));
  }

  Future<Either<Failure, BunnyVideoResponse>> createBunnyVideo({
    required String title,
  }) async {
    try {
      print("📤 Creating Bunny video entry with title: $title");
      final response = await serviceLocator<ApiConsumer>().post(
        '/bunny/videos',
        data: {'title': title},
      );

      return response.fold(
            (failure) {
          print("❌ Failed to create Bunny video: $failure");
          return Left(failure);
        },
            (data) {
          final bunnyResponse = BunnyVideoResponse.fromJson(data['data']);
          print("✅ Bunny video created: ${bunnyResponse.mediaId}");
          return Right(bunnyResponse);
        },
      );
    } catch (e) {
      print("❌ Exception in createBunnyVideo: $e");
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, bool>> uploadVideoWithTokenRefresh({
    required File videoFile,
    required BunnyUploadDetails initialUploadDetails,
    required String title,
    required Function(double) onProgress,
    required Function(String) onStatusUpdate,
    required BuildContext context,
  }) async {
    BunnyUploadDetails currentDetails = initialUploadDetails;

    try {
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final timeUntilExpiry = currentDetails.expirationTime - currentTime;
      print("⏰ Time until token expiry: ${timeUntilExpiry}s");

      if (timeUntilExpiry < 300) {
        onStatusUpdate(context.isArabic
            ? 'تجديد توقيع الرفع...'
            : 'Refreshing upload token...');
        print("🔄 Refreshing upload token...");
        final refreshedDetails = await UploadTokenManager.refreshUploadToken(
          videoId: currentDetails.videoId,
          title: title,
        );

        if (refreshedDetails != null) {
          currentDetails = refreshedDetails;
          print("✅ Using refreshed token");
        } else {
          print("⚠️ Failed to refresh token, continuing with current one");
        }
      }

      return await uploadVideoToBunny(
        videoFile: videoFile,
        uploadDetails: currentDetails,
        onProgress: onProgress,
      );
    } catch (e) {
      print("❌ Upload with token refresh failed: iniciando");
      return Left(UnknownFailure(e.toString()));
    }
  }
}

class UploadTokenManager {
  static Future<BunnyUploadDetails?> refreshUploadToken({
    required String videoId,
    required String title,
  }) async {
    try {
      print("🔄 Refreshing upload token...");
      final response = await serviceLocator<ApiConsumer>().post(
        '/bunny/videos/refresh-token',
        data: {
          'videoId': videoId,
          'title': title,
        },
      );

      return response.fold(
            (failure) {
          print("❌ Failed to refresh token: $failure");
          return null;
        },
            (data) {
          print("✅ Token refreshed successfully");
          return BunnyUploadDetails.fromJson(data['data']['uploadVideoDetails']);
        },
      );
    } catch (e) {
      print("❌ Token refresh exception: $e");
      return null;
    }
  }
}

extension UploadFileExtension on UploadFile {
  Future<void> uploadImageSilent({
    required String subCategoryId,
    required BuildContext context,
    required File file,
    required Function(UploadFileEntity) onUploaded,
  }) async {
    try {
      print("📤 Starting silent image upload");
      final finalFile = XFile(file.path);
      final bytes = await finalFile.readAsBytes();
      final size = bytes.length;
      print("📊 Image size: $size bytes");

      final signedURLResponse = await serviceLocator<ApiConsumer>().post(
        EndPoints.mediaUrl,
        data: {
          "type": "image/${finalFile.mimeType ?? 'png'}",
          "size": size,
          "subcategoryId": subCategoryId,
        },
      );

      await signedURLResponse.fold(
            (failure) async {
          print("❌ Failed to get signed URL: $failure");
          throw failure;
        },
            (data) async {
          print("✅ Got signed URL");
          await sendBinaryFileData(
            file: finalFile,
            signedUrl: data['data']['signedUrl'],
          ).then((value) async {
            print("✅ Binary data sent");
            final mediaId = data['data']['mediaId'];
            final confirmUploadResponse = await serviceLocator<ApiConsumer>()
                .put(EndPoints.confirmUpload(mediaId));

            confirmUploadResponse.fold(
                  (failure) {
                print("❌ Failed to confirm upload: $failure");
                throw failure;
              },
                  (data) {
                print("✅ Upload confirmed, mediaId: $mediaId");
                onUploaded(UploadFileEntity(mediaId: mediaId, file: finalFile));
              },
            );
          });
        },
      );
    } catch (e) {
      print("❌ Silent upload failed: $e");
      throw UnknownFailure(e.toString());
    }
  }
}