import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/delete_twitter_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/delete_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/edit_twitter_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_global_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_user_posts_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/hide_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/share_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'twitter_state.dart';

class TwitterCubit extends Cubit<TwitterState> {
  final GetTwitterFeedUseCase _getFeedUseCase;
  final GetTwitterGlobalFeedUseCase _getTwitterGlobalFeedUseCase;
  final TwitterPostReactUseCase _twitterPostReactUseCase;
  final GetTwitterPostCommentsUseCase _getTwitterPostCommentsUseCase;
  final TwitterCommentReactUseCase _twitterCommentReactUseCase;
  final TwitterSharePostUseCase _twitterSharePostUseCase;
  final TwitterPostCommentUseCase _twitterPostCommentUseCase;
  final TwitterCommentReplyUseCase _twitterCommentReplyUseCase;
  final GetTwitterCommentRepliesUseCase _twitterCommentRepliesUseCase;
  final GetTwitterPostUseCase _getTwitterPostUseCase;
  final TwitterReportUseCase _twitterReportUseCase;
  final RequestDocumentUseCase _requestDocumentUseCase;
  final GetUserTweetsUseCase _getUserTweetsUseCase;
  final DeleteTwitterPostUseCase _deleteTwitterPostUseCase;
  final DeleteTwitterCommentUseCase _deleteTwitterCommentUseCase;
  final EditTwitterCommentUseCase _editTwitterCommentUseCase;
  final HideTwitterPostUseCase _hideTwitterPostUseCase;

  TwitterCubit(
    this._getFeedUseCase,
    this._twitterPostReactUseCase,
    this._getTwitterPostCommentsUseCase,
    this._twitterCommentReactUseCase,
    this._twitterSharePostUseCase,
    this._twitterPostCommentUseCase,
    this._twitterCommentReplyUseCase,
    this._twitterCommentRepliesUseCase,
    this._getTwitterPostUseCase,
    this._twitterReportUseCase,
    this._requestDocumentUseCase,
    this._getUserTweetsUseCase,
    this._deleteTwitterPostUseCase,
    this._hideTwitterPostUseCase,
    this._deleteTwitterCommentUseCase,
    this._editTwitterCommentUseCase,
    this._getTwitterGlobalFeedUseCase,
  ) : super(const TwitterState());

  void loadData() async {
    //   await getFeed(1);
    getFeed(1);
    postsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
  }

  void loadGlobalData() async {
    //   await getFeed(1);
    getGlobalFeed(1);
    globalPostsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getGlobalFeed(pageKey);
    });
  }

  void loadComments(BuildContext context, String postId) async {
    await getPostComments(context: context, postId: postId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPostComments(context: context, postId: postId, page: pageKey);
    });
  }

  void loadReplies(BuildContext context, String commentId) async {
    await getCommentReplies(context: context, postId: commentId, page: 1);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getCommentReplies(context: context, postId: commentId, page: pageKey);
    });
  }

  void onRefresh() async {
    postsPagingController.refresh();
  }

  void onGlobalRefresh() async {
    globalPostsPagingController.refresh();
  }

  void onRefreshUserTweets() async {
    userTweetsPagingController.refresh();
  }

  void loadUserTweets(String userId) async {
    //   await getFeed(1);
    getUserTweets(1, userId);
    userTweetsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getUserTweets(pageKey, userId);
    });
  }

  final int reactCount = 0;

  final int pageSize = 10;
  final PagingController<int, TwitterPostEntity> postsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, TwitterPostEntity> globalPostsPagingController =
      PagingController(firstPageKey: 1);

  final PagingController<int, TwitterPostEntity> userTweetsPagingController =
      PagingController(firstPageKey: 1);
