import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/comment_instagram_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/create_post_request_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/data_suggest_follow_instagram_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/followers_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/following_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/instagram_post_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/profile_instagram_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/reel_instagram_data_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/reels_specific_user_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/single_post_instagram_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/data/models/user_tag_model.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/comment_instagram_data_entiry.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/create_post_request_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/data_suggest_follow_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/followers_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/following_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reel_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/reels_specific_user_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/single_post_instagram_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/add_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/create_post_request_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/delete_comment_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_profile_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_specific_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_user_media_usecase.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_suggest_follow_instagram_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_tag_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/like_post_instagram_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/post_confirm_webhook_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/post_follow_user_instagram_use_case.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/save_post_instagram_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/post_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import '../../../../../core/error/failure.dart';
import '../../domain/usecases/get_all_followers_use_case.dart';

abstract class InstagramRemoteDataSource {
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params});

  Future<Either<Failure, List<PostEntity>>> getUserMedia(
      {required InstagramUserMediaParams params});

  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params});

  Future<Either<Failure, ReelInstagramDataEntity>> getReels(
      {required TwitterFeedParams params});

  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params});

  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params});

  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(
      GetAllFollowersParams params);

  Future<Either<Failure, List<FollowersEntity>>> getAllFollowing(
      GetAllFollowersParams params);

  Future<Either<Failure, InstagramPostDataModel>> getPosts(
      PaginationParams params);

  Future<Either<Failure, List<UserTagEntity>>> getUserTag(
      GetUserTagParams username);

  Future<Either<Failure, CommentInstagramDataEntiry>> getComment(String postId);

  Future<Either<Failure, bool>> addComment(AddCommentParams params);

  Future<Either<Failure, bool>> deleteComment(DeleteCommentParams params);

  Future<Either<Failure, List<CreatePostRequestEntity>>> createRequestPost(
      CreatePostRequestInstagramParams params);

  Future<Either<Failure, ProfileInstagramDataEntity>> getInstagramProfile(
      GetInstagramProfileParams params);

  Future<Either<Failure, ReelsSpecificUserDataEntity>> getReelsSpecificUser(
      GetInstagramReelsSpecificUserParams params);

  Future<Either<Failure, SinglePostInstagramEntity>> getSinglePostInstagram(
      String postId);

  Future<Either<Failure, DataSuggestFollowInstagramEntity>>
      getSuggestFollowInstagram(GetSuggestFollowInstagramParams params);

  Future<Either<Failure, bool>> postFollowUserInstagram(
      PostFollowUserInstagramParams params);

  Future<Either<Failure, bool>> unFollowUserInstagram(
      PostFollowUserInstagramParams params);

  Future<Either<Failure, bool>> likePostInstagram(
      LikePostInstagramParams params);

  Future<Either<Failure, bool>> savePostInstagram(
      SavePostInstagramParams params);

  Future<Either<Failure, bool>> removeSavePostInstagram(
      SavePostInstagramParams params);

  Future<Either<Failure, void>> postConfirmWebhook(PostConfirmWebhookParams params);
}

class InstagramRemoteDataSourceImpl implements InstagramRemoteDataSource {
  final ApiConsumer _apiConsumer;

  InstagramRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<PostEntity>>> getFeed(
      {required TwitterFeedParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getInstagramPosts(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserMedia(
      {required InstagramUserMediaParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getUserMedia(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getGlobalFeed(
      {required TwitterFeedParams params}) async {
    final response =
        await _apiConsumer.get(EndPoints.getInstagramGlobalPosts(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['posts'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, ReelInstagramDataEntity>> getReels(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final responseData = ReelInstagramDataModel.fromJson(data['data']);
      return Right(responseData);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getUserReels(
      {required UserReelsParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getUserReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['reels']['reels'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<PostEntity>>> getSavedReels(
      {required TwitterFeedParams params}) async {
    final response = await _apiConsumer.get(EndPoints.getSavedReels(params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['reels'] as List)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<FollowersEntity>>> getAllFollowers(
      GetAllFollowersParams params) async {
    final response = await _apiConsumer.get(EndPoints.getSocialFollowers(params: params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['followers'] as List)
          .map((e) => FollowersModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, List<FollowersEntity>>> getAllFollowing(
      GetAllFollowersParams params) async {
    final response = await _apiConsumer.get(EndPoints.getSocialFollowing(params: params));

    return response.fold((l) {
      return Left(l);
    }, (data) {
      final list = (data['data']['following'] as List)
          .map((e) => FollowersModel.fromJson(e))
          .toList();
      return Right(list);
    });
  }

  @override
  Future<Either<Failure, InstagramPostDataModel>> getPosts(
      PaginationParams params) async {
    final response =
        await _apiConsumer.get(EndPoints.getPostsInstagram(params));

    try {
      return response.fold((l) {
        return Left(l);
      }, (response) {
        // final dataPosts = InstagramPostDataModel.fromJson(data);
        return Right(InstagramPostDataModel.fromJson(response['data']));
      });
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<UserTagEntity>>> getUserTag(
      GetUserTagParams params) async {
    try {
      final response = await _apiConsumer.get(
        EndPoints.getUserTag(
          username: params.username,
          page: params.page,
          limit: params.limit,
        ),
        // data: {
        //   "username": params.username,
        // },
      );

      return response.fold((l) {
        return Left(l);
      }, (data) {
        final list = (data['data']['tags'] as List)
            .map((e) => UserTagModel.fromJson(e))
            .toList();
        return Right(list);
      });
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, CommentInstagramDataEntiry>> getComment(
      String postId) async {
    final response = await _apiConsumer.get(
      EndPoints.getCommentInstagram(postId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final responseData = CommentInstagramDataModel.fromJson(data['data']);
          return Right(responseData);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> addComment(AddCommentParams params) async {
    final response = await _apiConsumer.post(
        EndPoints.addCommentInstagram(params.postId),
        data: {"content": params.contentComment});

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteComment(
      DeleteCommentParams params) async {
    final response = await _apiConsumer.delete(
      EndPoints.deleteCommentInstagram(params.postId, params.commentId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, List<CreatePostRequestEntity>>> createRequestPost(
      CreatePostRequestInstagramParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.createRequestPostInstagram,
      data: params.toJson(),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final list = (data['data']['media'] as List)
              .map((e) => CreatePostRequestModel.fromJson(e))
              .toList();
          return Right(list);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, ProfileInstagramDataEntity>> getInstagramProfile(
      GetInstagramProfileParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getProfileInstagram(
          userId: params.userId, page: params.page, limit: params.limit),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final responseData = ProfileInstagramDataModel.fromJson(data['data']);
          return Right(responseData);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, ReelsSpecificUserDataEntity>> getReelsSpecificUser(
      GetInstagramReelsSpecificUserParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getReelsSpecificUser(
          userId: params.userId, page: params.page, limit: params.limit),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final responseData =
              ReelsSpecificUserDataModel.fromJson(data['data']['reels']);
          return Right(responseData);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, SinglePostInstagramEntity>> getSinglePostInstagram(
      String postId) async {
    final response = await _apiConsumer.get(
      EndPoints.getSinglePostInstagram(postId: postId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final responseData = SinglePostInstagramModel.fromJson(data['data']);
          return Right(responseData);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, DataSuggestFollowInstagramEntity>>
      getSuggestFollowInstagram(GetSuggestFollowInstagramParams params) async {
    final response = await _apiConsumer.get(
      EndPoints.getSuggestFollowInstagram(
        page: params.page,
        limit: params.limit,
      ),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          final responseData =
              DataSuggestFollowInstagramModel.fromJson(data['data']);
          return Right(responseData);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> postFollowUserInstagram(
      PostFollowUserInstagramParams params) async {
    final response = await _apiConsumer.post(
      EndPoints.postFollowUserInstagram(userId: params.userId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> unFollowUserInstagram(
      PostFollowUserInstagramParams params) async {
    final response = await _apiConsumer.delete(
      EndPoints.unFollowUserInstagram(userId: params.userId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> likePostInstagram(
      LikePostInstagramParams params) async {
    final response = await _apiConsumer.put(
      EndPoints.likePostInstagram(postId: params.postId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return Right(data['data']['likeStatus']);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> savePostInstagram(
      SavePostInstagramParams params) async {
    final response = await _apiConsumer.put(
      EndPoints.savePostInstagram(postId: params.postId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, bool>> removeSavePostInstagram(
      SavePostInstagramParams params) async {
    final response = await _apiConsumer.delete(
      EndPoints.removeSavePostInstagram(postId: params.postId),
    );

    try {
      return response.fold(
        (l) {
          return Left(l);
        },
        (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }

  @override
  Future<Either<Failure, void>> postConfirmWebhook(PostConfirmWebhookParams params) async {
    final response = await _apiConsumer.put(
      EndPoints.postConfirmWebhook,
      data: {
        "mediaIds": params.mediaIds
      }
    );
    try {
      return response.fold(
            (l) {
          return Left(l);
        },
            (data) {
          return const Right(true);
        },
      );
    } catch (e) {
      final error = (e is Map && e['error'] is Map) ? e['error'] as Map : null;
      log('error: ${e.toString()}');
      return Left(
          UnknownFailure(error != null ? error.toString() : 'Unknown error'));
    }
  }
}
