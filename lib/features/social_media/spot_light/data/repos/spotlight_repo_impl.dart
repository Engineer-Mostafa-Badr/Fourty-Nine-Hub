import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/data_source/spotlight_data_source.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/upload_request_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/paginated_response_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_media_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/upload_media_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/repos/spotlight_repo.dart';

import '../../../../../core/error/failure.dart';

class SpotlightRepositoryImpl implements SpotlightRepository {
  final SpotlightDataSource dataSource;

  SpotlightRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, SpotlightProfileEntity>> getMySpotlightProfile() async {
    final result = await dataSource.getMySpotlightProfile();
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, SpotlightProfileEntity>> getSpotlightProfileForUser(String userId) async {
    if (userId.isEmpty) {
      return Left(const ValidationFailure('User ID cannot be empty'));
    }
    
    final result = await dataSource.getSpotlightProfileForUser(userId);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, PaginatedResponseEntity<SpotlightMediaEntity>>> getMySpotlightMedia({
    int page = 1,
    int limit = 10,
  }) async {
    if (page < 1) {
      return Left(const ValidationFailure('Page must be greater than 0'));
    }
    if (limit < 1 || limit > 50) {
      return Left(const ValidationFailure('Limit must be between 1 and 50'));
    }
    
    final result = await dataSource.getMySpotlightMedia(page: page, limit: limit);
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, PaginatedResponseEntity<SpotlightMediaEntity>>> getSpotlightMediaForUser(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    if (userId.isEmpty) {
      return Left(const ValidationFailure('User ID cannot be empty'));
    }
    if (page < 1) {
      return Left(const ValidationFailure('Page must be greater than 0'));
    }
    if (limit < 1 || limit > 50) {
      return Left(const ValidationFailure('Limit must be between 1 and 50'));
    }
    
    final result = await dataSource.getSpotlightMediaForUser(
      userId,
      page: page,
      limit: limit,
    );
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, UploadRequestEntity>> requestUploadMedia({
    required MediaType mediaType,
    required String fileName,
    required int fileSize,
  }) async {
    if (fileName.isEmpty) {
      return Left(const ValidationFailure('File name cannot be empty'));
    }
    if (fileSize <= 0) {
      return Left(const ValidationFailure('File size must be greater than 0'));
    }
    if (fileSize > 100 * 1024 * 1024) { // 100MB limit
      return Left(const ValidationFailure('File size cannot exceed 100MB'));
    }
    
    final result = await dataSource.requestUploadMedia(
      mediaType: mediaType.toString().split('.').last,
      fileName: fileName,
      fileSize: fileSize,
    );
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, String>> uploadMediaToStorage({
    required UploadRequestEntity uploadRequest,
    required File file,
    Function(double progress)? onProgress,
  }) async {
    if (!file.existsSync()) {
      return Left(const ValidationFailure('File does not exist'));
    }
    
    final result = await dataSource.uploadMediaToStorage(
      uploadRequest: uploadRequest as UploadRequestModel,
      file: file,
      onProgress: onProgress,
    );
    return result;
  }

  @override
  Future<Either<Failure, UploadConfirmEntity>> confirmUploadMedia({
    required String uploadId,
    required String fileKey,
    String? caption,
  }) async {
    if (uploadId.isEmpty) {
      return Left(const ValidationFailure('Upload ID cannot be empty'));
    }
    if (fileKey.isEmpty) {
      return Left(const ValidationFailure('File key cannot be empty'));
    }
    
    final result = await dataSource.confirmUploadMedia(
      uploadId: uploadId,
      fileKey: fileKey,
      caption: caption,
    );
    return result.fold(
      (failure) => Left(failure),
      (model) => Right(model),
    );
  }

  @override
  Future<Either<Failure, bool>> likeMedia(String mediaId) async {
    if (mediaId.isEmpty) {
      return Left(const ValidationFailure('Media ID cannot be empty'));
    }
    
    return await dataSource.likeMedia(mediaId);
  }

  @override
  Future<Either<Failure, bool>> unlikeMedia(String mediaId) async {
    if (mediaId.isEmpty) {
      return Left(const ValidationFailure('Media ID cannot be empty'));
    }
    
    return await dataSource.unlikeMedia(mediaId);
  }

  @override
  Future<Either<Failure, bool>> deleteMedia(String mediaId) async {
    if (mediaId.isEmpty) {
      return Left(const ValidationFailure('Media ID cannot be empty'));
    }
    
    return await dataSource.deleteMedia(mediaId);
  }
}