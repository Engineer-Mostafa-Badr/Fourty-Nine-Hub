import 'package:dartz/dartz.dart';
import '../../../../../core/data/datasources/remote/api/api_consumer.dart';
import '../../../../../core/data/datasources/remote/api/end_points.dart';
import '../../../social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../../presentation/bloc/twitter_bloc.dart';
import '../models/twitter_comment_reply_model.dart';
import '../models/twitter_post_comment_model.dart';
import '../models/twitter_post_model.dart';
import '../../domain/entities/twitter_comment_reply_entity.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/entities/twitter_post_entity.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/request_document_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';

import '../../../../../core/error/failure.dart';

abstract class TwitterRemoteDataSource {
  // FEED / POSTS
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed({
    required TwitterFeedParams params,
  });

  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getGlobalFeed({
    required TwitterFeedParams params,
  });

  Future<Either<Failure, TwitterPostEntity>> getTwitterPost({
    required String postId,
  });

  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts({
    required GetUserTweetsParams params,
  });

  // NEW: paginated endpoints
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getMyPostsPage({
    required int page,
    required int limit,
  });

  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getUserPostsPage({
    required String userId,
    required int page,
    required int limit,
  });

  // REACTIONS / SHARE / REPORT
  Future<Either<Failure, bool>> reactOnPost(
      {required TwitterPostReactParams params});
  Future<Either<Failure, bool>> getVerification();
  Future<Either<Failure, bool>> reactOnComment(
      {required TwitterCommentReactParams params});
  Future<Either<Failure, bool>> sharePost({required String params}); // postId
  Future<Either<Failure, bool>> addReport(
      {required TwitterReportParams params});

  // COMMENTS / REPLIES
  Future<Either<Failure, TwitterPostCommentEntity>> commentOnTwitterPost({
    required TwitterPostCommentParams params,
  });

  Future<Either<Failure, TwitterCommentReplyEntity>> replyOnComment({
    required TwitterCommentReplyParams params,
  });

  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments({
    required PostCommentsParams params,
  });

  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies({
    required PostCommentsParams params,
  });

  // THREAD PAGINATION
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getThreadPostsPage({
    required String threadId,
    required int page,
    required int limit,
  });

  Future<Either<Failure, TwitterPage<TwitterPostCommentEntity>>>
      getThreadRepliesPage({
    required String threadId,
    required int page,
    required int limit,
  });

  // DELETE / EDIT / HIDE
  Future<Either<Failure, bool>> deletePost({required String postId});
  Future<Either<Failure, bool>> hidePost({required String postId});
  Future<Either<Failure, bool>> deleteComment({required String commentId});
  Future<Either<Failure, bool>> editComment({
    required TwitterPostCommentParams params,
  });

  // VERIFICATION
  Future<Either<Failure, bool>> requestDocument({
    required TwitterDocumentationParams params,
  });

  // FOLLOW COUNTS
  Future<Either<Failure, int>> getFollowersCount(
      {required String subCategoryId});
  Future<Either<Failure, int>> getFollowingCount(
      {required String subCategoryId});

  Future<Either<Failure, String>> repostPost(String postId);
}

