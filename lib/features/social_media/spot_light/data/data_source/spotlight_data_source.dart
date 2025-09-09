import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/paginated_response_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/spotlight_media_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/spotlight_profile_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/upload_confirm_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/upload_request_model.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/friends_response_model.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/error/failure.dart';

abstract class SpotlightDataSource {
  // Profile methods
  Future<Either<Failure, SpotlightProfileModel>> getMySpotlightProfile();
  Future<Either<Failure, SpotlightProfileModel>> getSpotlightProfileForUser(
      String userId);

  // Media methods
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>>
      getMySpotlightMedia({
    int page = 1,
    int limit = 10,
  });
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>>
      getSpotlightMediaForUser(
    String userId, {
    int page = 1,
    int limit = 10,
  });

  // Friends Stories methods
  Future<Either<Failure, FriendsStoriesModel>> getFriendsStories({
    int page = 1,
    int limit = 50,
  });

  Future<Either<Failure, bool>> markStoryAsViewed(String storyId);
  Future<Either<Failure, bool>> likeStory(String storyId);

  // Upload methods
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

  // Action methods
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
  Future<Either<Failure, SpotlightProfileModel>> getSpotlightProfileForUser(
      String userId) async {
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
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>>
      getMySpotlightMedia({
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
          final paginatedResponse =
              PaginatedResponseModel<SpotlightMediaModel>.fromJson(
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
  Future<Either<Failure, PaginatedResponseModel<SpotlightMediaModel>>>
      getSpotlightMediaForUser(
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
          final paginatedResponse =
              PaginatedResponseModel<SpotlightMediaModel>.fromJson(
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

  // @override
  // Future<Either<Failure, FriendsStoriesModel>> getFriendsStories({
  //   int page = 1,
  //   int limit = 50,
  // }) async {
  //   final result = await api.get(
  //     '/api/v1/stories/friends',
  //     queryParameters: {
  //       'page': page,
  //       'limit': limit,
  //     },
  //   );
  //   return result.fold(
  //     (failure) => Left(failure),
  //     (response) {
  //       try {
  //         // هنحول من StoriesResponse إلى FriendsStoriesModel
  //         final storiesResponse = response;
  //         final friendsStories =
  //             _convertStoriesResponseToFriendsStories(storiesResponse);
  //         return Right(friendsStories);
  //       } catch (e) {
  //         return Left(UnknownFailure(e.toString()));
  //       }
  //     },
  //   );
  // }

  @override
  Future<Either<Failure, FriendsStoriesModel>> getFriendsStories({
    int page = 1,
    int limit = 50,
  }) async {
    // هنستخدم نفس الـ API المستخدم في StoriesRemoteDataSource
    final result = await api.get(
      EndPoints.fetchStories(PaginationParams(page: page, limit: limit)),
    );

    return result.fold(
      (failure) => Left(failure),
      (response) {
        try {
          // هنحول من StoriesResponse إلى FriendsStoriesModel
          final storiesResponse = response;
          final friendsStories =
              _convertStoriesResponseToFriendsStories(storiesResponse);
          return Right(friendsStories);
        } catch (e) {
          return Left(UnknownFailure(e.toString()));
        }
      },
    );
  }

  @override
  Future<Either<Failure, bool>> markStoryAsViewed(String storyId) async {
    final result = await api.post('/api/v1/stories/view/$storyId');
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response['status'] == true),
    );
  }

  @override
  Future<Either<Failure, bool>> likeStory(String storyId) async {
    final result = await api.post('/api/v1/stories/like/$storyId');
    return result.fold(
      (failure) => Left(failure),
      (response) => Right(response['status'] == true),
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

// Helper method لتحويل StoriesResponse إلى FriendsStoriesModel
FriendsStoriesModel _convertStoriesResponseToFriendsStories(
    Map<String, dynamic> response) {
  final data = response['data'];
  final stories = data['stories'] as List<dynamic>? ?? [];
  final pagination = data['pagination'] as Map<String, dynamic>? ?? {};

  final userWithStoriesList = stories.map((storyData) {
    final userStory = storyData as Map<String, dynamic>;
    final user = userStory['user'] as Map<String, dynamic>;
    final storiesList = userStory['stories'] as List<dynamic>? ?? [];

    return UserWithStoriesModel(
      user: UserBasicModel(
        userId: user['_id'] ?? '',
        firstName: user['firstName'] ?? '',
        lastName: user['lastName'] ?? '',
        username: user['username'] ??
            '${user['firstName'] ?? ''}${user['lastName'] ?? ''}',
        userProfileUrl: user['profilePictureSignedUrl'],
      ),
      stories: storiesList.map((story) {
        final storyMap = story as Map<String, dynamic>;
        return StoryBasicModel(
          id: storyMap['_id'] ?? '',
          isViewed: storyMap['isViewed'] ?? false,
          type: storyMap['type'],
          content: storyMap['content'],
          thumbnailUrl: storyMap['thumbnailSignedUrl'],
          createdAt: storyMap['createdAt'] != null
              ? DateTime.parse(storyMap['createdAt'])
              : null,
          color: storyMap['color'],
          fontFamily: storyMap['fontFamily'],
        );
      }).toList(),
      storyCount: storiesList.length,
    );
  }).toList();

  return FriendsStoriesModel(
    stories: userWithStoriesList,
    paginationDetails: PaginationDetailsModel(
      page: pagination['currentPage'] ?? 1,
      limit: pagination['limit'] ?? 50,
      totalItems: pagination['countItem'] ?? 0,
      totalPages: pagination['pageCount'] ?? 1,
      hasNextPage:
          (pagination['currentPage'] ?? 1) < (pagination['pageCount'] ?? 1),
      hasPrevPage: (pagination['currentPage'] ?? 1) > 1,
      nextPage:
          (pagination['currentPage'] ?? 1) < (pagination['pageCount'] ?? 1)
              ? (pagination['currentPage'] ?? 1) + 1
              : null,
      prevPage: (pagination['currentPage'] ?? 1) > 1
          ? (pagination['currentPage'] ?? 1) - 1
          : null,
    ),
  );
}
