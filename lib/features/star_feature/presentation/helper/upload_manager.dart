import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../../common/functions/global/upload_file.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';
import 'video_picker_helper.dart';
import 'bunny_video_uploader.dart';

class UploadManager {
  final BunnyVideoUploader _bunnyUploader = BunnyVideoUploader();
  final VideoPickerHelper _videoHelper = VideoPickerHelper();

  // Upload progress tracking
  UploadStage _currentStage = UploadStage.validating;
  double _overallProgress = 0.0;
  String _statusMessage = '';

  // Callbacks
  Function(UploadStage stage)? onStageChanged;
  Function(double progress)? onProgressChanged;
  Function(String message)? onStatusChanged;

  UploadManager({
    this.onStageChanged,
    this.onProgressChanged,
    this.onStatusChanged,
  });

  Future<Either<Failure, bool>> uploadCompleteVideo({
    required BuildContext context,
    required String title,
    required String description,
    required File videoFile,
    required File thumbnailFile,
    required String subCategoryId,
  }) async {
    int retryCount = 0;

    while (retryCount < StarConstants.maxRetries) {
      try {
        // Stage 1: Validate video
        _updateStage(UploadStage.validating, 'Validating video file...');
        final validationResult =
            await _videoHelper.validateVideoForUpload(videoFile);

        if (!(validationResult['isValid'] as bool)) {
          final errors = validationResult['errors'] as List<String>;
          return Left(
              UnknownFailure('Video validation failed: ${errors.join(', ')}'));
        }

        // Stage 2: Get video duration
        final duration = await _videoHelper.getVideoDuration(videoFile);
        if (duration == null) {
          if (retryCount < StarConstants.maxRetries - 1) {
            retryCount++;
            await Future.delayed(Duration(seconds: 2));
            continue;
          }
          return Left(UnknownFailure('Failed to get video duration'));
        }

        // Stage 3: Create video entry
        _updateStage(UploadStage.creatingEntry, 'Creating video entry...');
        final bunnyResponse =
            await _bunnyUploader.createBunnyVideo(title: title);

        if (bunnyResponse.isLeft()) {
          return bunnyResponse.fold((l) => Left(l), (r) => const Right(false));
        }

        final bunnyData = bunnyResponse.getOrElse(() => throw Exception());

        // Stage 4: Upload thumbnail
        _updateStage(UploadStage.uploadingThumbnail, 'Uploading thumbnail...');
        String? thumbnailMediaId;

        final uploadFile = UploadFile();
        await uploadFile.uploadImageSilent(
          subCategoryId: subCategoryId,
          context: context,
          file: thumbnailFile,
          onUploaded: (uploadEntity) {
            thumbnailMediaId = uploadEntity.mediaId;
          },
        );

        if (thumbnailMediaId == null) {
          if (retryCount < StarConstants.maxRetries - 1) {
            retryCount++;
            await Future.delayed(Duration(seconds: 2));
            continue;
          }
          return Left(UnknownFailure('Failed to upload thumbnail'));
        }

        // Stage 5: Upload video to Bunny CDN
        _updateStage(UploadStage.uploadingVideo, 'Uploading video...');

        final videoUploadResult = await _bunnyUploader.uploadVideoToBunny(
          videoFile: videoFile,
          uploadDetails: bunnyData.uploadVideoDetails,
          onProgress: (progress) {
            final overallProgress = 0.8 + (progress * 0.15); // 80-95% range
            _updateProgress(overallProgress);
          },
        );

        if (videoUploadResult.isRight()) {
          // Stage 6: Finalize upload
          _updateStage(UploadStage.finalizing, 'Finalizing upload...');

          final finalResult = await _bunnyUploader.submitVideoPost(
            videoData: VideoUploadEntity(
              title: title,
              description: description,
              videoMediaId: bunnyData.mediaId,
              thumbnailMediaId: thumbnailMediaId!,
              duration: duration,
            ),
          );

          if (finalResult.isRight()) {
            _updateStage(
                UploadStage.completed, 'Upload completed successfully!');
            return const Right(true);
          } else {
            return finalResult;
          }
        } else {
          if (retryCount < StarConstants.maxRetries - 1) {
            retryCount++;
            _updateStatus('Upload failed, retrying...');
            await Future.delayed(Duration(seconds: 3));
            continue;
          } else {
            return videoUploadResult;
          }
        }
      } catch (e) {
        if (retryCount < StarConstants.maxRetries - 1) {
          retryCount++;
          _updateStatus('Error occurred, retrying...');
          await Future.delayed(Duration(seconds: 2));
          continue;
        } else {
          _updateStage(UploadStage.failed, 'Upload failed: ${e.toString()}');
          return Left(UnknownFailure(
              'Upload failed after ${StarConstants.maxRetries} attempts: ${e.toString()}'));
        }
      }
    }

    return Left(UnknownFailure('Upload failed after maximum retries'));
  }

  void _updateStage(UploadStage stage, String message) {
    _currentStage = stage;
    _statusMessage = message;

    // Calculate progress based on stage
    switch (stage) {
      case UploadStage.validating:
        _overallProgress = 0.1;
        break;
      case UploadStage.creatingEntry:
        _overallProgress = 0.2;
        break;
      case UploadStage.uploadingThumbnail:
        _overallProgress = 0.3;
        break;
      case UploadStage.uploadingVideo:
        _overallProgress = 0.8; // Will be updated by video upload progress
        break;
      case UploadStage.finalizing:
        _overallProgress = 0.95;
        break;
      case UploadStage.completed:
        _overallProgress = 1.0;
        break;
      case UploadStage.failed:
        // Don't change progress on failure
        break;
    }

    onStageChanged?.call(stage);
    onStatusChanged?.call(message);
    onProgressChanged?.call(_overallProgress);
  }

  void _updateProgress(double progress) {
    _overallProgress = progress;
    onProgressChanged?.call(progress);
  }

  void _updateStatus(String message) {
    _statusMessage = message;
    onStatusChanged?.call(message);
  }

  // Getters for current state
  UploadStage get currentStage => _currentStage;
  double get overallProgress => _overallProgress;
  String get statusMessage => _statusMessage;
}
