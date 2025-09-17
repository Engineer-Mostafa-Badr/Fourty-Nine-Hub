import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../domain/entity/banner_talent_entity.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../../domain/entity/star_entity.dart';
import '../../../domain/entity/star_winner_entity.dart';
import '../../../domain/use_case/delete_my_star_use_case.dart';
import '../../../domain/use_case/delete_tube_video_use_case.dart';
import '../../../domain/use_case/fetch_all_star_use_case.dart';
import '../../../domain/use_case/fetch_banner_use_case.dart';
import '../../../domain/use_case/fetch_myl_star_use_case.dart';
import '../../../domain/use_case/fetch_winner_star_use_case.dart';
import '../../../domain/use_case/search_profiles_use_case.dart';
import '../../../domain/use_case/search_tube_videos_use_case.dart';
import '../../../domain/use_case/tube_favorite_use_cases.dart';
import '../../../domain/use_case/tube_watch_later_use_cases.dart';
import '../../../domain/use_case/upload_my_star_use_case.dart';
// New imports for Tube Video functionality
import '../../../domain/use_case/fetch_all_tube_videos_use_case.dart';
import '../../../domain/use_case/fetch_my_tube_videos_use_case.dart';
import '../../../domain/use_case/fetch_tube_video_details_by_iduse_case.dart';
import '../../../domain/use_case/like_tube_video_use_case.dart';
import '../../../domain/use_case/dislike_tube_video_use_case.dart';
import '../../../domain/use_case/increment_tube_video_view_use_case.dart';
import '../../../data/model/tube_video_models.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';
part 'star_state.dart';

class StarCubit extends Cubit<StarState> {
  // Existing use cases
  final FetchAllStarUseCase _allStarUseCase;
  final SearchTubeVideosUseCase _searchTubeVideosUseCase;
  final FetchMylStarUseCase _fetchMylStarUseCase;
  final FetchWinnerStarUseCase _fetchWinnerStarUseCase;
  final UploadMyStarUseCase _uploadMyStarUseCase;
  final DeleteMyStarUseCase _deleteMyTalentUseCase;
  final FetchBannerUseCase _bannerUseCase;
  final SearchProfilesUseCase _searchProfilesUseCase;
  final AddVideoToFavoriteUseCase _addVideoToFavoriteUseCase;
  final RemoveVideoFromFavoriteUseCase _removeVideoFromFavoriteUseCase;
  final GetFavoriteVideosUseCase _getFavoriteVideosUseCase;

  // Watch Later use cases
  final AddVideoToWatchLaterUseCase _addVideoToWatchLaterUseCase;
  final RemoveVideoFromWatchLaterUseCase _removeVideoFromWatchLaterUseCase;
  final GetWatchLaterVideosUseCase _getWatchLaterVideosUseCase;

  // New Tube Video use cases
  final FetchAllTubeVideosUseCase _fetchAllTubeVideosUseCase;
  final FetchMyTubeVideosUseCase _fetchMyTubeVideosUseCase;
  final FetchTubeVideoDetailsByIdUseCase _fetchTubeVideoDetailsByIdUseCase;
  final LikeTubeVideoUseCase _likeTubeVideoUseCase;
  final DislikeTubeVideoUseCase _dislikeTubeVideoUseCase;
  final IncrementTubeVideoViewUseCase _incrementTubeVideoViewUseCase;
  final DeleteTubeVideoUseCase _deleteTubeVideoUseCase;

  StarCubit(
    this._allStarUseCase,
    this._fetchMylStarUseCase,
    this._uploadMyStarUseCase,
    this._deleteMyTalentUseCase,
    this._fetchWinnerStarUseCase,
    this._bannerUseCase,
    this._searchProfilesUseCase,
    this._searchTubeVideosUseCase,
    this._addVideoToFavoriteUseCase,
    this._removeVideoFromFavoriteUseCase,
    this._getFavoriteVideosUseCase,
    // Watch Later use cases
    this._addVideoToWatchLaterUseCase,
    this._removeVideoFromWatchLaterUseCase,
    this._getWatchLaterVideosUseCase,
    // New Tube Video use cases
    this._fetchAllTubeVideosUseCase,
    this._fetchMyTubeVideosUseCase,
    this._fetchTubeVideoDetailsByIdUseCase,
    this._likeTubeVideoUseCase,
    this._dislikeTubeVideoUseCase,
    this._incrementTubeVideoViewUseCase,
    this._deleteTubeVideoUseCase,
  ) : super(StarState());

  // Configuration flag to choose between old Star API and new Tube Video API
  bool get _useTubeVideoAPI => true; // Set to false to use old API

  // Initialize all data with API selection
  Future<void> initializeAllData() async {
    emit(state.copyWith(status: StarStates.loading));

    await Future.wait([
      loadTalents(TalentCategory.available, refresh: true),
      loadTalents(TalentCategory.myTalents, refresh: true),
      loadWatchLaterVideos(refresh: true),
      _fetchBanner(),
    ]);

    emit(state.copyWith(status: StarStates.success));
  }

