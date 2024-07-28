import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/upload_file.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_post_comments_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/get_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/request_document_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/share_twitter_post_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_post_details.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_replied.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_comments.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

part 'twitter_state.dart';

class TwitterCubit extends Cubit<TwitterState> {
  final GetTwitterFeedUseCase _getFeedUseCase;
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
  ) : super(const TwitterState());

  void loadData() async {
    //   await getFeed(1);
    getFeed(1);
    postsPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
  }

  final int reactCount = 0;

  final int pageSize = 10;
  final PagingController<int, TwitterPostEntity> postsPagingController =
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

  Future<void> getTwitterPost(
      BuildContext context, String postId, String newCommentId) async {
    final response = await _getTwitterPostUseCase(postId);
    response.fold(
        (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
        (data) {
      bottomSheet(
          context: context,
          isScrollControlled: true,
          widget: TwitterPostDetails(
            post: data,
            onReact: () {
              onReact(
                params: TwitterPostReactParams(
                  postId: postId,
                  react: 'love',
                ),
              );
            },
            onShare: () {
              onShare(postId: postId);
            },
            showPostComments: (id) {
              showPostComments(
                  context: context,
                  postId: postId,
                  newCommentId: newCommentId,
                  user: '');
            },
            onReport: (TwitterReportParams params) {
              onReport(params);
            },
          ));
    });
  }

  // react on a post
  void onReact({required TwitterPostReactParams params}) async {
    await _twitterPostReactUseCase(params);
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

    bool? reported;
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
        (data) {
      emit(state.copyWith(reported: data, status: StateStatus.success));
      reported = data;
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

  void showPostComments(
      {required BuildContext context,
      required String postId,
      required String newCommentId,
      required dynamic user}) async {
    final response = await _getTwitterPostCommentsUseCase(postId);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) => bottomSheet(
        context: context,
        isScrollControlled: true,
        widget: TwitterPostComments(
          comments: data,
          postId: postId,
          user: user,
          onAddComment: (PostCommentParams params) =>
              onPostComment(params: params),
          onAddReply: (TwitterCommentReplyParams params) {
            onCommentReply(params: params);
          },
          onCommentReact: (TwitterCommentReactParams params) {
            onCommentReact(params: params);
          },
          onGetReplies: (String id, TwitterPostCommentEntity comment) async {
            getCommentReplies(
              context: context,
              commentId: id,
              comment: comment,
              postId: postId,
            );
          },
          newCommentId: newCommentId,
          state: state,
          onReport: (TwitterReportParams params) {
            onReport(params);
          },
        ),
      ),
    );
  }

  List<TwitterCommentReplyEntity> replies = [];
  getCommentReplies(
      {required BuildContext context,
      required String commentId,
      required String postId,
      required TwitterPostCommentEntity comment}) async {
    final response = await _twitterCommentRepliesUseCase(commentId);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) {
        emit(state.copyWith(commentReplies: data,status: StateStatus.success));
        bottomSheet(
        context: context,
        isScrollControlled: true,
        widget: TwitterCommentReplies(
          replies: data,
          onAddReply: (TwitterCommentReplyParams params) {
            onCommentReply(params: params);
          },
          commentId: commentId,
          postId: postId,
          onReplyReact: (String id) {
            onCommentReact(
                params:
                    TwitterCommentReactParams(commentId: id, react: 'love'));
          },
          onReport: (TwitterReportParams params) {
            onReport(params);
          },
        ),
      );
      },
    );
  }

  // add comment usecase
  Future<TwitterPostCommentEntity> onPostComment(
      {required PostCommentParams params}) async {
    var response = await _twitterPostCommentUseCase(params);
    response.fold(
      (failure) =>
          emit(state.copyWith(failure: failure, status: StateStatus.error)),
      (data) {
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
}