// get feed posts
  Future<void> getFeed(int page) async {
    final response =
        await _getFeedUseCase(TwitterFeedParams(limit: pageSize, page: page));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        postsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        postsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        postsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(posts: data, status: StateStatus.success));
    });
  }

  // get global feed posts
  Future<void> getGlobalFeed(int page) async {
    final response = await _getTwitterGlobalFeedUseCase(
        TwitterFeedParams(limit: pageSize, page: page));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        globalPostsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        globalPostsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        globalPostsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(posts: data, status: StateStatus.success));
    });
  }
  //
  // // get global feed posts
  // getGlobalFeed(int page) async {
  //   final response =
  //   await _getGlobalFeedUseCase(TwitterFeedParams(limit: 10, page: page));
  //   response.fold(
  //           (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
  //           (data) async {
  //         final isLastPage = data.length < 10;
  //         if (page == 1) {
  //           print("page == 1 $page");
  //           globalFeedPagingController.itemList = [];
  //         }
  //         if (isLastPage) {
  //           print("isLastPage = $isLastPage");
  //           globalFeedPagingController.appendLastPage(data);
  //         } else {
  //           print("isNotLastPage = $isLastPage");
  //           final nextPageKey = page + 1;
  //           globalFeedPagingController.appendPage(data, nextPageKey);
  //         }
  //         emit(state.copyWith( status: StateStatus.success));
  //       });
  // }

  Future<void> getUserTweets(int page, String userId) async {
    final response = await _getUserTweetsUseCase(
        GetUserTweetsParams(page: page, userId: userId));
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        userTweetsPagingController.itemList = [];
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        userTweetsPagingController.appendLastPage(data);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        userTweetsPagingController.appendPage(data, nextPageKey);
      }
      emit(state.copyWith(userTweets: data, status: StateStatus.success));
    });
  }

  Future<void> getTwitterPost(
      BuildContext context, String postId, String newCommentId) async {
    final response = await _getTwitterPostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      emit(state.copyWith(postDetails: data, status: StateStatus.success));
    });
  }

  // react on a post
  Future<bool> onReact({required TwitterPostReactParams params}) async {
    var response = await _twitterPostReactUseCase(params);
    bool result = false;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      result = data;
      emit(state.copyWith(status: StateStatus.success));
      print(data);
    });
    return result;
  }

  // share post
  void onShare({required String postId}) async {
    var response = await _twitterSharePostUseCase(postId);
    response.fold(
        (failure) => emit(state.copyWith(
            shareSuccess: false, failure: failure, status: StateStatus.error)),
        (data) => emit(
            state.copyWith(shareSuccess: true, status: StateStatus.success)));
  }

  // report
  Future<bool> onReport(TwitterReportParams params) async {
    var response = await _twitterReportUseCase(params);

    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      emit(state.copyWith(reported: data, status: StateStatus.success));
      print(data);
    });

    return state.reported!;
  }

  // react on a comment
  void onCommentReact({required TwitterCommentReactParams params}) async {
    await _twitterCommentReactUseCase(params);
  }

  // request verification
  onRequestVerification({required TwitterDocumentationParams params}) async {
    var response = await _requestDocumentUseCase(params);
    response.fold(
      (l) => emit(
        state.copyWith(
          failure: l,
          status: StateStatus.error,
        ),
      ),
      (data) => emit(
        state.copyWith(
          reportSuccess: data,
          status: StateStatus.success,
        ),
      ),
    );
  }

  final PagingController<int, TwitterPostCommentEntity>
      commentsPagingController = PagingController(firstPageKey: 1);

  Future<void> getPostComments(
      {required BuildContext context,
      required String postId,
      required int page}) async {
    final response = await _getTwitterPostCommentsUseCase(
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

  final PagingController<int, TwitterCommentReplyEntity>
      repliesPagingController = PagingController(firstPageKey: 1);

  Future<void> getCommentReplies(
      {required BuildContext context,
      required String postId,
      required int page}) async {
    final response = await _twitterCommentRepliesUseCase(
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
          commentReplies: data,
          status: StateStatus.success,
        ),
      );
    });
  }

  Future<TwitterPostCommentEntity> onPostComment(
      {required TwitterPostCommentParams params}) async {
    var response = await _twitterPostCommentUseCase(params);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) {
        postsPagingController.itemList
            ?.firstWhere((element) => element.id == params.postId)
            .commentsCount = (postsPagingController.itemList!
                .firstWhere((element) => element.id == params.postId)
                .commentsCount! +
            1);

        if (state.postDetails != null) {
          state.postDetails?.commentsCount =
              (state.postDetails!.commentsCount! + 1);
        }
        emit(state.copyWith(newComment: data, status: StateStatus.success));
      },
    );
    return state.newComment!;
  }

  // add comment reply usecase
  Future<TwitterCommentReplyEntity> onCommentReply(
      {required TwitterCommentReplyParams params}) async {
    var response = await _twitterCommentReplyUseCase(params);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) {
        postsPagingController.itemList
            ?.firstWhere((element) => element.id == params.postId)
            .commentsCount = (postsPagingController.itemList!
                .firstWhere((element) => element.id == params.postId)
                .commentsCount! +
            1);
        print("newReply${data.id}");
        emit(state.copyWith(newReply: data, status: StateStatus.success));
      },
    );
    print("newReply${state.newReply?.id}");

    return state.newReply!;
  }

  // show comment replies
  showReplies(TwitterPostCommentEntity comment) {
    emit(ShowRepliesLoadingState());
    comment.showReplies = !comment.showReplies;
    emit(ShowRepliesSuccessState());
  }

  uploadPersonalPhoto() {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("PersonalPhoto name ${data.file}");
          print("PersonalPhotoId: ${data.mediaId}");
          emit(
              state.copyWith(personalPhoto: data, status: StateStatus.success));
        });
  }

  removePersonalPhoto() {
    state.copyWith(personalPhoto: null, status: StateStatus.success);
  }

  removeFrontId() {
    state.copyWith(frontId: null, status: StateStatus.success);
  }

  removeBackId() {
    print('Before: ${state.backId?.mediaId}');
    UploadFileEntity backId = UploadFileEntity(mediaId: '', file: XFile(''));
    state.copyWith(backId: null);
    state.copyWith(status: StateStatus.success);
    print(state.backId?.mediaId);
  }

  uploadFrontId() {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("FrontId name ${data.file}");
          print("FrontId: ${data.mediaId}");
          emit(state.copyWith(frontId: data, status: StateStatus.success));
        });
  }

  uploadBackId() {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("BackId name ${data.file}");
          print("BackId: ${data.mediaId}");
          emit(state.copyWith(backId: data, status: StateStatus.success));
        });
  }

  void deletePost(
      {required BuildContext context, required String postId}) async {
    final response = await _deleteTwitterPostUseCase(postId);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (r) {
      postsPagingController.itemList?.removeWhere((e) => e.id == postId);
      emit(state.copyWith(posts: postsPagingController.itemList));
      showSuccessMessage(context, "Post delete successfully");
    });
  }

  void hidePost({required BuildContext context, required String postId}) async {
    final response = await _hideTwitterPostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      postsPagingController.itemList?.removeWhere((e) => e.id == postId);
      emit(state.copyWith(posts: postsPagingController.itemList));
      showSuccessMessage(context, "Post hide successfully");
    });
  }

  // edit on a comment
  Future<bool> editComment({required TwitterPostCommentParams params}) async {
    var response = await _editTwitterCommentUseCase(params);
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
    final response = await _deleteTwitterCommentUseCase(commentId);
    bool result = false;
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (r) {
      result = r;
      if (from == 'posts') {
        var currentPost = postsPagingController.itemList
            ?.firstWhere((element) => element.id == postId);
        print("commmmmment count${currentPost?.commentsCount}");

        currentPost?.commentsCount = (currentPost.commentsCount! - 1);
      }
      commentsPagingController.itemList
          ?.removeWhere((element) => element.id == commentId);
      emit(state.copyWith(status: StateStatus.success));
      showSuccessMessage(context, "Comment delete successfully");
    });
    return result;
  }
}
