import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/paginated_response_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/spotlight_media_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/spotlight_profile_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/upload_confirm_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/upload_request_model.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/error/failure.dart';


abstract class SpotlightDataSource {
  Future<Either<Failure, SpotlightProfileModel>> getMySpotlightProfile();
  Future<Either<Failure, SpotlightProfileModel>> getSpotlightProfileForUser(String userId);
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>> getMySpotlightMedia({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>> getSpotlightMediaForUser(
    String userId, {
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, UploadRequestModel>> requestUploadMedia({
    required String mediaType,
    required String fileName,
    required int fileSize,
  });
  Future<Either<Failure, String>> uploadMediaToStorage({
    required UploadRequestModel uploadRequest,
    required File file,
    Function(double progress)? onProgress,
  });
  Future<Either<Failure, UploadConfirmModel>> confirmUploadMedia({
    required String uploadId,
    required String fileKey,
    String? caption,
  });
  Future<Either<Failure, bool>> likeMedia(String mediaId);
  Future<Either<Failure, bool>> unlikeMedia(String mediaId);
  Future<Either<Failure, bool>> deleteMedia(String mediaId);
}

class SpotlightDataSourceImpl implements SpotlightDataSource {
  final ApiConsumer api;
  final Dio uploadDio; // Separate Dio instance for file uploads

  SpotlightDataSourceImpl({
    required this.api,
    required this.uploadDio,
  });

  @override
  Future<Either<Failure, SpotlightProfileModel>> getMySpotlightProfile() async {
    final result = await api.get('/spotlight/profile/me');
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final profile = SpotlightProfileModel.fromJson(response['data']);
          return Right(profile);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, SpotlightProfileModel>> getSpotlightProfileForUser(String userId) async {
    final result = await api.get('/spotlight/profile/$userId');
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final profile = SpotlightProfileModel.fromJson(response['data']);
          return Right(profile);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>> getMySpotlightMedia({
    int page = 1,
    int limit = 10,
  }) async {
    final result = await api.get(
      '/spotlight/media/me',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final paginatedResponse = PaginatedResponseModel<SpotlightMediaModel>.fromJson(
            response['data'],
            (json) => SpotlightMediaModel.fromJson(json),
          );
          return Right(paginatedResponse);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>> getSpotlightMediaForUser(
    String userId, {
    int page = 1,
    int limit = 10,
  }) async {
    final result = await api.get(
      '/spotlight/media/$userId',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final paginatedResponse = PaginatedResponseModel<SpotlightMediaModel>.fromJson(
            response['data'],
            (json) => SpotlightMediaModel.fromJson(json),
          );
          return Right(paginatedResponse);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, UploadRequestModel>> requestUploadMedia({
    required String mediaType,
    required String fileName,
    required int fileSize,
  }) async {
    final result = await api.post(
      '/spotlight/media/upload/request',
      data: {
        'mediaType': mediaType,
        'fileName': fileName,
        'fileSize': fileSize,
      },
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final uploadRequest = UploadRequestModel.fromJson(response['data']);
          return Right(uploadRequest);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, String>> uploadMediaToStorage({
    required UploadRequestModel uploadRequest,
    required File file,
    Function(double progress)? onProgress,
  }) async {
    try {
      final formData = FormData();
      
      // Add upload fields from the upload request
      uploadRequest.uploadFields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value));
      });
      
      // Add the file
      formData.files.add(MapEntry(
        'file',
        await MultipartFile.fromFile(
          file.path,
          filename: uploadRequest.fileKey,
        ),
      ));

      final response = await uploadDio.post(
        uploadRequest.uploadUrl,
        data: formData,
        onSendProgress: onProgress != null 
            ? (sent, total) => onProgress(sent / total)
            : null,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(uploadRequest.fileKey);
      } else {
        return Left(ServerFailure(
          message: 'Upload failed with status: ${response.statusCode}',
          name: 'Upload Error',
        ));
      }
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UploadConfirmModel>> confirmUploadMedia({
    required String uploadId,
    required String fileKey,
    String? caption,
  }) async {
    final result = await api.post(
      '/spotlight/media/upload/confirm',
      data: {
        'uploadId': uploadId,
        'fileKey': fileKey,
        if (caption != null) 'caption': caption,
      },
    );
    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          final confirmResult = UploadConfirmModel.fromJson(response['data']);
          return Right(confirmResult);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> likeMedia(String mediaId) async {
    final result = await api.post(
      '/spotlight/media/like',
      data: {'mediaId': mediaId},
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response['status'] == true),
    );
  }

  @override
  Future<Either<Failure, bool>> unlikeMedia(String mediaId) async {
    final result = await api.post(
      '/spotlight/media/unlike',
      data: {'mediaId': mediaId},
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response['status'] == true),
    );
  }

  @override
  Future<Either<Failure, bool>> deleteMedia(String mediaId) async {
    final result = await api.delete(
      '/spotlight/media/delete',
      data: {'mediaId': mediaId},
    );
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response['status'] == true),
    );
  }
}