  Future<void> debugMyTalentsFlow() async {
    print("=== DEBUGGING MY TALENTS FLOW ===");
    print("1. _useTubeVideoAPI: $_useTubeVideoAPI");
    print("2. Current state: ${state.status}");
    print("3. My talents count: ${state.myTalents.length}");
    print(
        "4. Loading state for myTalents: ${state.isLoading(TalentCategory.myTalents)}");

    try {
      // Test direct API call
      final response = await _fetchMyTubeVideosUseCase(
        StarPaginationParams(page: 1, limit: 10),
      );

      response.fold(
        (failure) => print("5. Direct API call failed: $failure"),
        (success) => print(
            "5. Direct API call succeeded: ${success.videos.length} videos"),
      );
    } catch (e) {
      print("5. Direct API call exception: $e");
    }

    print("=== END DEBUG ===");
  }

  // البحث في الفيديوهات
  Future<void> searchTubeVideos(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(
        searchResults: [],
        searchQuery: '',
      ));
      return;
    }

    emit(state.copyWith(
      searchQuery: query,
      status: StarStates.loading,
    ));

    final response = await _searchTubeVideosUseCase(
      SearchTubeVideosParams(query: query),
    );

    response.fold(
      (failure) {
        emit(state.copyWith(
          status: StarStates.error,
          failure: failure,
        ));
        _showErrorMessage(failure);
      },
      (videos) {
        emit(state.copyWith(
          searchResults: videos.cast<StarEntity>(),
          status: StarStates.success,
        ));
      },
    );
  }

  // Toggle favorite for tube videos
  Future<void> toggleTubeFavorite(String videoId) async {
    final isFavorite = state.favoriteIds.contains(videoId);

    // Optimistic update
    final updatedFavorites = Set<String>.from(state.favoriteIds);
    if (isFavorite) {
      updatedFavorites.remove(videoId);
    } else {
      updatedFavorites.add(videoId);
    }

    emit(state.copyWith(favoriteIds: updatedFavorites));

    // API call
    final response = isFavorite
        ? await _removeVideoFromFavoriteUseCase(videoId)
        : await _addVideoToFavoriteUseCase(videoId);

    response.fold(
      (failure) {
        // Revert optimistic update on failure
        emit(state.copyWith(favoriteIds: state.favoriteIds));
        _showErrorMessage(failure);
      },
      (message) {
        // Success - refresh favorites list
        loadFavoriteVideos();

        // Show success message
        final currentContext =
            AppPages.router.configuration.navigatorKey.currentContext;
        if (currentContext != null) {
          showSuccessMessage(currentContext, message);
        }
      },
    );
  }

  // Load favorite videos from API
  Future<void> loadFavoriteVideos({bool refresh = false}) async {
    if (refresh) {
      _resetPagination(TalentCategory.favorites);
    }

    if (state.isLoading(TalentCategory.favorites)) return;

    final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);
    loadingStates[TalentCategory.favorites] = true;
    emit(state.copyWith(loadingStates: loadingStates));

    final response = await _getFavoriteVideosUseCase(const NoParams());

    response.fold(
      (failure) {
        _handleError(TalentCategory.favorites, failure);
      },
      (favoriteVideos) {
        // Update favorite IDs based on API response
        final favoriteIds = favoriteVideos.map((video) => video.id).toSet();

        // Update talents data
        final talents =
            Map<TalentCategory, List<StarEntity>>.from(state.talents);
        talents[TalentCategory.favorites] = favoriteVideos.cast<StarEntity>();

        final loadingStates =
            Map<TalentCategory, bool>.from(state.loadingStates);
        loadingStates[TalentCategory.favorites] = false;

        emit(state.copyWith(
          talents: talents,
          favoriteIds: favoriteIds,
          loadingStates: loadingStates,
          status: StarStates.success,
        ));
      },
    );
  }

  // Watch Later functionality
  Future<void> toggleTubeWatchLater(String videoId) async {
    print("🎬 toggleTubeWatchLater called with videoId: $videoId");
    final isWatchLater = state.watchLaterIds.contains(videoId);
    print("🎬 Current watch later state: $isWatchLater");

    // Optimistic update
    final updatedWatchLater = Set<String>.from(state.watchLaterIds);
    if (isWatchLater) {
      updatedWatchLater.remove(videoId);
    } else {
      updatedWatchLater.add(videoId);
    }

    emit(state.copyWith(watchLaterIds: updatedWatchLater));
    print("🎬 Updated watch later IDs: $updatedWatchLater");

    // API call
    print("🎬 Making API call: ${isWatchLater ? 'remove' : 'add'}");
    final response = isWatchLater
        ? await _removeVideoFromWatchLaterUseCase(videoId)
        : await _addVideoToWatchLaterUseCase(videoId);

    response.fold(
      (failure) {
        print("🎬 API call failed: $failure");
        // Revert optimistic update on failure
        emit(state.copyWith(watchLaterIds: state.watchLaterIds));
        _showErrorMessage(failure);
      },
      (message) {
        print("🎬 API call succeeded: $message");
        // Success - refresh watch later list
        loadWatchLaterVideos();

        // Show success message
        final currentContext =
            AppPages.router.configuration.navigatorKey.currentContext;
        if (currentContext != null) {
          showSuccessMessage(currentContext, message);
        }
      },
    );
  }

  // Load watch later videos from API
  Future<void> loadWatchLaterVideos({bool refresh = false}) async {
    if (refresh) {
      _resetPagination(TalentCategory.watchLater);
    }

    if (state.isLoading(TalentCategory.watchLater)) return;

    final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);
    loadingStates[TalentCategory.watchLater] = true;
    emit(state.copyWith(loadingStates: loadingStates));

    final response = await _getWatchLaterVideosUseCase(const NoParams());

    response.fold(
      (failure) {
        _handleError(TalentCategory.watchLater, failure);
      },
      (watchLaterVideos) {
        // Update watch later IDs based on API response
        final watchLaterIds = watchLaterVideos.map((video) => video.id).toSet();

        // Update talents data
        final talents =
            Map<TalentCategory, List<StarEntity>>.from(state.talents);
        talents[TalentCategory.watchLater] =
            watchLaterVideos.cast<StarEntity>();

        final loadingStates =
            Map<TalentCategory, bool>.from(state.loadingStates);
        loadingStates[TalentCategory.watchLater] = false;

        emit(state.copyWith(
          talents: talents,
          watchLaterIds: watchLaterIds,
          loadingStates: loadingStates,
          status: StarStates.success,
        ));
      },
    );
  }

  Future<void> loadTalents(
    TalentCategory category, {
    bool refresh = false,
  }) async {
    print("📱 loadTalents called - category: $category, refresh: $refresh");

    if (refresh) {
      _resetPagination(category);
    }

    if (state.isLoading(category)) {
      print("⏳ Already loading $category, skipping...");
      return;
    }

    if (category == TalentCategory.favorites) {
      // Use the new API for favorites
      await loadFavoriteVideos(refresh: refresh);
      return;
    }

    if (category == TalentCategory.watchLater) {
      // Use the new API for watch later
      await loadWatchLaterVideos(refresh: refresh);
      return;
    }

    if (!refresh && !state.hasMore(category)) {
      print("🔚 No more data for $category, skipping...");
      return;
    }

    // Update loading state
    final newLoadingStates =
        Map<TalentCategory, bool>.from(state.loadingStates);
    newLoadingStates[category] = true;
    emit(state.copyWith(loadingStates: newLoadingStates));
    print("🔄 Set loading state for $category to true");

    try {
      List<StarEntity> newTalents = [];

      switch (category) {
        case TalentCategory.available:
          print("📺 Fetching available talents...");
          newTalents = await _fetchAvailableTalents();
          break;
        case TalentCategory.favorites:
          print("❤️ Updating favorites list...");
          newTalents = _updateFavoritesList();
          break;
        case TalentCategory.watchLater:
          print("🕒 Updating watch later list...");
          newTalents = _updateWatchLaterList();
          break;
        case TalentCategory.myTalents:
          print("👤 Fetching my talents...");
          newTalents = await _fetchMyTalents();
          break;
        case TalentCategory.history:
          print("📜 Fetching history talents...");
          newTalents = await _fetchHistoryTalents();
          break;
      }

      print("✅ Successfully fetched ${newTalents.length} items for $category");
      _updateTalentsData(category, newTalents, refresh);
    } catch (e, stackTrace) {
      print("❌ Error loading $category: $e");
      print("❌ Stack trace: $stackTrace");
      _handleError(category, e);
    }
  }

  Future<List<StarEntity>> _fetchAvailableTalents() async {
    if (_useTubeVideoAPI) {
      // Use new Tube Video API
      final response = await _fetchAllTubeVideosUseCase(
        StarPaginationParams(
          page: state.getCurrentPage(TalentCategory.available),
          limit: StarConstants.pageSize,
        ),
      );

      return response.fold(
        (failure) => throw failure,
        (tubeResponse) {
          // Update pagination info from API response
          _updatePaginationFromTubeResponse(
              TalentCategory.available, tubeResponse);
          return tubeResponse.videos.cast<StarEntity>();
        },
      );
    } else {
      // Use old Star API
      final response = await _allStarUseCase(
        StarPaginationParams(
          page: state.getCurrentPage(TalentCategory.available),
          limit: StarConstants.pageSize,
        ),
      );

      return response.fold(
        (failure) => throw failure,
        (data) => data,
      );
    }
  }

  // Future<List<StarEntity>> _fetchMyTalents() async {
  //   if (_useTubeVideoAPI) {
  //     // Use new Tube Video API
  //     final response = await _fetchMyTubeVideosUseCase(
  //       StarPaginationParams(
  //         page: state.getCurrentPage(TalentCategory.myTalents),
  //         limit: StarConstants.pageSize,
  //       ),
  //     );

  //     return response.fold(
  //       (failure) => throw failure,
  //       (tubeResponse) {
  //         // Update pagination info from API response
  //         _updatePaginationFromTubeResponse(
  //             TalentCategory.myTalents, tubeResponse);
  //         return tubeResponse.videos.cast<StarEntity>();
  //       },
  //     );
  //   } else {
  //     // Use old Star API
  //     final response = await _fetchMylStarUseCase.call(const NoParams());

  //     return response.fold(
  //       (failure) => throw failure,
  //       (data) => data,
  //     );
  //   }
  // }

  // Fixed version of _fetchMyTalents method in StarCubit
  Future<List<StarEntity>> _fetchMyTalents() async {
    print("🎬 _fetchMyTalents called - useTubeVideoAPI: $_useTubeVideoAPI");

    if (_useTubeVideoAPI) {
      // Use new Tube Video API
      print("🎬 Using Tube Video API for My Talents");

      final response = await _fetchMyTubeVideosUseCase(
        StarPaginationParams(
          page: state.getCurrentPage(TalentCategory.myTalents),
          limit: StarConstants.pageSize,
        ),
      );

      return response.fold(
        (failure) {
          print("❌ _fetchMyTalents error: $failure");
          throw failure;
        },
        (tubeResponse) {
          print(
              "✅ _fetchMyTalents success: ${tubeResponse.videos.length} videos");

          // Update pagination info from API response
          _updatePaginationFromTubeResponse(
              TalentCategory.myTalents, tubeResponse);

          // Cast to List<StarEntity> since TubeVideoModel extends StarEntity
          final List<StarEntity> entities =
              tubeResponse.videos.cast<StarEntity>();
          print("🔄 Casted to ${entities.length} StarEntity items");

          return entities;
        },
      );
    } else {
      // Use old Star API
      print("🎬 Using Old Star API for My Talents");

      final response = await _fetchMylStarUseCase.call(const NoParams());

      return response.fold(
        (failure) {
          print("❌ _fetchMyTalents (old API) error: $failure");
          throw failure;
        },
        (data) {
          print("✅ _fetchMyTalents (old API) success: ${data.length} items");
          return data;
        },
      );
    }
  }

  void _debugState(String operation) {
    print("🔍 DEBUG STATE - $operation");
    print("   My Talents Count: ${state.myTalents.length}");
    print("   Loading States: ${state.loadingStates}");
    print("   Has More Data: ${state.hasMoreData}");
    print("   Current Pages: ${state.currentPages}");
    print("   Status: ${state.status}");
  }

  Future<List<StarEntity>> _fetchHistoryTalents() async {
    // Mock implementation - replace with actual history API call
    return state.availableTalents.take(8).toList();
  }

  List<StarEntity> _updateFavoritesList() {
    return state.availableTalents
        .where((talent) => state.favoriteIds.contains(talent.id))
        .toList();
  }

  List<StarEntity> _updateWatchLaterList() {
    return state.availableTalents
        .where((talent) => state.watchLaterIds.contains(talent.id))
        .toList();
  }

  // Helper method to update pagination from Tube API response
  void _updatePaginationFromTubeResponse(
    TalentCategory category,
    TubeVideoListResponse tubeResponse,
  ) {
    final hasMore = Map<TalentCategory, bool>.from(state.hasMoreData);
    final pages = Map<TalentCategory, int>.from(state.currentPages);

    // More robust pagination logic
    final currentPage = tubeResponse.pagination.page;
    final totalPages = tubeResponse.pagination.pages;
    final videosCount = tubeResponse.videos.length;
    final limit = tubeResponse.pagination.limit;

    // Check if there are more pages available
    hasMore[category] = currentPage < totalPages && videosCount >= limit;

    // Only increment page if we have more data
    if (hasMore[category]!) {
      pages[category] = currentPage + 1;
    }

    // Special handling for edge cases
    if (videosCount == 0 || (totalPages > 0 && currentPage >= totalPages)) {
      hasMore[category] = false;
    }

    print("🔍 $category Pagination Update:");
    print("   Current page: $currentPage");
    print("   Total pages: $totalPages");
    print("   Videos count: $videosCount");
    print("   Limit: $limit");
    print("   Has more: ${hasMore[category]}");
    print("   Next page: ${pages[category]}");

    emit(state.copyWith(
      hasMoreData: hasMore,
      currentPages: pages,
    ));
  }

  // void _updateTalentsData(
  //   TalentCategory category,
  //   List<StarEntity> newTalents,
  //   bool refresh,
  // ) {
  //   final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);
  //   final pages = Map<TalentCategory, int>.from(state.currentPages);
  //   final hasMore = Map<TalentCategory, bool>.from(state.hasMoreData);
  //   final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);

  //   if (refresh) {
  //     talents[category] = newTalents;
  //   } else {
  //     talents[category] = [...(talents[category] ?? []), ...newTalents];
  //   }

  //   // Update pagination only if not using Tube API (handled separately)
  //   if (!_useTubeVideoAPI) {
  //     if (newTalents.length < StarConstants.pageSize) {
  //       hasMore[category] = false;
  //     } else {
  //       pages[category] = (pages[category] ?? 1) + 1;
  //     }
  //   }

  //   loadingStates[category] = false;

  //   emit(state.copyWith(
  //     talents: talents,
  //     currentPages: pages,
  //     hasMoreData: hasMore,
  //     loadingStates: loadingStates,
  //     status: StarStates.success,
  //   ));
  // }

  void _updateTalentsData(
    TalentCategory category,
    List<StarEntity> newTalents,
    bool refresh,
  ) {
    print(
        "🔄 _updateTalentsData - category: $category, newTalents: ${newTalents.length}, refresh: $refresh");

    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);
    final pages = Map<TalentCategory, int>.from(state.currentPages);
    final hasMore = Map<TalentCategory, bool>.from(state.hasMoreData);
    final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);

    if (refresh) {
      talents[category] = newTalents;
      print("🔄 Replaced all talents for $category");
    } else {
      final existingCount = talents[category]?.length ?? 0;
      talents[category] = [...(talents[category] ?? []), ...newTalents];
      print(
          "🔄 Added ${newTalents.length} to existing $existingCount for $category");
    }

    // Update pagination only if not using Tube API (handled separately)
    if (!_useTubeVideoAPI) {
      if (newTalents.length < StarConstants.pageSize) {
        hasMore[category] = false;
        print("🔚 No more data available for $category");
      } else {
        pages[category] = (pages[category] ?? 1) + 1;
        print("📄 Updated page for $category to ${pages[category]}");
      }
    }

    loadingStates[category] = false;
    print("🔄 Set loading state for $category to false");

    final newState = state.copyWith(
      talents: talents,
      currentPages: pages,
      hasMoreData: hasMore,
      loadingStates: loadingStates,
      status: StarStates.success,
    );

    emit(newState);
    print("✅ State updated - my talents count: ${newState.myTalents.length}");
  }

  // New Tube Video specific methods
  // Enhanced like functionality with optimistic updates and toggle behavior
  Future<void> likeTubeVideo(String videoId) async {
    // Check current like status for toggle behavior
    final video = _findVideoById(videoId);
    final wasLiked = video != null && _isVideoLikedByCurrentUser(videoId);

    // Optimistic update - toggle behavior
    if (wasLiked) {
      _updateVideoInteraction(videoId, 'unlike');
    } else {
      // If disliked, remove dislike first, then add like
      if (video != null && _isVideoDislikedByCurrentUser(videoId)) {
        _updateVideoInteraction(videoId, 'undislike');
      }
      _updateVideoInteraction(videoId, 'like');
    }

    final response = await _likeTubeVideoUseCase(videoId);

    response.fold(
      (failure) {
        // Revert optimistic update on failure
        if (wasLiked) {
          _updateVideoInteraction(videoId, 'like');
        } else {
          _updateVideoInteraction(videoId, 'unlike');
          if (video != null && _isVideoDislikedByCurrentUser(videoId)) {
            _updateVideoInteraction(videoId, 'dislike');
          }
        }
        _showErrorMessage(failure);
      },
      (success) {
        if (!success) {
          // Revert optimistic update if API returned false
          if (wasLiked) {
            _updateVideoInteraction(videoId, 'like');
          } else {
            _updateVideoInteraction(videoId, 'unlike');
            if (video != null && _isVideoDislikedByCurrentUser(videoId)) {
              _updateVideoInteraction(videoId, 'dislike');
            }
          }
        }
      },
    );
  }

