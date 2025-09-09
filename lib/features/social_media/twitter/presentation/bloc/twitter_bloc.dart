import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/enums/base_status_enum.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_posts/domain/usecases/get_post_comments_usecase.dart';
import '../../data/models/profile_model.dart';
import '../../data/models/twitter_post_model.dart';
import '../../domain/entities/twitter_comment_reply_entity.dart';
import '../../domain/entities/twitter_post_comment_entity.dart';
import '../../domain/entities/twitter_post_entity.dart';
import '../../domain/usecases/comment_react_usecase.dart';
import '../../domain/usecases/comment_reply_usecase.dart';
import '../../domain/usecases/delete_twitter_comment_usecase.dart';
import '../../domain/usecases/delete_twitter_post_usecase.dart';
import '../../domain/usecases/edit_twitter_comment_usecase.dart';
import '../../domain/usecases/follow_twitter_usecase.dart';
import '../../domain/usecases/get_feed_usecase.dart';
import '../../domain/usecases/get_global_feed_usecase.dart';
import '../../domain/usecases/get_post_comment_reply_usecase.dart';
import '../../domain/usecases/get_post_comments_usecase.dart';
import '../../domain/usecases/get_twitter_post_usecase.dart';
import '../../domain/usecases/get_user_posts_usecase.dart';
import '../../domain/usecases/hide_twitter_post_usecase.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../../domain/usecases/repost_usecase.dart';
import '../../domain/usecases/request_document_usecase.dart';
import '../../domain/usecases/share_twitter_post_usecase.dart';
import '../../domain/usecases/twitter_report_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:fourtyninehub/routes/pages.dart';

part 'twitter_state.dart';
class TwitterPage<T> {
  final List<T> items;
  final bool hasNextPage;
  final int? nextPage;

  const TwitterPage({
    required this.items,
    required this.hasNextPage,
    required this.nextPage,
  });
}

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
  final GetThreadPostsPageUseCase _getThreadPostsPageUseCase;
  final GetThreadRepliesPageUseCase _getThreadRepliesPageUseCase;
  final GetFollowersCountUseCase _getFollowersCountUseCase;
  final GetFollowingCountUseCase _getFollowingCountUseCase;
  final GetMyThreadsPageUseCase _getMyThreadsPageUseCase;
  final GetUserThreadsPageUseCase _getUserThreadsPageUseCase;
  final TwitterRepostUseCase _repostUseCase;
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
      this._getThreadPostsPageUseCase,
      this._getThreadRepliesPageUseCase,
       this._getFollowersCountUseCase,
      this._getFollowingCountUseCase,
      this._getMyThreadsPageUseCase,
      this._getUserThreadsPageUseCase,
      this._repostUseCase,
      ) : super(const TwitterState());


  void loadGlobalData() async {
    //   await getFeed(1);
    getGlobalFeed(1);
    globalPostsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getGlobalFeed(pageKey);
    });
  }

  void loadComments(BuildContext context, String postId,
      {TwitterPostCommentEntity? comment}) async {
    await getPostComments(
        context: context, postId: postId, page: 1, comment: comment);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getPostComments(
          context: context, postId: postId, page: pageKey, comment: comment);
    });
  }

  void loadReplies(BuildContext context, String commentId,
      {TwitterCommentReplyEntity? reply}) async {
    await getCommentReplies(
        context: context, postId: commentId, page: 1, reply: reply);
    commentsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getCommentReplies(
          context: context, postId: commentId, page: pageKey, reply: reply);
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


  // get global feed posts
  Future<void> getGlobalFeed(int page) async {
    final response = await _getTwitterGlobalFeedUseCase(
      TwitterFeedParams(limit: pageSize, page: page),
    );
    response.fold(
          (l) {
        final ctx = AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(ctx, getFailureMessage(l, ctx));
        emit(state.copyWith(failure: l, status: StateStatus.error));
      },
          (pageData) {
        final items = pageData.items;
        final hasNext = pageData.hasNextPage;
        final next = pageData.nextPage;

        if (page == 1) {
          globalPostsPagingController.itemList = [];
        }

        if (!hasNext || next == null) {
          globalPostsPagingController.appendLastPage(items);
        } else {
          globalPostsPagingController.appendPage(items, next);
        }

        emit(state.copyWith(posts: items, status: StateStatus.success));
      },
    );
  }


   Future<void> loadMyPosts(int page) async {
    final res = await _getMyThreadsPageUseCase(
      MyThreadsPageParams(page: page, limit: pageSize),
    );

    res.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (pageData) {
      debugPrint("🟢 API returned items: ${pageData.items.length}");

      if (page == 1) {
        postsPagingController.itemList = [];
      }

      if (!pageData.hasNextPage || pageData.nextPage == null) {
        postsPagingController.appendLastPage(pageData.items);
      } else {
        postsPagingController.appendPage(pageData.items, pageData.nextPage!);
      }

      debugPrint("📌 postsPagingController now has: ${postsPagingController.itemList?.length}");
      postsPagingController.notifyListeners();

      emit(state.copyWith(myPosts: pageData.items, status: StateStatus.success));
    });
  }

  Future<void> loadUserPostsPage(String userId, int page) async {
    final res = await _getUserThreadsPageUseCase(
      UserThreadsPageParams(userId: userId, page: page, limit: pageSize),
    );

    res.fold((l) {
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (pageData) {
      if (page == 1) {
        userTweetsPagingController.itemList = [];
        userTweetsPagingController.notifyListeners(); // 👈 مهم
      }
      if (!pageData.hasNextPage || pageData.nextPage == null) {
        userTweetsPagingController.appendLastPage(pageData.items);
      } else {
        userTweetsPagingController.appendPage(pageData.items, pageData.nextPage);
      }
      emit(state.copyWith(userTweets: pageData.items, status: StateStatus.success));
    });
  }



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
        (l) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
          emit(state.copyWith(failure: l, status: StateStatus.error));
        },
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

