import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../../domain/entity/playlist_entity.dart';
import '../../domain/repository/playlist_repository.dart';
import '../data_source/playlist_remote_data_source.dart';

class PlaylistRepositoryImpl implements PlaylistRepository {
  final PlaylistRemoteDataSource remoteDataSource;

  PlaylistRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createPlaylist(CreatePlaylistParams params) async {
    try {
      final result = await remoteDataSource.createPlaylist(params);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlaylistListResponse>> getPlaylists(GetPlaylistsParams params) async {
    try {
      final result = await remoteDataSource.getPlaylists(params);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PlaylistEntity>> getPlaylistById(String playlistId) async {
    try {
      final result = await remoteDataSource.getPlaylistById(playlistId);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addVideoToPlaylist(PlaylistVideoParams params) async {
    try {
      final result = await remoteDataSource.addVideoToPlaylist(params);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> removeVideoFromPlaylist(PlaylistVideoParams params) async {
    try {
      final result = await remoteDataSource.removeVideoFromPlaylist(params);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deletePlaylist(String playlistId) async {
    try {
      final result = await remoteDataSource.deletePlaylist(playlistId);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updatePlaylist(UpdatePlaylistParams params) async {
    try {
      final result = await remoteDataSource.updatePlaylist(params);
      return Right(result);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(UnknownFailure(e.toString()));
    }
  }
}