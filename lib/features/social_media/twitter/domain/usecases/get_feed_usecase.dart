import 'package:dartz/dartz.dart';
import '../../presentation/bloc/twitter_bloc.dart';
import '../entities/twitter_post_comment_entity.dart';
import '../entities/twitter_post_entity.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/twitter_repo.dart';

class GetTwitterFeedUseCase
    extends UseCase<List<TwitterPostEntity>, TwitterFeedParams> {
  final TwitterRepo _repo;
  GetTwitterFeedUseCase(this._repo);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> call(
      TwitterFeedParams params) async {
    return await _repo.getFeed(params: params);
  }
}

class TwitterFeedParams {
  final int page;
  final int limit;
  String? search;
  String? otherId;
  TwitterFeedParams(
      {required this.page, required this.limit, this.search, this.otherId});
  Map<String, dynamic> toJson() => {
        'page': page,
        'limit': limit,
        'otherId': limit,
        // 'subCategory':'66b77e77bb35968b535dc944'
      };
}
// usecases/get_thread_posts_page_usecase.dart
class GetThreadPostsPageUseCase
    extends UseCase<TwitterPage<TwitterPostEntity>, ThreadPageParams> {
  final TwitterRepo _repo;
  GetThreadPostsPageUseCase(this._repo);

  @override
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> call(ThreadPageParams p) {
    return _repo.getThreadPostsPage(threadId: p.threadId, page: p.page, limit: p.limit);
  }
}

// usecases/get_thread_replies_page_usecase.dart
class GetThreadRepliesPageUseCase
    extends UseCase<TwitterPage<TwitterPostCommentEntity>, ThreadPageParams> {
  final TwitterRepo _repo;
  GetThreadRepliesPageUseCase(this._repo);

  @override
  Future<Either<Failure, TwitterPage<TwitterPostCommentEntity>>> call(ThreadPageParams p) {
    return _repo.getThreadRepliesPage(threadId: p.threadId, page: p.page, limit: p.limit);
  }
}

// params
class ThreadPageParams {
  final String threadId;
  final int page;
  final int limit;
  const ThreadPageParams({required this.threadId, required this.page, required this.limit});
}



class MyThreadsPageParams {
  final int page;
  final int limit;
  const MyThreadsPageParams({required this.page, required this.limit});
}

class GetMyThreadsPageUseCase {
  final TwitterRepo repo;
  GetMyThreadsPageUseCase(this.repo);

  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> call(
      MyThreadsPageParams params) {
    return repo.getMyPostsPage(page: params.page, limit: params.limit);
  }
}

class UserThreadsPageParams {
  final String userId;
  final int page;
  final int limit;
  const UserThreadsPageParams({
    required this.userId,
    required this.page,
    required this.limit,
  });
}

class GetUserThreadsPageUseCase {
  final TwitterRepo repo;
  GetUserThreadsPageUseCase(this.repo);

  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> call(
      UserThreadsPageParams params) {
    return repo.getUserPostsPage(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}
