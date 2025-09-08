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
  Future<String> addVideoToPlaylist(PlaylistVideoParams params);
  Future<String> removeVideoFromPlaylist(PlaylistVideoParams params);
  Future<String> deletePlaylist(String playlistId);
  Future<String> updatePlaylist(UpdatePlaylistParams params);
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
  Future<PlaylistListResponseModel> getPlaylists(GetPlaylistsParams params) async {
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
        // Parse the single playlist response
        final playlistData = data['data'] as Map<String, dynamic>;
        return PlaylistModel.fromJson(playlistData);
      },
    );
  }

  @override
  Future<String> addVideoToPlaylist(PlaylistVideoParams params) async {
    final response = await apiConsumer.post(
      EndPoints.addVideoToPlaylist(params.playlistId),
      data: params.toJson(),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String? ?? 'Video added to playlist successfully',
    );
  }

  @override
  Future<String> removeVideoFromPlaylist(PlaylistVideoParams params) async {
    final response = await apiConsumer.delete(
      EndPoints.removeVideoFromPlaylist(params.playlistId),
      data: params.toJson(),
    );

    return response.fold(
      (failure) => throw failure,
      (data) => data['message'] as String? ?? 'Video removed from playlist successfully',
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
  Future<String> updatePlaylist(UpdatePlaylistParams params) async {
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