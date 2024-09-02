import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_saved_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_user_reels_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/delete_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/edit_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/face_advertisement_use_case.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comment_replies_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'instagram_state.dart';

class InstagramCubit extends Cubit<InstagramState> {
  final GetInstagramFeedUseCase _getFeedUseCase;
  final FaceAdvertisementUseCase _advertisementUseCase;
  final PostReactUseCase _postReactUseCase;
  final GetPostCommentsUseCase _getPostCommentsUseCase;
  final GetPostCommentRepliesUseCase _getPostCommentRepliesUseCase;
  final PostCommentUseCase _postCommentUseCase;
  final ReplyOnCommentUseCase _replyOnCommentUseCase;
  final CommentReactUseCase _commentReactUseCase;
  final GetInstagramReelsUseCase _instagramReelsUseCase;
  final GetInstagramUserReelsUseCase _userReelsUseCase;
  final GetSavedReelsUseCase _getSavedReelsUseCase;
  final EditCommentUseCase _editCommentUseCase;
  final DeleteCommentUseCase _deleteCommentUseCase;

  InstagramCubit(
      this._getFeedUseCase,
      this._advertisementUseCase,
      this._postReactUseCase,
      this._getPostCommentsUseCase,
      this._getPostCommentRepliesUseCase,
      this._postCommentUseCase,
      this._replyOnCommentUseCase,
      this._commentReactUseCase,
      this._instagramReelsUseCase,
      this._userReelsUseCase,
      this._editCommentUseCase,
      this._deleteCommentUseCase,
      this._getSavedReelsUseCase)
      : super(InstagramState());

  void loadData() async {
    await getFeed(1);
    feedPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
  }

  void loadUserReels(String userId) async {
    await getUserReels(1, userId);
    userReelsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getUserReels(pageKey, userId);
    });
  }

  void loadSaverReels(String userId) async {
    await getSavedReels(1, userId);
    savedReelsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getSavedReels(pageKey, userId);
    });
  }

  void loadMedia() async {
    await getMedia(1);
    mediaPagingController.addPageRequestListener((pageKey) {
      getMedia(pageKey);
    });
  }

  refreshUserReels() async {
    userReelsPagingController.refresh();
  }

  refreshMedia() async {
    mediaPagingController.refresh();
  }

  refreshSavedReels() async {
    savedReelsPagingController.refresh();
  }

  void loadComments(BuildContext context, String postId) async {
    await getPostComments(context: context, postId: postId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPostComments(context: context, postId: postId, page: pageKey);
    });
  }

  void loadReplies(BuildContext context, String commentId) async {
    await getCommentReplies(context: context, commentId: commentId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getCommentReplies(context: context, commentId: commentId, page: pageKey);
    });
  }

  void onRefresh() async {
    emit(state.copyWith(advertisementsPage: 0, newPage: 0));
    feedPagingController.refresh();
  }

  final PagingController<int, PostEntity> feedPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, PostEntity> userReelsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, PostEntity> savedReelsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, PostEntity> mediaPagingController =
      PagingController(firstPageKey: 1);

// get feed posts
  Future<void> getFeed(int page) async {
    final response =
        await _getFeedUseCase(TwitterFeedParams(limit: 5, page: page));
    List<PostEntity> advertisements = [];
    List<PostEntity> reels = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      if (data.isNotEmpty) {
        advertisements = await getAdvertisements();
        reels = await getReels();
      }
      List<PostEntity> totalPosts = [];
      totalPosts.addAll(data);
      totalPosts.addAll(advertisements);
      totalPosts.addAll(reels);
      final isLastPage = totalPosts.length < (6);
      if (page == 1) {
        print("page == 1 $page");
        feedPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        feedPagingController.appendLastPage(totalPosts);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        feedPagingController.appendPage(totalPosts, nextPageKey);
      }
      emit(state.copyWith(posts: totalPosts, status: StateStatus.initial));
    });
  }


  //get media
  getMedia(int page) async {
    final response =
    await _getFeedUseCase(TwitterFeedParams(limit: 10, page: page));
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) async {
          final isLastPage = data.length < 10;
          if (page == 1) {
            print("page == 1 $page");
            mediaPagingController.itemList = [];
          }
          if (isLastPage) {
            print("isLastPage = $isLastPage");
            mediaPagingController.appendLastPage(data);
          } else {
            print("isNotLastPage = $isLastPage");
            final nextPageKey = page + 1;
            mediaPagingController.appendPage(data, nextPageKey);
          }
          emit(state.copyWith(media:data, status: StateStatus.success));
        });
  }

  // get advertisements
  Future<List<PostEntity>> getAdvertisements() async {
    final response = await _advertisementUseCase(
        TwitterFeedParams(limit: 1, page: state.advertisementsPage! + 1));
    List<PostEntity> advertisements = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      advertisements.addAll(data);
      int? page = state.advertisementsPage! + 1;
      emit(state.copyWith(
          advertisementsPage: page, posts: data, status: StateStatus.success));
    });
    print("advertisements:${advertisements.length}");
    return advertisements;
  }

  // get reels
  Future<List<PostEntity>> getReels() async {
    final response = await _instagramReelsUseCase(
        TwitterFeedParams(limit: 1, page: state.newPage! + 1));
    List<PostEntity> reels = [];
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      reels.addAll(data);
      int? page = state.newPage! + 1;
      print("newPage:${state.newPage}");
      print("newPage:$page");
      emit(state.copyWith(
          newPage: page, posts: data, status: StateStatus.success));
    });
    print("reels:${reels.length}");
    return reels;
  }

  getUserReels(int page, String userId) async {
    final response = await _userReelsUseCase(
        UserReelsParams(limit: 10, page: page, userId: userId));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      final isLastPage = data.length < 10;
      if (page == 1) {
        print("page == 1 $page");
        userReelsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        userReelsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        userReelsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(posts: data, status: StateStatus.success));
    });
  }

  getSavedReels(int page, String userId) async {
    final response =
        await _getSavedReelsUseCase(TwitterFeedParams(limit: 10, page: page));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) async {
      final isLastPage = data.length < 10;
      if (page == 1) {
        print("page == 1 $page");
        savedReelsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        savedReelsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        savedReelsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(posts: data, status: StateStatus.success));
    });
  }

  void changeIndex(int index) {
    emit(state.copyWith(pageIndex: index));
  }

