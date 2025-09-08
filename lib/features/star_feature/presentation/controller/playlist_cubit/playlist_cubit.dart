import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../../domain/entity/playlist_entity.dart';
import '../../../domain/repository/playlist_repository.dart';
import '../../../domain/use_case/playlist_use_cases.dart';
import '../../utils/enums.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final GetPlaylistsUseCase _getPlaylistsUseCase;
  final CreatePlaylistUseCase _createPlaylistUseCase;
  final GetPlaylistByIdUseCase _getPlaylistByIdUseCase;
  final AddVideoToPlaylistUseCase _addVideoToPlaylistUseCase;
  final RemoveVideoFromPlaylistUseCase _removeVideoFromPlaylistUseCase;
  final DeletePlaylistUseCase _deletePlaylistUseCase;
  final UpdatePlaylistUseCase _updatePlaylistUseCase;

  PlaylistCubit(
    this._getPlaylistsUseCase,
    this._createPlaylistUseCase,
    this._getPlaylistByIdUseCase,
    this._addVideoToPlaylistUseCase,
    this._removeVideoFromPlaylistUseCase,
    this._deletePlaylistUseCase,
    this._updatePlaylistUseCase,
  ) : super(const PlaylistState());

  // Get playlists for a specific user
  Future<void> getPlaylists(String ownerId, {bool refresh = false}) async {
    if (refresh || state.playlists.isEmpty) {
      emit(state.copyWith(status: PlaylistStatus.loading));
    }

    final params = GetPlaylistsParams(
      ownerId: ownerId,
      page: refresh ? 1 : state.currentPage,
      limit: 10,
    );

    final result = await _getPlaylistsUseCase(params);

    result.fold(
      (failure) {
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
      },
      (response) {
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
    // TODO: Get current user ID from UserCubit or AuthService
    const String currentUserId =
        "current_user_id"; // Replace with actual user ID
    await getPlaylists(currentUserId, refresh: refresh);
  }

  // Create new playlist
  Future<bool> createPlaylist({
    required String name,
    required String description,
    String? thumbnailMediaId,
  }) async {
    emit(state.copyWith(status: PlaylistStatus.creating));

    final params = CreatePlaylistParams(
      name: name,
      description: description,
      thumbnailMediaId: thumbnailMediaId ?? '',
    );

    final result = await _createPlaylistUseCase(params);

    return result.fold(
      (failure) {
        emit(state.copyWith(
          status: PlaylistStatus.error,
          failure: failure,
        ));
        return false;
      },
      (message) {
        emit(state.copyWith(status: PlaylistStatus.success));
        // Refresh playlists after creating
        getMyPlaylists(refresh: true);
        return true;
      },
    );
  }

  // Get playlist details by ID
  Future<void> getPlaylistDetails(String playlistId) async {
    emit(state.copyWith(status: PlaylistStatus.loading));

    final result = await _getPlaylistByIdUseCase(playlistId);

    result.fold(
      (failure) {
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

  // Add video to playlist
  Future<bool> addVideoToPlaylist(String playlistId, String videoId) async {
    final params = PlaylistVideoParams(
      playlistId: playlistId,
      videoId: videoId,
    );

    final result = await _addVideoToPlaylistUseCase(params);

    return result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
        return false;
      },
      (message) {
        // Update local state
        _updatePlaylistAfterVideoAction(playlistId, videoId, true);
        return true;
      },
    );
  }

  // Remove video from playlist
  Future<bool> removeVideoFromPlaylist(
      String playlistId, String videoId) async {
    final params = PlaylistVideoParams(
      playlistId: playlistId,
      videoId: videoId,
    );

    final result = await _removeVideoFromPlaylistUseCase(params);

    return result.fold(
      (failure) {
        emit(state.copyWith(failure: failure));
        return false;
      },
      (message) {
        // Update local state
        _updatePlaylistAfterVideoAction(playlistId, videoId, false);
        return true;
      },
    );
  }

  // Delete playlist
  Future<bool> deletePlaylist(String playlistId) async {
    emit(state.copyWith(status: PlaylistStatus.deleting));

    final result = await _deletePlaylistUseCase(playlistId);

    return result.fold(
      (failure) {
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
    emit(state.copyWith(status: PlaylistStatus.updating));

    final params = UpdatePlaylistParams(
      playlistId: playlistId,
      name: name,
      description: description,
      thumbnailMediaId: thumbnailMediaId,
    );

    final result = await _updatePlaylistUseCase(params);

    return result.fold(
      (failure) {
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
}
