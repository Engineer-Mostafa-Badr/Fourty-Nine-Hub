import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/song_entity.dart';

import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';
import 'get_for_you_songs_usecase.dart';

class GetSavedSongsUseCase {
  final InstagramRepo repository;

  GetSavedSongsUseCase({ required this.repository});

  Future<Either<Failure, List<SongEntity>>> call({required SongsPaginationParams params}) async => await repository.getSavedSongs(params: params);
}