// react on a post
  Future<bool> onReact({required PostReactParams params}) async {
    var response = await _postReactUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) {
      value = r;
      emit(state.copyWith(count: state.count! + 1));
    });
    return value;
  }

  final PagingController<int, CommentEntity> commentsPagingController =
      PagingController(firstPageKey: 1);

  int pageSize = 10;
  Future<void> getPostComments(
      {required BuildContext context,
      required String postId,
      required int page}) async {
    final response = await _getPostCommentsUseCase(
      PostCommentsParams(
        page: page,
        limit: pageSize,
        postId: postId,
      ),
    );
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        commentsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        commentsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        commentsPagingController.appendPage(data, nextPageKey);
      }
      emit(
        state.copyWith(
          postComments: data,
          status: StateStatus.success,
        ),
      );
    });
  }
  // void showPostComments(
  //     {required BuildContext context, required PostCommentsParams params}) async {
  //   final response = await _getPostCommentsUseCase(params);
  //   response.fold(
  //           (failure) =>
  //           emit(state.copyWith(failure: failure, status: StateStatus.error)),
  //           (data) => bottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           widget: InstagramPostComments(
  //               comments: data,
  //               postId: params.postId,
  //               onAddComment: (PostCommentParams params) {
  //                 onPostComment(params: params);
  //               }),),);
  // }

  // show comments with rendered data

  // void showPostCommentReplies(
  //     {required BuildContext context, required String commentId,required String postId}) async {
  //   final response = await _getPostCommentRepliesUseCase(PostCommentsParams(page: 0, limit: 0, postId: 'postId'));
  //   response.fold(
  //           (failure) =>
  //           emit(state.copyWith(failure: failure, status: StateStatus.error)),
  //           (data) => bottomSheet(
  //           context: context,
  //           isScrollControlled: true,
  //           widget: InstagramCommentReplies(
  //             replies: data,
  //             postId: postId, commentId: commentId, onAddReply: (ReplyOnCommentParams params) {
  //             replyOnComment(params: params);
  //           },
  //           )));
  // }

  final PagingController<int, CommentEntity> repliesPagingController =
      PagingController(firstPageKey: 1);
  Future<void> getCommentReplies(
      {required BuildContext context,
      required String commentId,
      required int page}) async {
    final response = await _getPostCommentRepliesUseCase(
      PostCommentsParams(
        page: page,
        limit: pageSize,
        postId: commentId,
      ),
    );
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        repliesPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        repliesPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        repliesPagingController.appendPage(data, nextPageKey);
      }
      emit(
        state.copyWith(
          status: StateStatus.success,
        ),
      );
    });
  }

// add comment usecase
  Future<CommentEntity> onPostComment(
      {required PostCommentParams params}) async {
    var response = await _postCommentUseCase(params);
    CommentEntity? model;
    response.fold(
        (failure) => emit(
              state.copyWith(failure: failure, status: StateStatus.error),
            ), (data) {
      model = data;
      feedPagingController.itemList
          ?.firstWhere((element) => element.id == params.postId)
          .commentsCount = (feedPagingController.itemList!
              .firstWhere((element) => element.id == params.postId)
              .commentsCount! +
          1);
      print(
          "CommentsCount ${feedPagingController.itemList?.firstWhere((element) => element.id == params.postId).commentsCount}");
      emit(state.copyWith(newComment: data, status: StateStatus.success));
    });
    return model!;
  }

  // add comment usecase
  Future<CommentEntity> replyOnComment(
      {required ReplyOnCommentParams params}) async {
    var response = await _replyOnCommentUseCase(params);
    CommentEntity? model;
    response.fold(
        (failure) => emit(
              state.copyWith(failure: failure, status: StateStatus.error),
            ), (data) {
      model = data;
      emit(state.copyWith(newComment: data, status: StateStatus.success));
    });
    return model!;
  }

  // react on a comment
  Future<bool> onCommentReact({required PostReactParams params}) async {
    var response = await _commentReactUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) {
      value = r;
    });
    return value;
  }

  Future<bool> deleteComment(
      {required BuildContext context,
      required String commentId,
      required String postId,
      required String from}) async {
    final response = await _deleteCommentUseCase(commentId);
    bool result = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      result = r;
      if (from == 'feed') {
        var currentPost = feedPagingController.itemList
            ?.firstWhere((element) => element.id == postId);
        print("comment count${currentPost?.commentsCount}");
        currentPost?.commentsCount = (currentPost.commentsCount! - 1);
      }
      emit(state.copyWith(status: StateStatus.success));
      showSuccessMessage(context, "Comment delete successfully");
    });
    return result;
  }

  // edit on a comment
  Future<bool> editComment({required PostCommentParams params}) async {
    var response = await _editCommentUseCase(params);
    bool value = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (r) {
      value = r;
    });
    return value;
  }
}
