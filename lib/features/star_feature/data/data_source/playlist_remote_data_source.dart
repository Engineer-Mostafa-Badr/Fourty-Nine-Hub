import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../domain/entity/playlist_entity.dart';
import '../../domain/repository/playlist_repository.dart';
import '../model/playlist_model.dart';

abstract class PlaylistRemoteDataSource {
  Future<String> createPlaylist(CreatePlaylistParams params);
  Future<PlaylistListResponseModel> getPlaylists(GetPlaylistsParams params);
  Future<PlaylistModel> getPlaylistById(String playlistId);
  Future<PlaylistModel> getPlaylistWithVideos(String playlistId); // New method
  Future<String> addVideoToPlaylist(PlaylistVideoParams params);
  Future<String> removeVideoFromPlaylist(PlaylistVideoParams params);
  Future<String> deletePlaylist(String playlistId);
  Future<String> updatePlaylist(PlaylistParams params);
}

class PlaylistRemoteDataSourceImpl implements PlaylistRemoteDataSource {
  final ApiConsumer apiConsumer;

  PlaylistRemoteDataSourceImpl(this.apiConsumer);

  @override
  Future<String> createPlaylist(CreatePlaylistParams params) async {
    final response = await apiConsumer.post(
      EndPoints.createPlaylist,
      data: params.toJson(),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String? ?? 'Playlist created successfully',
    );
  }

  @override
  Future<PlaylistListResponseModel> getPlaylists(
      GetPlaylistsParams params) async {
    final response = await apiConsumer.get(
      EndPoints.getPlaylists(params.ownerId),
      queryParameters: {
        'page': params.page,
        'limit': params.limit,
      },
    );

    return response.fold(
      (failure) => throw failure,
      (data) => PlaylistListResponseModel.fromJson(data),
    );
  }

  @override
  Future<PlaylistModel> getPlaylistById(String playlistId) async {
    final response = await apiConsumer.get(
      EndPoints.getPlaylistById(playlistId),
    );

    return response.fold(
      (failure) => throw failure,
      (data) {
        final playlistData = data['data'] as Map<String, dynamic>;
        return PlaylistModel.fromJson(playlistData);
      },
    );
  }

  @override
  Future<PlaylistModel> getPlaylistWithVideos(String playlistId) async {
    print('🎵 Fetching playlist with videos: $playlistId');

    final response = await apiConsumer.get(
      EndPoints.getPlaylistWithVideos(playlistId),
    );

    return response.fold(
      (failure) {
        print('❌ Failed to fetch playlist with videos: $failure');
        throw failure;
      },
      (data) {
        print('✅ Successfully fetched playlist with videos');
        print('📊 Response data keys: ${data.keys.toList()}');

        try {
          final playlistData = data['data'] as Map<String, dynamic>;
          final playlist = PlaylistModel.fromJson(playlistData);

          print('🎵 Parsed playlist: ${playlist.name}');
          print('📹 Videos count: ${playlist.videos.length}');

          return playlist;
        } catch (e, stackTrace) {
          print('❌ Error parsing playlist with videos: $e');
          print('❌ Stack trace: $stackTrace');
          throw ServerFailure(
            message: 'Failed to parse playlist data: $e',
            name: 'Parse Error',
          );
        }
      },
    );
  }

  @override
  Future<String> addVideoToPlaylist(PlaylistVideoParams params) async {
    print('🎵 Adding video ${params.videoId} to playlist ${params.playlistId}');

    final response = await apiConsumer.post(
      EndPoints.addVideoToPlaylist(params.playlistId),
      data: params.toJson(),
    );

    return response.fold(
      (failure) {
        print('❌ Failed to add video to playlist: $failure');
        throw failure;
      },
      (data) {
        print('✅ Successfully added video to playlist');
        return data['message'] as String? ??
            'Video added to playlist successfully';
      },
    );
  }

  @override
  Future<String> removeVideoFromPlaylist(PlaylistVideoParams params) async {
    print(
        '🗑️ Removing video ${params.videoId} from playlist ${params.playlistId}');

    final response = await apiConsumer.delete(
      EndPoints.removeVideoFromPlaylist(params.playlistId),
      data: params.toJson(),
    );

    return response.fold(
      (failure) {
        print('❌ Failed to remove video from playlist: $failure');
        throw failure;
      },
      (data) {
        print('✅ Successfully removed video from playlist');
        return data['message'] as String? ??
            'Video removed from playlist successfully';
      },
    );
  }

  @override
  Future<String> deletePlaylist(String playlistId) async {
    final response = await apiConsumer.delete(
      EndPoints.deletePlaylist(playlistId),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String? ?? 'Playlist deleted successfully',
    );
  }

  @override
  Future<String> updatePlaylist(PlaylistParams params) async {
    final response = await apiConsumer.put(
      EndPoints.updatePlaylist(params.playlistId),
      data: params.toJson(),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String? ?? 'Playlist updated successfully',
    );
  }
}
