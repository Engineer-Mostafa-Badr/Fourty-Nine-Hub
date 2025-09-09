import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../entity/playlist_entity.dart';

abstract class PlaylistRepository {
  /// Create a new playlist
  Future<Either<Failure, String>> createPlaylist(CreatePlaylistParams params);

  /// Get all playlists for a specific owner with pagination
  Future<Either<Failure, PlaylistListResponse>> getPlaylists(
      GetPlaylistsParams params);

  /// Get playlist details by ID (basic info only)
  Future<Either<Failure, PlaylistEntity>> getPlaylistById(String playlistId);

  /// Get playlist with full video details (NEW METHOD)
  Future<Either<Failure, PlaylistEntity>> getPlaylistWithVideos(
      String playlistId);

  /// Add video to playlist
  Future<Either<Failure, String>> addVideoToPlaylist(
      PlaylistVideoParams params);

  /// Remove video from playlist
  Future<Either<Failure, String>> removeVideoFromPlaylist(
      PlaylistVideoParams params);

  /// Delete playlist
  Future<Either<Failure, String>> deletePlaylist(String playlistId);

  /// Update playlist info (name, description, thumbnail)
  Future<Either<Failure, String>> updatePlaylist(PlaylistParams params);
}

// Response model for playlist list with pagination
class PlaylistListResponse {
  final List<PlaylistEntity> playlists;
  final PlaylistPaginationModel pagination;

  PlaylistListResponse({
    required this.playlists,
    required this.pagination,
  });
}

// Pagination model for playlists
class PlaylistPaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PlaylistPaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });
}