// Enhanced dislike functionality with optimistic updates and toggle behavior
  Future<void> dislikeTubeVideo(String videoId) async {
    // Check current dislike status for toggle behavior
    final video = _findVideoById(videoId);
    final wasDisliked = video != null && _isVideoDislikedByCurrentUser(videoId);

    // Optimistic update - toggle behavior
    if (wasDisliked) {
      _updateVideoInteraction(videoId, 'undislike');
    } else {
      // If liked, remove like first, then add dislike
      if (video != null && _isVideoLikedByCurrentUser(videoId)) {
        _updateVideoInteraction(videoId, 'unlike');
      }
      _updateVideoInteraction(videoId, 'dislike');
    }

    final response = await _dislikeTubeVideoUseCase(videoId);

    response.fold(
      (failure) {
        // Revert optimistic update on failure
        if (wasDisliked) {
          _updateVideoInteraction(videoId, 'dislike');
        } else {
          _updateVideoInteraction(videoId, 'undislike');
          if (video != null && _isVideoLikedByCurrentUser(videoId)) {
            _updateVideoInteraction(videoId, 'like');
          }
        }
        _showErrorMessage(failure);
      },
      (success) {
        if (!success) {
          // Revert optimistic update if API returned false
          if (wasDisliked) {
            _updateVideoInteraction(videoId, 'dislike');
          } else {
            _updateVideoInteraction(videoId, 'undislike');
            if (video != null && _isVideoLikedByCurrentUser(videoId)) {
              _updateVideoInteraction(videoId, 'like');
            }
          }
        }
      },
    );
  }

