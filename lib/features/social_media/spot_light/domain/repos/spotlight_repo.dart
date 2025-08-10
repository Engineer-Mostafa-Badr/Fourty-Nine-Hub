import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/paginated_response_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_media_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/upload_media_entity.dart';

import '../../../../../core/error/failure.dart';


abstract class SpotlightRepository {
  // Profile methods
  Future<Either<Failure, SpotlightProfileEntity>> getMySpotlightProfile();
  Future<Either<Failure, SpotlightProfileEntity>> getSpotlightProfileForUser(String userId);
  
  // Media methods
  Future<Either<Failure, PaginatedResponseEntity<SpotlightMediaEntity>>> getMySpotlightMedia({
    int page = 1,
    int limit = 10,
  });
  
  Future<Either<Failure, PaginatedResponseEntity<SpotlightMediaEntity>>> getSpotlightMediaForUser(
    String userId, {
    int page = 1,
    int limit = 10,
  });
  
  // Upload methods
  Future<Either<Failure, UploadRequestEntity>> requestUploadMedia({
    required MediaType mediaType,
    required String fileName,
    required int fileSize,
  });
  
  Future<Either<Failure, String>> uploadMediaToStorage({
    required UploadRequestEntity uploadRequest,
    required File file,
    Function(double progress)? onProgress,
  });
  
  Future<Either<Failure, UploadConfirmEntity>> confirmUploadMedia({
    required String uploadId,
    required String fileKey,
    String? caption,
  });
  
  // Additional methods
  Future<Either<Failure, bool>> likeMedia(String mediaId);
  Future<Either<Failure, bool>> unlikeMedia(String mediaId);
  Future<Either<Failure, bool>> deleteMedia(String mediaId);
}