// TwitterCubit
  Future<void> getTwitterPost(BuildContext context, String postId, String newCommentId,
      ) async
  {
    emit(state.copyWith(status: StateStatus.loading, failure: null));

    final response = await _getTwitterPostUseCase(postId);
    response.fold(
          (l) {
        final ctx = AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(ctx, getFailureMessage(l, ctx));
        emit(state.copyWith(failure: l, status: StateStatus.error));
      },
          (data) {
        // data is TwitterPostEntity; if it’s our model, pull the extras
        List<TwitterPostEntity> others = const [];
        List<TwitterPostCommentEntity> replies = const [];
        if (data is TwitterPostModel) {
          others  = List<TwitterPostEntity>.from(data.threadExtraPosts);
          replies = List<TwitterPostCommentEntity>.from(data.threadExtraReplies);
        }

        emit(state.copyWith(
          postDetails: data,        // main post
          threadPosts: others,      // other posts in the thread
          threadReplies: replies,   // replies to main
          status: StateStatus.success,
        ));
      },
    );
  }

  final PagingController<int, TwitterPostEntity> threadPostsPagingController =
  PagingController(firstPageKey: 1);

  final PagingController<int, TwitterPostCommentEntity> threadRepliesPagingController =
  PagingController(firstPageKey: 1);

  void loadThread(String threadId) async {
    // header details (main post) — optional, keep your existing call
    await getTwitterPost(AppPages.router.configuration.navigatorKey.currentContext!, threadId, '');

    // page 1 for both lists
    getThreadPostsPage(threadId, 1);
    getThreadRepliesPage(threadId, 1);

    threadPostsPagingController.addPageRequestListener((pageKey) {
      getThreadPostsPage(threadId, pageKey);
    });

    threadRepliesPagingController.addPageRequestListener((pageKey) {
      getThreadRepliesPage(threadId, pageKey);
    });
  }

  Future<void> getThreadPostsPage(String threadId, int page) async {
    final res = await _getThreadPostsPageUseCase(
      ThreadPageParams(threadId: threadId, page: page, limit: pageSize),
    );
    res.fold((l) {
      final ctx = AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(ctx, getFailureMessage(l, ctx));
      threadPostsPagingController.error = l;
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (pageData) {
      final items  = pageData.items;
      final hasNext = pageData.hasNextPage;
      final next    = pageData.nextPage;

      if (page == 1) threadPostsPagingController.itemList = [];

      if (!hasNext || next == null) {
        threadPostsPagingController.appendLastPage(items);
      } else {
        threadPostsPagingController.appendPage(items, next);
      }

      emit(state.copyWith(threadPosts: [
        ...(state.threadPosts ?? const []),
        ...items,
      ], status: StateStatus.success));
    });
  }

  Future<void> getThreadRepliesPage(String threadId, int page) async {
    final res = await _getThreadRepliesPageUseCase(
      ThreadPageParams(threadId: threadId, page: page, limit: pageSize),
    );
    res.fold((l) {
      final ctx = AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(ctx, getFailureMessage(l, ctx));
      threadRepliesPagingController.error = l;
      emit(state.copyWith(failure: l, status: StateStatus.error));
    }, (pageData) {
      final items  = pageData.items;
      final hasNext = pageData.hasNextPage;
      final next    = pageData.nextPage;

      if (page == 1) threadRepliesPagingController.itemList = [];

      if (!hasNext || next == null) {
        threadRepliesPagingController.appendLastPage(items);
      } else {
        threadRepliesPagingController.appendPage(items, next);
      }

      emit(state.copyWith(threadReplies: [
        ...(state.threadReplies ?? const []),
        ...items,
      ], status: StateStatus.success));
    });
  }



  // react on a post
  Future<bool> onReact({required TwitterPostReactParams params}) async {
    var response = await _twitterPostReactUseCase(params);
    bool result = false;
    response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
        },
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
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
           emit(state.copyWith(
            shareSuccess: false, failure: failure, status: StateStatus.error));},
        (data) => emit(
            state.copyWith(shareSuccess: true, status: StateStatus.success)));
  }

  // report
  Future<bool> onReport(TwitterReportParams params) async {
    var response = await _twitterReportUseCase(params);

    response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
        },
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
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
        
         emit(
        state.copyWith(
          failure: l,
          status: StateStatus.error,
        ),
      );},
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
      TwitterPostCommentEntity? comment,
      required int page}) async {
    final response = await _getTwitterPostCommentsUseCase(
      PostCommentsParams(
        page: page,
        limit: pageSize,
        postId: postId,
      ),
    );
    response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
        },
        (data) {
      List<TwitterPostCommentEntity> list =
          data.where((element) => element.id != comment?.id).toList();

      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        commentsPagingController.itemList = [];

        if (comment != null) {
          print("objectadadsadsa");
          commentsPagingController.itemList?.insert(0, comment);
        }
      }
      if (isLastPage) {
        print("isLastPage = $isLastPage");
        commentsPagingController.appendLastPage(list);
      } else {
        print("isNotLastPage = $isLastPage");
        final nextPageKey = page + 1;
        commentsPagingController.appendPage(list, nextPageKey);
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
      TwitterCommentReplyEntity? reply,
      required int page}) async {
    final response = await _twitterCommentRepliesUseCase(
      PostCommentsParams(
        page: page,
        limit: pageSize,
        postId: postId,
      ),
    );
    response.fold(
        (failure) {
          var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
        },
        (data) {
      List<TwitterCommentReplyEntity> list =
          data.where((element) => element.id != reply?.id).toList();
      final isLastPage = data.length < pageSize;
      if (page == 1) {
        print("page == 1 $page");
        repliesPagingController.itemList = [];
        if (reply != null) {
          print("objectadadsadsa");
          repliesPagingController.itemList?.insert(0, reply);
        }
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
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
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
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
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

  uploadPersonalPhoto({required BuildContext context}) {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("PersonalPhoto name ${data.file}");
          print("PersonalPhotoId: ${data.mediaId}");
          emit(
              state.copyWith(personalPhoto: data, status: StateStatus.success));
        }, context: context);
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

  uploadFrontId({required BuildContext context}) {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("FrontId name ${data.file}");
          print("FrontId: ${data.mediaId}");
          emit(state.copyWith(frontId: data, status: StateStatus.success));
        }, context: context);
  }

  uploadBackId({required BuildContext context}) {
    final UploadFile upload = UploadFile();
    upload.uploadImage(
        subCategoryId: '66a3583454e6e337915514db',
        onUploaded: (UploadFileEntity data) {
          print("BackId name ${data.file}");
          print("BackId: ${data.mediaId}");
          emit(state.copyWith(backId: data, status: StateStatus.success));
        }, context: context);
  }

  void deletePost(
      {required BuildContext context, required String postId}) async {
    final response = await _deleteTwitterPostUseCase(postId);
    response.fold((l) {
      var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
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
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
          emit(state.copyWith(failure: l, status: StateStatus.error));
      },
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
      (failure) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(failure, currentContext));
          emit(state.copyWith(failure: failure, status: StateStatus.error));
      },
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
      (l) {
        var currentContext =
              AppPages.router.configuration.navigatorKey.currentContext!;
          showErrorMessage(
              currentContext, getFailureMessage(l, currentContext));
          emit(state.copyWith(failure: l, status: StateStatus.error));
      },
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

  // follow

  Future<void> loadMyProfileFromUserCubit(
      BuildContext context, {
        required String subCategoryId,
      }) async
  {
    emit(state.copyWith(profileStatus: StateStatus.loading));

    final user = context.read<UserCubit>().state.data;
    if (user == null) {
      emit(state.copyWith(profileStatus: StateStatus.error));
      return;
    }

    // fire both requests in parallel
    final followersF = _getFollowersCountUseCase(subCategoryId);
    final followingF = _getFollowingCountUseCase(subCategoryId);

    final results = await Future.wait([followersF, followingF]);

    int followers = 0;
    int following = 0;

    final followersEither = results[0] as Either<Failure, int>;
    final followingEither = results[1] as Either<Failure, int>;

    followersEither.fold(
          (l) {
        final ctx = AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(ctx, getFailureMessage(l, ctx));
      },
          (r) => followers = r,
    );

    followingEither.fold(
          (l) {
        final ctx = AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(ctx, getFailureMessage(l, ctx));
      },
          (r) => following = r,
    );

    // Compose profile from UserCubit + counts
    final profile = TwitterProfileEntity(
      id: user.id ?? '',
      firstName: user.firstName ?? '',
      lastName: user.lastName ?? '',
      userName: (user.username ?? user.username ?? user.email?.split('@').first ?? '').toString(),
      bio: user.bio,
      avatarUrl: user.profilePicture,
      coverUrl: user.profileCover,
      joinedAt: user.birthday ?? DateTime.now(),
      isVerified: (user.isDocument == true) || (user.isAccountVerified == true),
      isMe: true,
      isFollowing: false, // self
      followersCount: followers,
      followingCount: following,
    );

    emit(state.copyWith(
      profile: profile,
      followersCount: followers,
      followingCount: following,
      profileStatus: StateStatus.success,
    ));
  }

  void bootstrapProfile(TwitterProfileEntity p) {
    emit(state.copyWith(
      profile: p,
      profileStatus: StateStatus.success,
    ));
  }

  // loads only counts for a given user (followers/following)
  Future<void> loadCountsForUser({
    required String userId,
    required String subCategoryId,
  }) async {
    emit(state.copyWith(profileStatus: StateStatus.loading));

    final followersEither = await _getFollowersCountUseCase(subCategoryId);
    final followingEither = await _getFollowingCountUseCase(subCategoryId);

    int followers = 0;
    int following = 0;

    followersEither.fold((l) {}, (r) => followers = r);
    followingEither.fold((l) {}, (r) => following = r);

    emit(state.copyWith(
      followersCount: followers,
      followingCount: following,
      profileStatus: StateStatus.success,
    ));
  }

// twitter_cubit.dart  (your onRepost)

  Future<void> onRepost({required String postId}) async {
    final result = await _repostUseCase(postId);

    result.fold((failure) {
      emit(state.copyWith(failure: failure, status: StateStatus.error));
    }, (repostId) {
      // 1) update lists held in state (feed, myPosts, userTweets)
      List<TwitterPostEntity> _bump(List<TwitterPostEntity> src) => src.map((p) {
        if (p.id != postId) return p;
        final already = p.isReposted ?? false;
        return TwitterPostEntity(
          id: p.id,
          content: p.content,
          isLiked: p.isLiked,
          postShare: p.postShare,
          images: p.images,
          shares: p.shares,
          love: p.love,
          isReact: p.isReact,
          user: p.user,
          commentPrivacy: p.commentPrivacy,
          isShared: p.isShared,
          commentsCount: p.commentsCount,
          sharesCount: p.sharesCount,
          loveCount: p.loveCount,
          mainPost: p.mainPost,
          photo: p.photo,
          thread: p.thread,
          createdAt: p.createdAt,
          comments: p.comments,
          repostCount: (p.repostCount ?? 0) + (already ? -1 : 1),
          isReposted: !already,
        );
      }).toList();

      final newPosts     = _bump(state.posts);
      final newMyPosts   = _bump(state.myPosts);
      final newUserPosts = _bump(state.userTweets);

      emit(state.copyWith(
        status: StateStatus.success,
        posts: newPosts,
        myPosts: newMyPosts,
        userTweets: newUserPosts,
        // optional: a boolean like repostSuccess if you track it
      ));

      // 2) also update the PagingControllers currently on screen
      void _touch(PagingController<int, TwitterPostEntity> pc) {
        final list = pc.itemList;
        if (list == null) return;
        for (var i = 0; i < list.length; i++) {
          if (list[i].id == postId) {
            final p = list[i];
            final already = p.isReposted ?? false;
            p.isReposted  = !already;
            p.repostCount = (p.repostCount ?? 0) + (already ? -1 : 1);
            break;
          }
        }
        pc.notifyListeners();
      }

      _touch(globalPostsPagingController);
      _touch(postsPagingController);
      _touch(userTweetsPagingController);
    });
  }


}
