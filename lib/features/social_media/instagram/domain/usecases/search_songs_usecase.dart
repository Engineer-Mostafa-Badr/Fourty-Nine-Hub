import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/repositories/social_posts_repo.dart';

import '../../../../../core/error/failure.dart';
import '../entities/song_entity.dart';

class SearchSongsUseCase {
  final InstagramRepo instagramRepo;

  SearchSongsUseCase({required this.instagramRepo});

  Future<Either<Failure, List<SongEntity>>> call({required String query}) => instagramRepo.searchSongs(query: query);
}