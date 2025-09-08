import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../entity/playlist_entity.dart';
import '../repository/playlist_repository.dart';

// Create Playlist Use Case
class CreatePlaylistUseCase extends UseCase<String, CreatePlaylistParams> {
  final PlaylistRepository _repository;

  CreatePlaylistUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(CreatePlaylistParams params) async {
    return await _repository.createPlaylist(params);
  }
}

// Get Playlists Use Case
class GetPlaylistsUseCase extends UseCase<PlaylistListResponse, GetPlaylistsParams> {
  final PlaylistRepository _repository;

  GetPlaylistsUseCase(this._repository);

  @override
  Future<Either<Failure, PlaylistListResponse>> call(GetPlaylistsParams params) async {
    return await _repository.getPlaylists(params);
  }
}

// Get Playlist By ID Use Case
class GetPlaylistByIdUseCase extends UseCase<PlaylistEntity, String> {
  final PlaylistRepository _repository;

  GetPlaylistByIdUseCase(this._repository);

  @override
  Future<Either<Failure, PlaylistEntity>> call(String playlistId) async {
    return await _repository.getPlaylistById(playlistId);
  }
}

// Add Video to Playlist Use Case
class AddVideoToPlaylistUseCase extends UseCase<String, PlaylistVideoParams> {
  final PlaylistRepository _repository;

  AddVideoToPlaylistUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(PlaylistVideoParams params) async {
    return await _repository.addVideoToPlaylist(params);
  }
}

// Remove Video from Playlist Use Case
class RemoveVideoFromPlaylistUseCase extends UseCase<String, PlaylistVideoParams> {
  final PlaylistRepository _repository;

  RemoveVideoFromPlaylistUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(PlaylistVideoParams params) async {
    return await _repository.removeVideoFromPlaylist(params);
  }
}

// Delete Playlist Use Case
class DeletePlaylistUseCase extends UseCase<String, String> {
  final PlaylistRepository _repository;

  DeletePlaylistUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String playlistId) async {
    return await _repository.deletePlaylist(playlistId);
  }
}

// Update Playlist Use Case
class UpdatePlaylistUseCase extends UseCase<String, UpdatePlaylistParams> {
  final PlaylistRepository _repository;

  UpdatePlaylistUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(UpdatePlaylistParams params) async {
    return await _repository.updatePlaylist(params);
  }
}