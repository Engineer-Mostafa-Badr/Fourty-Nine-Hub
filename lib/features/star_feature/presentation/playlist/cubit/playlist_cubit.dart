import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

import '../../../../../core/messages/messages.dart';
import '../../../../../routes/pages.dart';
import '../../../domain/entity/playlist_entity.dart';
import '../../../domain/use_case/playlist_use_cases.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final GetPlaylistsUseCase _getPlaylistsUseCase;
  final CreatePlaylistUseCase _createPlaylistUseCase;
  final GetPlaylistByIdUseCase _getPlaylistByIdUseCase;
  final GetPlaylistWithVideosUseCase _getPlaylistWithVideosUseCase; // NEW
  final AddVideoToPlaylistUseCase _addVideoToPlaylistUseCase;
  final RemoveVideoFromPlaylistUseCase _removeVideoFromPlaylistUseCase;
  final DeletePlaylistUseCase _deletePlaylistUseCase;
  final UpdatePlaylistUseCase _updatePlaylistUseCase;

  PlaylistCubit(
    this._getPlaylistsUseCase,
    this._createPlaylistUseCase,
    this._getPlaylistByIdUseCase,
    this._getPlaylistWithVideosUseCase, // NEW
    this._addVideoToPlaylistUseCase,
    this._removeVideoFromPlaylistUseCase,
    this._deletePlaylistUseCase,
    this._updatePlaylistUseCase,
  ) : super(const PlaylistState());

  // Get current user ID from UserCubit
  String? get _currentUserId {
    try {
      return UserCubit.to.state.data?.id;
    } catch (e) {
      print('Error getting current user ID: $e');
      return null;
    }
  }

  // Get playlists for a specific user
  Future<void> getPlaylists(String ownerId, {bool refresh = false}) async {
    if (refresh || state.playlists.isEmpty) {
      emit(state.copyWith(status: PlaylistStatus.loading));
    }

    // Validate ownerId format
    if (ownerId.isEmpty || ownerId.length != 24) {
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('Invalid user ID format'),
      ));
      return;
    }

    final params = GetPlaylistsParams(
      ownerId: ownerId,
      page: refresh ? 1 : state.currentPage,
      limit: 10,
    );

    print('🎵 Loading playlists for user: $ownerId');

    final result = await _getPlaylistsUseCase(params);

    result.fold(
      (failure) {
        print('❌ Failed to load playlists: $failure');
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
      },
      (response) {
        print('✅ Loaded ${response.playlists.length} playlists');
        final List<PlaylistEntity> newPlaylists = refresh
            ? response.playlists
            : [...state.playlists, ...response.playlists];

        emit(state.copyWith(
          status: PlaylistStatus.success,
          playlists: newPlaylists,
          currentPage: response.pagination.page,
          hasMore: response.pagination.page < response.pagination.pages,
          failure: null,
        ));
      },
    );
  }

  // Get current user's playlists
  Future<void> getMyPlaylists({bool refresh = false}) async {
    final currentUserId = _currentUserId;

    if (currentUserId == null || currentUserId.isEmpty) {
      print('❌ Cannot load playlists: No current user ID available');
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('User not authenticated'),
      ));
      return;
    }

    print('🎵 Loading my playlists for user: $currentUserId');
    await getPlaylists(currentUserId, refresh: refresh);
  }

  // Create new playlist
  Future<bool> createPlaylist({
    required String name,
    required String description,
    String? thumbnailMediaId,
  }) async {
    final currentUserId = _currentUserId;

    if (currentUserId == null || currentUserId.isEmpty) {
      print('❌ Cannot create playlist: No current user ID available');
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('User not authenticated'),
      ));
      return false;
    }

    emit(state.copyWith(status: PlaylistStatus.creating));

    final params = CreatePlaylistParams(
      name: name,
      description: description,
      thumbnailMediaId: thumbnailMediaId ?? '',
    );

    print('🎵 Creating playlist: $name');
    print('🖼️ Thumbnail ID: ${thumbnailMediaId ?? 'none'}');

    final result = await _createPlaylistUseCase(params);

    return result.fold(
      (failure) {
        print('❌ Failed to create playlist: $failure');
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
        return false;
      },
      (message) {
        print('✅ Playlist created successfully');
        emit(state.copyWith(status: PlaylistStatus.success));
        // Refresh playlists after creating
        getMyPlaylists(refresh: true);
        return true;
      },
    );
  }

  // Get playlist details by ID (basic info only)
  Future<void> getPlaylistDetails(String playlistId) async {
    if (playlistId.isEmpty || playlistId.length != 24) {
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('Invalid playlist ID format'),
      ));
      return;
    }

    emit(state.copyWith(status: PlaylistStatus.loading));

    final result = await _getPlaylistByIdUseCase(playlistId);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
      },
      (playlist) {
        emit(state.copyWith(
          status: PlaylistStatus.success,
          selectedPlaylist: playlist,
          failure: null,
        ));
      },
    );
  }

  // NEW METHOD: Get playlist with full video details
  Future<void> getPlaylistWithVideos(String playlistId) async {
    if (playlistId.isEmpty || playlistId.length != 24) {
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('Invalid playlist ID format'),
      ));
      return;
    }

    print('🎵 Loading playlist with videos: $playlistId');
    emit(state.copyWith(status: PlaylistStatus.loading));

    final result = await _getPlaylistWithVideosUseCase(playlistId);

    result.fold(
      (failure) {
        print('❌ Failed to load playlist with videos: $failure');
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
      },
      (playlist) {
        print('✅ Loaded playlist with ${playlist.videos.length} videos');
        emit(state.copyWith(
          status: PlaylistStatus.success,
          selectedPlaylist: playlist,
          failure: null,
        ));
      },
    );
  }

  // Add video to playlist
  Future<bool> addVideoToPlaylist(String playlistId, String videoId) async {
    // Validate IDs
    if (playlistId.isEmpty || playlistId.length != 24) {
      emit(state.copyWith(
        failure: UnknownFailure('Invalid playlist ID format'),
      ));
      return false;
    }

    if (videoId.isEmpty || videoId.length != 24) {
      emit(state.copyWith(
        failure: UnknownFailure('Invalid video ID format'),
      ));
      return false;
    }

    final params = PlaylistVideoParams(
      playlistId: playlistId,
      videoId: videoId,
    );

    print('🎵 Adding video $videoId to playlist $playlistId');

    final result = await _addVideoToPlaylistUseCase(params);

    return result.fold(
      (failure) {
        print('❌ Failed to add video to playlist: $failure');
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure));
        return false;
      },
      (message) {
        print('✅ Video added to playlist successfully');
        // Update local state
        _updatePlaylistAfterVideoAction(playlistId, videoId, true);

        // If we have the selected playlist loaded with videos, refresh it
        if (state.selectedPlaylist != null &&
            state.selectedPlaylist!.id == playlistId) {
          getPlaylistWithVideos(playlistId);
        }

        return true;
      },
    );
  }

  // Remove video from playlist
  Future<bool> removeVideoFromPlaylist(
      String playlistId, String videoId) async {
    // Validate IDs
    if (playlistId.isEmpty || playlistId.length != 24) {
      emit(state.copyWith(
        failure: UnknownFailure('Invalid playlist ID format'),
      ));
      return false;
    }

    if (videoId.isEmpty || videoId.length != 24) {
      emit(state.copyWith(
        failure: UnknownFailure('Invalid video ID format'),
      ));
      return false;
    }

    final params = PlaylistVideoParams(
      playlistId: playlistId,
      videoId: videoId,
    );

    print('🗑️ Removing video $videoId from playlist $playlistId');

    final result = await _removeVideoFromPlaylistUseCase(params);

    return result.fold(
      (failure) {
        print('❌ Failed to remove video from playlist: $failure');
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure));
        return false;
      },
      (message) {
        print('✅ Video removed from playlist successfully');
        // Update local state
        _updatePlaylistAfterVideoAction(playlistId, videoId, false);

        // If we have the selected playlist loaded with videos, refresh it
        if (state.selectedPlaylist != null &&
            state.selectedPlaylist!.id == playlistId) {
          getPlaylistWithVideos(playlistId);
        }

        return true;
      },
    );
  }

  // Delete playlist
  Future<bool> deletePlaylist(String playlistId) async {
    if (playlistId.isEmpty || playlistId.length != 24) {
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('Invalid playlist ID format'),
      ));
      return false;
    }

    emit(state.copyWith(status: PlaylistStatus.deleting));

    final result = await _deletePlaylistUseCase(playlistId);

    return result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
        return false;
      },
      (message) {
        // Remove from local state
        final updatedPlaylists = state.playlists
            .where((playlist) => playlist.id != playlistId)
            .toList();

        emit(state.copyWith(
          status: PlaylistStatus.success,
          playlists: updatedPlaylists,
          selectedPlaylist: state.selectedPlaylist?.id == playlistId
              ? null
              : state.selectedPlaylist,
          failure: null,
        ));
        return true;
      },
    );
  }

  // Update playlist
  Future<bool> updatePlaylist({
    required String playlistId,
    String? name,
    String? description,
    String? thumbnailMediaId,
  }) async {
    if (playlistId.isEmpty || playlistId.length != 24) {
      emit(state.copyWith(
        status: PlaylistStatus.error,
        failure: UnknownFailure('Invalid playlist ID format'),
      ));
      return false;
    }

    emit(state.copyWith(status: PlaylistStatus.updating));

    final params = PlaylistParams(
      playlistId: playlistId,
      name: name,
      description: description,
      thumbnailMediaId: thumbnailMediaId,
    );

    final result = await _updatePlaylistUseCase(params);

    return result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
        return false;
      },
      (message) {
        emit(state.copyWith(status: PlaylistStatus.success));
        // Refresh to get updated data
        getMyPlaylists(refresh: true);

        // If this is the selected playlist, refresh it too
        if (state.selectedPlaylist?.id == playlistId) {
          getPlaylistWithVideos(playlistId);
        }

        return true;
      },
    );
  }

  // Helper method to update playlist after video action
  void _updatePlaylistAfterVideoAction(
      String playlistId, String videoId, bool isAdding) {
    final updatedPlaylists = state.playlists.map((playlist) {
      if (playlist.id == playlistId) {
        final newVideosCount = isAdding
            ? playlist.videosCount + 1
            : (playlist.videosCount - 1).clamp(0, double.infinity).toInt();

        return playlist.copyWith(videosCount: newVideosCount);
      }
      return playlist;
    }).toList();

    emit(state.copyWith(playlists: updatedPlaylists));
  }

  // Clear selected playlist
  void clearSelectedPlaylist() {
    emit(state.copyWith(selectedPlaylist: null));
  }

  // Clear error
  void clearError() {
    emit(state.copyWith(failure: null));
  }

  // Reset state
  void reset() {
    emit(const PlaylistState());
  }

  // Check if current user is authenticated
  bool get isAuthenticated {
    final userId = _currentUserId;
    return userId != null && userId.isNotEmpty && userId.length == 24;
  }

  // Get current user info
  String get currentUserInfo {
    final userId = _currentUserId;
    if (userId == null) return 'Not authenticated';
    if (userId.length != 24) return 'Invalid user ID format';
    return 'User ID: ${userId.substring(0, 8)}...';
  }
}
