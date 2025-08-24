import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/friends_stories_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/paginated_response_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_media_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/spotlight_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/story_basic_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/upload_media_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_basic_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/entities/user_with_stories_entity.dart';
import 'package:fourtyninehub/features/social_media/spot_light/domain/repos/spotlight_repo.dart';
import 'package:fourtyninehub/features/social_media/spot_light/data/models/friends_response_model.dart';

import '../../../../../core/error/failure.dart';

part 'spot_light_state.dart';

class SpotlightCubit extends Cubit<SpotLightState> {
  final SpotlightRepository repository;

  // Cache for profiles, media and friends stories
  SpotlightProfileEntity? _myProfile;
  final Map<String, SpotlightProfileEntity> _userProfiles = {};
  final Map<String, List<SpotlightMediaEntity>> _userMediaCache = {};
  List<SpotlightMediaEntity> _myMediaCache = [];
  FriendsStoriesEntity? _friendsStoriesCache;

  SpotlightCubit({required this.repository}) : super(SpotLightInitial());

  // Profile Methods
  Future<void> getMyProfile({bool forceRefresh = false}) async {
    if (_myProfile != null && !forceRefresh) {
      emit(SpotlightProfileLoaded(profile: _myProfile!, isMyProfile: true));
      return;
    }

    emit(SpotlightProfileLoading());

    final result = await repository.getMySpotlightProfile();
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (profile) {
        _myProfile = profile;
        emit(SpotlightProfileLoaded(profile: profile, isMyProfile: true));
      },
    );
  }

  Future<void> getUserProfile(String userId,
      {bool forceRefresh = false}) async {
    if (_userProfiles.containsKey(userId) && !forceRefresh) {
      emit(SpotlightProfileLoaded(
        profile: _userProfiles[userId]!,
        isMyProfile: false,
      ));
      return;
    }

    emit(SpotlightProfileLoading());

    final result = await repository.getSpotlightProfileForUser(userId);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (profile) {
        _userProfiles[userId] = profile;
        emit(SpotlightProfileLoaded(profile: profile, isMyProfile: false));
      },
    );
  }

  // Friends Stories Methods
  Future<void> getFriendsStories({bool forceRefresh = false, int page = 1, int limit = 50}) async {
    if (_friendsStoriesCache != null && !forceRefresh && page == 1) {
      emit(SpotlightFriendsStoriesLoaded(friendsStories: _friendsStoriesCache!));
      return;
    }

    if (page == 1) {
      emit(SpotlightFriendsStoriesLoading());
    }

    final result = await repository.getFriendsStories(page: page, limit: limit);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (friendsStories) {
        _friendsStoriesCache = friendsStories;
        emit(SpotlightFriendsStoriesLoaded(friendsStories: friendsStories));
      },
    );
  }

   // Stories Action Methods
  Future<void> viewStory(String storyId) async {
    final result = await repository.markStoryAsViewed(storyId);
    result.fold(
      (failure) {
        // يمكن عدم إظهار خطأ للمستخدم لأن الـ view عملية صامتة
        print('Failed to mark story as viewed: $failure');
      },
      (success) {
        if (success) {
          _updateStoryViewStatus(storyId, true);
        }
      },
    );
  }

  Future<void> likeStory(String storyId) async {
    final result = await repository.likeStory(storyId);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (success) {
        if (success) {
          emit(SpotlightActionSuccess(message: 'Story liked successfully'));
        }
      },
    );
  }

  // Helper Methods for Stories
  void _updateStoryViewStatus(String storyId, bool isViewed) {
    if (_friendsStoriesCache != null) {
      // Update the viewed status in cache
      final updatedStories = _friendsStoriesCache!.stories.map((userStories) {
        final updatedUserStories = userStories.stories.map((story) {
          if (story.id == storyId) {
            return StoryBasicEntity(
              id: story.id,
              isViewed: isViewed,
              type: story.type,
              content: story.content,
              thumbnailUrl: story.thumbnailUrl,
              createdAt: story.createdAt,
              color: story.color,
              fontFamily: story.fontFamily,
            );
          }
          return story;
        }).toList();

        return UserWithStoriesEntity(
          user: userStories.user,
          stories: updatedUserStories,
          storyCount: userStories.storyCount,
        );
      }).toList();

      _friendsStoriesCache = FriendsStoriesEntity(
        stories: updatedStories,
        paginationDetails: _friendsStoriesCache!.paginationDetails,
      );

      // Emit updated state
      emit(SpotlightFriendsStoriesLoaded(friendsStories: _friendsStoriesCache!));
    }
  }

  // Method to get specific user's stories for detailed view
  List<StoryBasicEntity> getUserStories(String userId) {
    if (_friendsStoriesCache == null) return [];
    
    final userStories = _friendsStoriesCache!.stories.firstWhere(
      (userStory) => userStory.user.userId == userId,
      orElse: () => const UserWithStoriesEntity(
        user: UserBasicEntity(userId: '', firstName: '', lastName: '', username: ''),
        stories: [],
        storyCount: 0,
      ),
    );
    
    return userStories.stories;
  }

  // Method to check if user has unviewed stories
  bool hasUnviewedStories(String userId) {
    if (_friendsStoriesCache == null) return false;
    
    try {
      final userStories = _friendsStoriesCache!.stories.firstWhere(
        (userStory) => userStory.user.userId == userId,
      );
      
      return userStories.stories.any((story) => !story.isViewed);
    } catch (e) {
      return false;
    }
  }

  List<UserBasicEntity> getUsersWithStories() {
    if (_friendsStoriesCache == null) return [];
    return _friendsStoriesCache!.stories.map((userStory) => userStory.user).toList();
  }

  // Media Methods
  Future<void> getMyMedia(
      {bool forceRefresh = false, int page = 1, int limit = 10}) async {
    if (page == 1 && !forceRefresh && _myMediaCache.isNotEmpty) {
      // Return cached data for first page
      final mockResponse = PaginatedResponseEntity<SpotlightMediaEntity>(
        data: _myMediaCache.take(limit).toList(),
        currentPage: 1,
        totalPages: (_myMediaCache.length / limit).ceil(),
        totalItems: _myMediaCache.length,
        hasNextPage: _myMediaCache.length > limit,
        hasPreviousPage: false,
      );
      emit(SpotlightMediaLoaded(
        mediaResponse: mockResponse,
        allMedia: _myMediaCache,
        userId: null,
      ));
      return;
    }

    if (page == 1) {
      emit(SpotlightMediaLoading());
    } else {
      // Loading more pages
      final currentState = state;
      if (currentState is SpotlightMediaLoaded) {
        emit(currentState.copyWith(isLoadingMore: true));
      }
    }

    final result =
        await repository.getMySpotlightMedia(page: page, limit: limit);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (mediaResponse) {
        if (page == 1) {
          _myMediaCache = List.from(mediaResponse.data);
        } else {
          _myMediaCache.addAll(mediaResponse.data);
        }

        emit(SpotlightMediaLoaded(
          mediaResponse: mediaResponse,
          allMedia: _myMediaCache,
          hasReachedMax: !mediaResponse.hasNextPage,
          userId: null,
        ));
      },
    );
  }

  Future<void> getUserMedia(String userId,
      {bool forceRefresh = false, int page = 1, int limit = 10}) async {
    if (page == 1 && !forceRefresh && _userMediaCache.containsKey(userId)) {
      final cachedMedia = _userMediaCache[userId]!;
      final mockResponse = PaginatedResponseEntity<SpotlightMediaEntity>(
        data: cachedMedia.take(limit).toList(),
        currentPage: 1,
        totalPages: (cachedMedia.length / limit).ceil(),
        totalItems: cachedMedia.length,
        hasNextPage: cachedMedia.length > limit,
        hasPreviousPage: false,
      );
      emit(SpotlightMediaLoaded(
        mediaResponse: mockResponse,
        allMedia: cachedMedia,
        userId: userId,
      ));
      return;
    }

    if (page == 1) {
      emit(SpotlightMediaLoading());
    } else {
      final currentState = state;
      if (currentState is SpotlightMediaLoaded) {
        emit(currentState.copyWith(isLoadingMore: true));
      }
    }

    final result = await repository.getSpotlightMediaForUser(userId,
        page: page, limit: limit);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (mediaResponse) {
        if (page == 1) {
          _userMediaCache[userId] = List.from(mediaResponse.data);
        } else {
          _userMediaCache[userId] = (_userMediaCache[userId] ?? [])
            ..addAll(mediaResponse.data);
        }

        emit(SpotlightMediaLoaded(
          mediaResponse: mediaResponse,
          allMedia: _userMediaCache[userId]!,
          hasReachedMax: !mediaResponse.hasNextPage,
          userId: userId,
        ));
      },
    );
  }

  // Upload Methods
  Future<void> uploadMedia({
    required File file,
    required MediaType mediaType,
    String? caption,
  }) async {
    emit(SpotlightUploadLoading(status: 'Requesting upload permission...'));

    try {
      // Step 1: Request upload permission
      final requestResult = await repository.requestUploadMedia(
        mediaType: mediaType,
        fileName: file.path.split('/').last,
        fileSize: await file.length(),
      );

      await requestResult.fold(
        (failure) async => emit(SpotlightError(failureMessage: failure)),
        (uploadRequest) async {
          emit(SpotlightUploadLoading(
              status: 'Uploading file...', progress: 0.0));

          // Step 2: Upload to storage
          final uploadResult = await repository.uploadMediaToStorage(
            uploadRequest: uploadRequest,
            file: file,
            onProgress: (progress) {
              emit(SpotlightUploadLoading(
                status: 'Uploading... ${(progress * 100).toInt()}%',
                progress: progress,
              ));
            },
          );

          await uploadResult.fold(
            (failure) async => emit(SpotlightError(failureMessage: failure)),
            (fileKey) async {
              emit(SpotlightUploadLoading(
                  status: 'Confirming upload...', progress: 1.0));

              // Step 3: Confirm upload
              final confirmResult = await repository.confirmUploadMedia(
                uploadId: uploadRequest.uploadId,
                fileKey: fileKey,
                caption: caption,
              );

              confirmResult.fold(
                (failure) => emit(SpotlightError(failureMessage: failure)),
                (confirmData) {
                  // Clear cache to refresh data
                  _myMediaCache.clear();
                  _myProfile = null;

                  emit(SpotlightUploadSuccess(uploadResult: confirmData));
                },
              );
            },
          );
        },
      );
    } catch (e) {
      emit(SpotlightError(failureMessage: UnknownFailure('Upload failed: $e')));
    }
  }

  // Action Methods
  Future<void> likeMedia(String mediaId) async {
    final result = await repository.likeMedia(mediaId);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (success) {
        if (success) {
          _updateMediaLikeStatus(mediaId, true);
          emit(SpotlightActionSuccess(message: 'Media liked successfully'));
        }
      },
    );
  }

  Future<void> unlikeMedia(String mediaId) async {
    final result = await repository.unlikeMedia(mediaId);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (success) {
        if (success) {
          _updateMediaLikeStatus(mediaId, false);
          emit(SpotlightActionSuccess(message: 'Media unliked successfully'));
        }
      },
    );
  }

  Future<void> deleteMedia(String mediaId) async {
    final result = await repository.deleteMedia(mediaId);
    result.fold(
      (failure) => emit(SpotlightError(failureMessage: failure)),
      (success) {
        if (success) {
          _removeMediaFromCache(mediaId);
          emit(SpotlightActionSuccess(message: 'Media deleted successfully'));
        }
      },
    );
  }

  // Helper Methods
  void _updateMediaLikeStatus(String mediaId, bool isLiked) {
    // Update in my media cache
    for (int i = 0; i < _myMediaCache.length; i++) {
      if (_myMediaCache[i].id == mediaId) {
        final media = _myMediaCache[i];
        _myMediaCache[i] = SpotlightMediaEntity(
          id: media.id,
          userId: media.userId,
          type: media.type,
          thumbnailUrl: media.thumbnailUrl,
          mediaUrl: media.mediaUrl,
          caption: media.caption,
          status: media.status,
          likesCount: isLiked ? media.likesCount + 1 : media.likesCount - 1,
          commentsCount: media.commentsCount,
          isLiked: isLiked,
          createdAt: media.createdAt,
          updatedAt: media.updatedAt,
        );
        break;
      }
    }

    // Update in user media caches
    _userMediaCache.forEach((userId, mediaList) {
      for (int i = 0; i < mediaList.length; i++) {
        if (mediaList[i].id == mediaId) {
          final media = mediaList[i];
          mediaList[i] = SpotlightMediaEntity(
            id: media.id,
            userId: media.userId,
            type: media.type,
            thumbnailUrl: media.thumbnailUrl,
            mediaUrl: media.mediaUrl,
            caption: media.caption,
            status: media.status,
            likesCount: isLiked ? media.likesCount + 1 : media.likesCount - 1,
            commentsCount: media.commentsCount,
            isLiked: isLiked,
            createdAt: media.createdAt,
            updatedAt: media.updatedAt,
          );
          break;
        }
      }
    });
  }

  void _removeMediaFromCache(String mediaId) {
    _myMediaCache.removeWhere((media) => media.id == mediaId);
    _userMediaCache.forEach((userId, mediaList) {
      mediaList.removeWhere((media) => media.id == mediaId);
    });
  }

  void clearCache() {
    _myProfile = null;
    _userProfiles.clear();
    _userMediaCache.clear();
    _myMediaCache.clear();
    _friendsStoriesCache = null;
  }

  void refreshData() {
    clearCache();
    emit(SpotLightInitial());
  }
}