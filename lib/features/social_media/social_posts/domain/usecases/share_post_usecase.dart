import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/repositories/social_posts_repo.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class SharePostUseCase extends UseCase<bool, SharePostParams> {
  final SocialPostsRepo _repo;
  SharePostUseCase(this._repo);
  @override
  // Future<Either<Failure, bool>> call(String params) async {
  //   return await _repo.sharePost(postId: params);
  // }
  Future<Either<Failure, bool>> call(SharePostParams params) async {
    return await _repo.sharePost(params: params);
  }
}

class SharePostParams {
  final String postId;
  final String content;

  SharePostParams({required this.postId, required this.content});

  Map<String, dynamic> toJson() => {"content": content};
}