// Enhanced view increment with better tracking
  Future<void> incrementVideoView(String videoId) async {
    // Don't show loading state for view increments
    final response = await _incrementTubeVideoViewUseCase(videoId);

    response.fold(
      (failure) {
        // Silently handle view increment failures
        print('Failed to increment view for video $videoId: $failure');
      },
      (success) {
        if (success) {
          // Update video views in local state
          _updateVideoViews(videoId);
        }
      },
    );
  }

  Future<void> deleteMyTubeVideo(String videoId) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _deleteTubeVideoUseCase(videoId);

    response.fold(
      (failure) {
        _showErrorMessage(failure);
        emit(state.copyWith(status: StarStates.error, failure: failure));
      },
      (success) {
        if (success) {
          // Remove video from local state
          _removeVideoFromState(videoId);

          // Show success message
          final currentContext =
              AppPages.router.configuration.navigatorKey.currentContext;
          if (currentContext != null) {
            ScaffoldMessenger.of(currentContext).showSnackBar(
              SnackBar(
                content: Text('Video deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
        emit(state.copyWith(status: StarStates.success));
      },
    );
  }

  Future<void> fetchVideoDetails(String videoId) async {
    emit(state.copyWith(status: StarStates.loading));

    final response = await _fetchTubeVideoDetailsByIdUseCase(videoId);

    response.fold(
      (failure) {
        _showErrorMessage(failure);
        emit(state.copyWith(status: StarStates.error, failure: failure));
      },
      (videoDetails) {
        // Handle video details as needed
        emit(state.copyWith(status: StarStates.success));
      },
    );
  }

  // Helper methods for updating local state
  void _updateVideoInteraction(String videoId, String action) {
    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);

    for (final category in TalentCategory.values) {
      final categoryTalents = talents[category];
      if (categoryTalents != null) {
        final updatedTalents = categoryTalents.map((talent) {
          if (talent.id == videoId && talent is TubeVideoModel) {
            switch (action) {
              case 'like':
                return talent.copyWith(
                  likes: talent.isLike ? talent.likes : talent.likes + 1,
                  isLike: true,
                  dislikes: talent.isDislike
                      ? (talent.dislikes - 1).clamp(0, double.infinity).toInt()
                      : talent.dislikes,
                  isDislike: false, // إزالة الـ dislike لو موجود
                );
              case 'unlike':
                return talent.copyWith(
                  likes: talent.isLike
                      ? (talent.likes - 1).clamp(0, double.infinity).toInt()
                      : talent.likes,
                  isLike: false,
                );
              case 'dislike':
                return talent.copyWith(
                  dislikes:
                      talent.isDislike ? talent.dislikes : talent.dislikes + 1,
                  isDislike: true,
                  likes: talent.isLike
                      ? (talent.likes - 1).clamp(0, double.infinity).toInt()
                      : talent.likes,
                  isLike: false, // إزالة الـ like لو موجود
                );
              case 'undislike':
                return talent.copyWith(
                  dislikes: talent.isDislike
                      ? (talent.dislikes - 1).clamp(0, double.infinity).toInt()
                      : talent.dislikes,
                  isDislike: false,
                );
              default:
                return talent;
            }
          }
          return talent;
        }).toList();

        talents[category] = updatedTalents;
      }
    }

    emit(state.copyWith(talents: talents));
  }

  void _updateVideoViews(String videoId) {
    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);

    for (final category in TalentCategory.values) {
      final categoryTalents = talents[category];
      if (categoryTalents != null) {
        final updatedTalents = categoryTalents.map((talent) {
          if (talent.id == videoId && talent is TubeVideoModel) {
            return talent.copyWith(
              totalViews: talent.totalViews + 1,
            );
          }
          return talent;
        }).toList();
        talents[category] = updatedTalents;
      }
    }

    emit(state.copyWith(talents: talents));
  }

  void _removeVideoFromState(String videoId) {
    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);

    for (final category in TalentCategory.values) {
      final categoryTalents = talents[category];
      if (categoryTalents != null) {
        final updatedTalents =
            categoryTalents.where((talent) => talent.id != videoId).toList();
        talents[category] = updatedTalents;
      }
    }

    emit(state.copyWith(talents: talents));
  }

  void _resetPagination(TalentCategory category) {
    final pages = Map<TalentCategory, int>.from(state.currentPages);
    final hasMore = Map<TalentCategory, bool>.from(state.hasMoreData);

    pages[category] = 1;
    hasMore[category] = true; // هنا المهم - تأكد ان hasMore يرجع true

    print("🔄 Reset pagination for $category - hasMore: ${hasMore[category]}");

    emit(state.copyWith(
      currentPages: pages,
      hasMoreData: hasMore,
    ));
  }

  // Profile search functionality
  void searchProfiles(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(
        searchProfileResults: [],
        isSearchingProfiles: false,
      ));
      return;
    }

    emit(state.copyWith(isSearchingProfiles: true));

    final response = await _searchProfilesUseCase(
      SearchProfileParams(
        query: query,
        page: 1,
        limit: StarConstants.searchLimit,
      ),
    );

    response.fold(
      (failure) {
        _showErrorMessage(failure);
        emit(state.copyWith(
          isSearchingProfiles: false,
          status: StarStates.error,
          failure: failure,
        ));
      },
      (profiles) {
        emit(state.copyWith(
          searchProfileResults: profiles,
          isSearchingProfiles: false,
          status: StarStates.success,
        ));
      },
    );
  }

  void clearProfileSearch() {
    emit(state.copyWith(
      searchProfileResults: [],
      isSearchingProfiles: false,
    ));
  }

  void _handleError(TalentCategory category, dynamic error) {
    final loadingStates = Map<TalentCategory, bool>.from(state.loadingStates);
    loadingStates[category] = false;

    emit(state.copyWith(
      loadingStates: loadingStates,
      status: StarStates.error,
      failure: error is Failure ? error : null,
    ));

    _showErrorMessage(error);
  }

  // Favorites management
  Future<void> toggleFavorite(String talentId) async {
    await toggleTubeFavorite(talentId);
  }

  bool isFavorite(String talentId) {
    return state.favoriteIds.contains(talentId);
  }

  // Watch Later management
  Future<void> toggleWatchLater(String talentId) async {
    await toggleTubeWatchLater(talentId);
  }

  bool isWatchLater(String talentId) {
    return state.watchLaterIds.contains(talentId);
  }

  // Search functionality
  void searchTalents(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(searchQuery: '', searchResults: []));
      return;
    }

    final searchResults = state.availableTalents.where((talent) {
      return talent.title.toLowerCase().contains(query.toLowerCase()) ||
          talent.user.firstName.toLowerCase().contains(query.toLowerCase()) ||
          talent.user.lastName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      searchResults: searchResults,
    ));
  }

  // Delete talent with proper data cleanup
  // Future<void> deleteMyTalent({required String id}) async {
  //   emit(state.copyWith(status: StarStates.loading));

  //   final response = await _deleteMyTalentUseCase(id);

  //   response.fold(
  //     (failure) {
  //       _showErrorMessage(failure);
  //       emit(state.copyWith(failure: failure, status: StarStates.error));
  //     },
  //     (data) {
  //       // Remove from all relevant lists
  //       final talents =
  //           Map<TalentCategory, List<StarEntity>>.from(state.talents);
  //       final favoriteIds = Set<String>.from(state.favoriteIds);

  //       for (final category in TalentCategory.values) {
  //         talents[category] =
  //             talents[category]?.where((talent) => talent.id != id).toList() ??
  //                 [];
  //       }

  //       favoriteIds.remove(id);

  //       emit(state.copyWith(
  //         talents: talents,
  //         favoriteIds: favoriteIds,
  //         status: StarStates.success,
  //       ));
  //     },
  //   );
  // }

  // Rating management - Updated to track rated videos but keep them visible
  void updateRating(String id, int rating) {
    final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);
    final ratedVideos = Set<String>.from(state.ratedVideos);

    // Update the rating in all categories
    for (final category in TalentCategory.values) {
      talents[category] = talents[category]?.map((talent) {
            if (talent.id == id) {
              return talent.copyWith(
                averageRating: rating.toDouble(),
              );
            }
            return talent;
          }).toList() ??
          [];
    }

    // Add to rated videos set to track that user has rated this video
    ratedVideos.add(id);

    emit(state.copyWith(
      talents: talents,
      ratedVideos: ratedVideos,
    ));

    // Show success message with rating count
    showRatingSuccessMessage(rating);
  }

  // Helper method to check if a video has been rated by the user
  bool isVideoRated(String videoId) {
    return state.ratedVideos.contains(videoId);
  }

  // Show rating success message
  void showRatingSuccessMessage(int rating) {
    // This will be handled by the UI layer to show snack bar with rating count
    emit(state.copyWith(
      status: StarStates.ratingSuccess,
      successMessage:
          rating.toString(), // Pass rating as string to be formatted in UI
    ));

    // Reset status after a short delay
    Future.delayed(Duration(milliseconds: 100), () {
      if (!isClosed) {
        emit(state.copyWith(
          status: StarStates.loaded,
          successMessage: null,
        ));
      }
    });
  }

  // New method to fetch videos for a specific user
  Future<List<StarEntity>> fetchUserVideos(String userId) async {
    print("🎯 Fetching videos for user: $userId");

    if (_useTubeVideoAPI) {
      // يمكن إضافة API endpoint مخصص لفيديوهات المستخدم
      // مثلاً: /api/v1/tube-video/user/{userId}

      // للوقت الحالي، نفلتر من الفيديوهات المتاحة
      final allVideos = state.availableTalents;
      final userVideos =
          allVideos.where((video) => video.user.id == userId).toList();

      print("✅ Found ${userVideos.length} videos for user $userId");
      return userVideos;
    } else {
      // استخدام old Star API إذا لزم الأمر
      return [];
    }
  }

  // Method to get user videos and update state
  Future<void> loadUserVideos(String userId, {bool refresh = false}) async {
    print("📱 Loading videos for user: $userId");

    // You can create a new category for user videos if needed
    // or store them temporarily

    try {
      final userVideos = await fetchUserVideos(userId);

      // For now, we can return the videos without storing in state
      // In the future, you might want to add a new category like:
      // final talents = Map<TalentCategory, List<StarEntity>>.from(state.talents);
      // talents[TalentCategory.userVideos] = userVideos;

      print(
          "✅ Successfully loaded ${userVideos.length} videos for user $userId");
    } catch (e) {
      print("❌ Error loading user videos: $e");
      rethrow;
    }
  }

  // Banner management
  Future<void> _fetchBanner() async {
    final response = await _bannerUseCase(const NoParams());

    response.fold(
      (failure) => _showErrorMessage(failure),
      (data) => emit(state.copyWith(banner: data)),
    );
  }

  // Method to get video by ID from current state
  TubeVideoModel? getVideoById(String videoId) {
    for (final category in TalentCategory.values) {
      final categoryTalents = state.talents[category];
      if (categoryTalents != null) {
        for (final talent in categoryTalents) {
          if (talent.id == videoId && talent is TubeVideoModel) {
            return talent;
          }
        }
      }
    }
    return null;
  }

  // Check if video is liked/disliked
  bool isVideoLiked(String videoId) {
    final video = getVideoById(videoId);
    if (video is TubeVideoModel) {
      return video.isLike;
    }
    return false;
  }

  bool isVideoDisliked(String videoId) {
    final video = getVideoById(videoId);
    if (video is TubeVideoModel) {
      return video.isDislike;
    }
    return false;
  }

  // Helper methods for the new like/dislike logic
  TubeVideoModel? _findVideoById(String videoId) {
    return getVideoById(videoId);
  }

  bool _isVideoLikedByCurrentUser(String videoId) {
    // For now, we'll use the simple counter approach
    // In future, you might want to track user-specific like status
    return isVideoLiked(videoId);
  }

  bool _isVideoDislikedByCurrentUser(String videoId) {
    // For now, we'll use the simple counter approach
    // In future, you might want to track user-specific dislike status
    return isVideoDisliked(videoId);
  }