class TwitterRemoteDataSourceImpl implements TwitterRemoteDataSource {
  final ApiConsumer _apiConsumer;
  TwitterRemoteDataSourceImpl(this._apiConsumer);
  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getFeed(
      {required TwitterFeedParams params}) async {
    // final response = await _apiConsumer.get(
    //     "${EndPoints.getTwitterFeedPosts}?page=${params.page}&limit=${params.limit}&subCategory=66a3583454e6e337915514db");
    final uri = Uri.parse(EndPoints.getTwitterFeedPosts).replace(
      queryParameters: {
        'page': params.page.toString(),
        'limit': params.limit.toString(),
        'subCategory': '66a3583454e6e337915514db',
      },
    );

    final response = await _apiConsumer.get(uri.toString());

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => TwitterPostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getGlobalFeed({
    required TwitterFeedParams params,
  }) async {
    final uri = Uri.parse('/twitter/threads').replace(queryParameters: {
      'page': '${params.page}',
      'limit': '${params.limit}',
    });

    final response = await _apiConsumer.get(uri.toString());

    return response.fold(
      Left.new,
      (data) {
        final root = (data is Map<String, dynamic>) ? data : const {};
        final dataWrap =
            (root['data'] as Map?)?.cast<String, dynamic>() ?? const {};

        // posts
        final threads = (dataWrap['threads'] as List? ?? const [])
            .whereType<Map<String, dynamic>>();
        final posts = <TwitterPostEntity>[];
        for (final t in threads) {
          posts.addAll(TwitterPostModel.listFromThread(t));
        }

        // pagination
        final pg = (dataWrap['pagination'] as Map?)?.cast<String, dynamic>() ??
            const {};
        final hasNext = pg['hasNextPage'] == true;
        final int? next =
            (pg['nextPage'] is int) ? pg['nextPage'] as int : null;

        return Right(TwitterPage<TwitterPostEntity>(
          items: posts,
          hasNextPage: hasNext,
          nextPage: next,
        ));
      },
    );
  }
// twitter_remote_datasource.dart

  @override
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getMyPostsPage({
    required int page,
    required int limit,
  }) async {
    final uri = Uri.parse('/twitter/threads/me').replace(queryParameters: {
      'page': '$page',
      'limit': '$limit',
    });

    final response = await _apiConsumer.get(uri.toString());

    return response.fold(Left.new, (data) {
      final root = (data is Map<String, dynamic>) ? data : const {};
      final dataWrap =
          (root['data'] as Map?)?.cast<String, dynamic>() ?? const {};

      final threads = (dataWrap['threads'] as List? ?? const [])
          .whereType<Map<String, dynamic>>();

      final posts = <TwitterPostEntity>[];

      for (final t in threads) {
        // Normalize blocks
        final owner = (t['owner'] is Map)
            ? (t['owner'] as Map).cast<String, dynamic>()
            : const <String, dynamic>{};
        final thread = (t['thread'] is Map)
            ? (t['thread'] as Map).cast<String, dynamic>()
            : const <String, dynamic>{};
        final orig = (t['originalPost'] is Map)
            ? (t['originalPost'] as Map).cast<String, dynamic>()
            : const <String, dynamic>{};

        // Build a synthetic "post" block for the repost row (your payload has the post fields at top level)
        final syntheticPost = <String, dynamic>{
          'id': t['id'],
          'content': t['content'],
          'media': t['media'] ?? const [],
          'likesCount': t['likesCount'] ?? 0,
          'repliesCount': t['repliesCount'] ?? 0,
          'repostsCount': t['repostsCount'] ?? 0,
          'createdAt': t['createdAt'],
          'youLiked': t['youLiked'] ?? false,
          'yourReposted': t['yourReposted'] ?? false,
        };

        final hasOriginal = orig.isNotEmpty;

        if (hasOriginal) {
          final adapted = <String, dynamic>{
            'threadId': thread['id'] ?? thread['_id'],
            'createdAt': thread['createdAt'],
            'updatedAt': thread['updatedAt'] ?? thread['createdAt'],
            'owner': owner,
            'originalPost': orig,
            'post': syntheticPost,
          };
          posts.add(TwitterPostModel.fromRepostThread(adapted));
        } else {
          // Not a repost → try the classic owner+post form
          final post = (t['post'] is Map)
              ? (t['post'] as Map).cast<String, dynamic>()
              : syntheticPost; // fallback to the synthetic if no "post" object exists

          final threadMeta = thread.isNotEmpty
              ? thread
              : {
                  'threadId': t['id'], // mild fallback
                  'createdAt': t['createdAt'],
                  'updatedAt': t['updatedAt'] ?? t['createdAt'],
                  'owner': owner,
                };

          posts.add(TwitterPostModel.fromOwnerAndPost(owner, post, threadMeta));
        }
      }

      final pg =
          (dataWrap['pagination'] as Map?)?.cast<String, dynamic>() ?? const {};
      final hasNext = pg['hasNextPage'] == true;
      final int? next = (pg['nextPage'] is int) ? pg['nextPage'] as int : null;

      return Right(TwitterPage<TwitterPostEntity>(
        items: posts,
        hasNextPage: hasNext,
        nextPage: next,
      ));
    });
  }

  @override
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getUserPostsPage({
    required String userId,
    required int page,
    required int limit,
  }) async {
    final uri =
        Uri.parse('/twitter/threads/users/$userId').replace(queryParameters: {
      'page': '$page',
      'limit': '$limit',
    });

    final response = await _apiConsumer.get(uri.toString());

    return response.fold(Left.new, (data) {
      final root = (data is Map<String, dynamic>) ? data : const {};
      final dataWrap =
          (root['data'] as Map?)?.cast<String, dynamic>() ?? const {};

      final threads = (dataWrap['threads'] as List? ?? const [])
          .whereType<Map<String, dynamic>>();

      final posts = <TwitterPostEntity>[];

      for (final t in threads) {
        // Shape in this API:
        // { id(threadId), createdAt, updatedAt, owner:{...}, originalPost?:{...}, post:{...} }

        final owner = (t['owner'] is Map)
            ? (t['owner'] as Map).cast<String, dynamic>()
            : const <String, dynamic>{};

        final post = (t['post'] is Map)
            ? (t['post'] as Map).cast<String, dynamic>()
            : const <String, dynamic>{};

        final orig = (t['originalPost'] is Map)
            ? (t['originalPost'] as Map).cast<String, dynamic>()
            : const <String, dynamic>{};

        final threadMeta = <String, dynamic>{
          'threadId': t['id'],
          'createdAt': t['createdAt'],
          'updatedAt': t['updatedAt'] ?? t['createdAt'],
          'owner': owner,
        };

        if (orig.isNotEmpty) {
          // Repost
          final adapted = <String, dynamic>{
            ...threadMeta,
            'originalPost': orig,
            'post': post,
          };
          posts.add(TwitterPostModel.fromRepostThread(adapted));
        } else {
          // Normal post in thread
          posts.add(TwitterPostModel.fromOwnerAndPost(owner, post, threadMeta));
        }
      }

      final pg =
          (dataWrap['pagination'] as Map?)?.cast<String, dynamic>() ?? const {};
      final hasNext = pg['hasNextPage'] == true;
      final int? next = (pg['nextPage'] is int) ? pg['nextPage'] as int : null;

      return Right(TwitterPage<TwitterPostEntity>(
        items: posts,
        hasNextPage: hasNext,
        nextPage: next,
      ));
    });
  }

  @override
  Future<Either<Failure, TwitterPostEntity>> getTwitterPost(
      {required String postId}) async {
    final response = await _apiConsumer.get("/twitter/threads/$postId");

    return response.fold(Left.new, (data) {
      // shape: { status, message, data: { thread: {...}, pagination: {...} } }
      final root = (data ?? {});
      final thread = (root['data']?['thread'] ?? {}) as Map<String, dynamic>;
      if (thread.isEmpty) {
        return Left(UnknownFailure('Empty thread payload'));
      }

      final owner = (thread['owner'] ?? {}) as Map<String, dynamic>;
      final posts = (thread['posts'] ?? const []) as List;
      final replies = (thread['replies'] ?? const []) as List;

      if (posts.isEmpty) {
        return Left(UnknownFailure('Thread has no posts'));
      }

      // ---- main post (position == 0) ----
      Map<String, dynamic> mainPost = posts.first as Map<String, dynamic>;
      for (final p in posts.whereType<Map<String, dynamic>>()) {
        if ((p['position'] ?? 9999) == 0) {
          mainPost = p;
          break;
        }
      }
      final main = TwitterPostModel.fromOwnerAndPost(owner, mainPost, thread);

      // ---- other posts in the same thread (excluding main) ----
      final otherPostModels = posts
          .whereType<Map<String, dynamic>>()
          .where((p) =>
              (p['id'] ?? p['_id']) != (mainPost['id'] ?? mainPost['_id']))
          .map((p) => TwitterPostModel.fromOwnerAndPost(owner, p, thread))
          .toList();

      final replyModels = replies
          .whereType<Map<String, dynamic>>()
          .map((r) => TwitterPostModel.commentFromThreadReply(
              r.cast<String, dynamic>()))
          .toList();

      // attach extras to the same model we return
      final withExtras = main.attachThreadExtras(
        posts: otherPostModels,
        replies: replyModels,
      );

      return Right(withExtras);
    });
  }
// in TwitterRemoteDataSourceImpl

  @override
  Future<Either<Failure, TwitterPage<TwitterPostEntity>>> getThreadPostsPage({
    required String threadId,
    required int page,
    required int limit,
  }) async {
    final uri =
        Uri.parse('/twitter/threads/$threadId').replace(queryParameters: {
      'pagePosts': '$page',
      'limitPosts': '$limit',
      // keep replies on page 1 (or omit if backend ignores)
      'pageReplies': '1',
      'limitReplies': '10',
    });

    final response = await _apiConsumer.get(uri.toString());

    return response.fold(Left.new, (data) {
      final root = (data ?? {});
      final thread = (root['data']?['thread'] ?? {}) as Map<String, dynamic>;
      if (thread.isEmpty) return Left(UnknownFailure('Empty thread payload'));

      final owner = (thread['owner'] ?? {}) as Map<String, dynamic>;
      final posts = (thread['posts'] ?? const []) as List;

      // main post detection
      Map<String, dynamic>? mainRaw;
      for (final p in posts.whereType<Map<String, dynamic>>()) {
        if ((p['position'] ?? 9999) == 0) {
          mainRaw = p;
          break;
        }
      }
      // map posts page (backend should already paginate posts list)
      final items = posts
          .whereType<Map<String, dynamic>>()
          .where((p) {
            // exclude main if present
            if (mainRaw == null) return true;
            final id = (p['id'] ?? p['_id']).toString();
            final mid = (mainRaw['id'] ?? mainRaw['_id']).toString();
            return id != mid;
          })
          .map((p) => TwitterPostModel.fromOwnerAndPost(owner, p, thread))
          .toList();

      // pagination block (expecting it from backend)
      final pg =
          (root['data']?['pagination'] as Map?)?.cast<String, dynamic>() ??
              const {};
      final hasNext = pg['hasNextPage'] == true;
      final int? next = (pg['nextPage'] is int) ? pg['nextPage'] as int : null;

      return Right(TwitterPage<TwitterPostEntity>(
        items: items,
        hasNextPage: hasNext,
        nextPage: next,
      ));
    });
  }

  @override
  Future<Either<Failure, TwitterPage<TwitterPostCommentEntity>>>
      getThreadRepliesPage({
    required String threadId,
    required int page,
    required int limit,
  }) async {
    final uri =
        Uri.parse('/twitter/threads/$threadId').replace(queryParameters: {
      'pageReplies': '$page',
      'limitReplies': '$limit',
      // keep posts on page 1 (or omit if backend ignores)
      'pagePosts': '1',
      'limitPosts': '10',
    });

    final response = await _apiConsumer.get(uri.toString());

    return response.fold(Left.new, (data) {
      final root = (data ?? {});
      final thread = (root['data']?['thread'] ?? {}) as Map<String, dynamic>;
      if (thread.isEmpty) return Left(UnknownFailure('Empty thread payload'));

      final replies = (thread['replies'] ?? const []) as List;

      final items = replies
          .whereType<Map<String, dynamic>>()
          .map((r) => TwitterPostModel.commentFromThreadReply(
                (r as Map).cast<String, dynamic>(),
              ))
          .toList();

      // if backend returns a separate pagination for replies, great. If not,
      // you can return false/next=null OR ask backend to add it.
      final pg =
          (root['data']?['pagination'] as Map?)?.cast<String, dynamic>() ??
              const {};
      final hasNext = pg['hasNextPage'] == true;
      final int? next = (pg['nextPage'] is int) ? pg['nextPage'] as int : null;

      return Right(TwitterPage<TwitterPostCommentEntity>(
        items: items,
        hasNextPage: hasNext,
        nextPage: next,
      ));
    });
  }

  @override
  Future<Either<Failure, List<TwitterPostEntity>>> getUserPosts(
      {required GetUserTweetsParams params}) async {
    print("object");
    final response = await _apiConsumer.get(EndPoints.userTweets(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data'] as List)
            .map((e) => TwitterPostModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> reactOnPost({required params}) async {
    final response = await _apiConsumer.put(
        EndPoints.reactOnTwitterPost(params.postId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> getVerification() async {
    final response = await _apiConsumer.get(
      EndPoints.getVerification,
    );
    return response.fold(
        (l) => Left(l), (data) => Right(data['data'] ?? false));
  }

  @override
  Future<Either<Failure, bool>> reactOnComment({required params}) async {
    final response = await _apiConsumer.put(
        EndPoints.reactOnTwitterPost(params.commentId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> sharePost({required params}) async {
    final response =
        await _apiConsumer.post(EndPoints.shareTwitterPost(params));

    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, TwitterPostCommentEntity>> commentOnTwitterPost(
      {required TwitterPostCommentParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.commentOnTwitterPost(params.postId),
        data: params.toJson());
    return response.fold((l) => Left(l),
        (data) => Right(TwitterPostCommentModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, TwitterCommentReplyEntity>> replyOnComment(
      {required TwitterCommentReplyParams params}) async {
    final response = await _apiConsumer
        .post(EndPoints.commentOnTwitterPost(params.postId), data: {
      'content': params.content,
      'reply': params.reply,
      // 'subCategory':'66a3583454e6e337915514db'
    });
    return response.fold((l) => Left(l),
        (data) => Right(TwitterCommentReplyModel.fromJson(data['data'])));
  }

  @override
  Future<Either<Failure, List<TwitterPostCommentEntity>>> getPostComments(
      {required PostCommentsParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getTwitterPostComments(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['replies'] as List)
            .map((e) => TwitterPostCommentModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, List<TwitterCommentReplyEntity>>> getCommentReplies(
      {required PostCommentsParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getTwitterCommentReplies(params));
    return response.fold(
        (l) => Left(l),
        (data) => Right((data['data']['replies'] as List)
            .map((e) => TwitterCommentReplyModel.fromJson(e))
            .toList()));
  }

  @override
  Future<Either<Failure, bool>> deletePost({required String postId}) async {
    final response =
        await _apiConsumer.delete(EndPoints.deleteTwitterPost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> hidePost({required String postId}) async {
    final response = await _apiConsumer.put(EndPoints.hideTwitterPost(postId));
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> addReport(
      {required TwitterReportParams params}) async {
    final response = await _apiConsumer.post(
        EndPoints.report(subCategoryId: params.categoryId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> requestDocument(
      {required TwitterDocumentationParams params}) async {
    final response = await _apiConsumer.post(EndPoints.userVerification,
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      {required String commentId}) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteTwitterComment(commentId),
    );
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, bool>> editComment(
      {required TwitterPostCommentParams params}) async {
    final response = await _apiConsumer.put(
        EndPoints.editTwitterComment(params.postId),
        data: params.toJson());
    return response.fold((l) => Left(l), (data) => Right(data['status']));
  }

  @override
  Future<Either<Failure, int>> getFollowersCount(
      {required String subCategoryId}) async {
    final res = await _apiConsumer.get("");
    return res.fold(
      Left.new,
      (data) {
        // shape: { "status": true, "data": 7 }
        final count = (data['data'] is num) ? (data['data'] as num).toInt() : 0;
        return Right(count);
      },
    );
  }

  @override
  Future<Either<Failure, int>> getFollowingCount(
      {required String subCategoryId}) async {
    final res = await _apiConsumer.get("");
    return res.fold(
      Left.new,
      (data) {
        final count = (data['data'] is num) ? (data['data'] as num).toInt() : 0;
        return Right(count);
      },
    );
  }

  @override
  Future<Either<Failure, String>> repostPost(String postId) async {
    final uri = '/twitter/posts/$postId/repost';

    final response = await _apiConsumer.post(uri);

    return response.fold(Left.new, (data) {
      final root = (data is Map<String, dynamic>) ? data : const {};
      final repostId = root['data']?['repostId']?.toString() ?? '';
      if (repostId.isEmpty) {
        return Left(ServerFailure(message: 'No repostId returned'));
      }
      return Right(repostId);
    });
  }
}
