import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetInstagramUserMediaUseCase
    extends UseCase<List<PostEntity>, InstagramUserMediaParams> {
  final InstagramRepo _repo;
  GetInstagramUserMediaUseCase(this._repo);
  @override
  Future<Either<Failure, List<PostEntity>>> call(
      InstagramUserMediaParams params) async {
    return await _repo.getUserMedia(params: params);
  }
}

class InstagramUserMediaParams {
  final int page;
  final int limit;
  final String userId;
  InstagramUserMediaParams({
    required this.page,
    required this.limit,
    required this.userId,
  });
  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        // 'subCategory':'66b77e77bb35968b535dc944'
      };
}
