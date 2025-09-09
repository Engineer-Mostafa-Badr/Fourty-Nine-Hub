import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import '../entity/playlist_entity.dart';
import '../repository/playlist_repository.dart';


/// Use Case for getting playlist with full video details
/// This is different from GetPlaylistByIdUseCase which only gets basic playlist info
class GetPlaylistWithVideosUseCase extends UseCase<PlaylistEntity, String> {
  final PlaylistRepository _repository;

  GetPlaylistWithVideosUseCase(this._repository);

  @override
  Future<Either<Failure, PlaylistEntity>> call(String playlistId) async {
    print('📥 UseCase: Getting playlist with videos: $playlistId');
    
    // Validate playlist ID
    if (playlistId.isEmpty) {
      print('❌ UseCase: Empty playlist ID');
      return Left(ValidationFailure('Playlist ID cannot be empty'));
    }
    
    if (playlistId.length != 24) {
      print('❌ UseCase: Invalid playlist ID format: $playlistId');
      return Left(ValidationFailure('Invalid playlist ID format'));
    }

    try {
      final result = await _repository.getPlaylistWithVideos(playlistId);
      
      return result.fold(
        (failure) {
          print('❌ UseCase: Repository returned failure: $failure');
          return Left(failure);
        },
        (playlist) {
          print('✅ UseCase: Successfully got playlist with ${playlist.videos.length} videos');
          return Right(playlist);
        },
      );
    } catch (e) {
      print('❌ UseCase: Unexpected error: $e');
      return Left(UnknownFailure('Unexpected error: $e'));
    }
  }
}

/// Custom failure for validation errors
class ValidationFailure extends Failure {
  final String message;
  
  const ValidationFailure(this.message);
  
  @override
  String toString() => 'ValidationFailure: $message';
  
  @override
  List<Object?> get props => [message];
}