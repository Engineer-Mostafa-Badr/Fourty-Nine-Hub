import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/repositories/social_posts_repo.dart';

import '../../../../../core/error/failure.dart';

class AddRemoveSongsFromFavsUseCase {
  final InstagramRepo instagramRepo;

  AddRemoveSongsFromFavsUseCase({required this.instagramRepo});

  Future<Either<Failure, bool>> call({required String songId}) => instagramRepo.addRemoveSongsFromFavs(songId: songId);
}