// Bulk operations for video management
  Future<void> deleteMultipleVideos(List<String> videoIds) async {
    emit(state.copyWith(status: StarStates.loading));

    int successCount = 0;
    int failureCount = 0;

    for (final videoId in videoIds) {
      final response = await _deleteTubeVideoUseCase(videoId);

      response.fold(
        (failure) => failureCount++,
        (success) {
          if (success) {
            successCount++;
            _removeVideoFromState(videoId);
          } else {
            failureCount++;
          }
        },
      );
    }

    // Show result message
    final currentContext =
        AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext != null) {
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(
          content: Text(
            'Deleted $successCount videos successfully. $failureCount failed.',
          ),
          backgroundColor: failureCount == 0 ? Colors.green : Colors.orange,
        ),
      );
    }

    emit(state.copyWith(status: StarStates.success));
  }

// Search in my videos
  List<StarEntity> searchMyVideos(String query) {
    if (query.isEmpty) return state.myTalents;

    return state.myTalents.where((talent) {
      return talent.title.toLowerCase().contains(query.toLowerCase()) ||
          talent.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void _showErrorMessage(dynamic error) {
    final currentContext =
        AppPages.router.configuration.navigatorKey.currentContext;
    if (currentContext != null) {
      showErrorMessage(
        currentContext,
        getFailureMessage(error, currentContext),
      );
    }
  }

  // Helper methods for backward compatibility
  List<StarEntity> get allTalents => state.availableTalents;
  List<StarEntity> get favoriteTalents => state.favoriteTalents;
  Set<String> get favoriteIds => state.favoriteIds;
  List<StarEntity> get watchLaterTalents => state.watchLaterTalents;
  Set<String> get watchLaterIds => state.watchLaterIds;
}
