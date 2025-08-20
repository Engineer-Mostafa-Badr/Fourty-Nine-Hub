import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/song_entity.dart';

import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetForYouSongsUseCase {
  final InstagramRepo repository;

  GetForYouSongsUseCase({ required this.repository});

  Future<Either<Failure, List<SongEntity>>> call({required SongsPaginationParams params}) async => await repository.getForYouSongs(params: params);
}

class SongsPaginationParams {
  final int page;
  final int limit;

  SongsPaginationParams({required this.page, required this.limit});
}