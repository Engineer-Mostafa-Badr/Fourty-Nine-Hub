import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/usecases/get_instagram_feed_usecase.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_comment_replies.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_post_comments.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/comment_react_usecase.dart';
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

  InstagramCubit(this._getFeedUseCase, this._advertisementUseCase, this._postReactUseCase, this._getPostCommentsUseCase, this._getPostCommentRepliesUseCase, this._postCommentUseCase, this._replyOnCommentUseCase, this._commentReactUseCase) : super(InstagramState());


  void loadData() async {
    await getFeed(1);
    feedPagingController.addPageRequestListener((pageKey) {
      print("initStatePageKey : $pageKey");
      getFeed(pageKey);
    });
  }


  void onRefresh()async{
    emit(state.copyWith(advertisementsPage:0));
    feedPagingController.refresh();
  }


  final PagingController<int, PostEntity> feedPagingController =
  PagingController(firstPageKey: 1);


// get feed posts
  Future<void> getFeed(int page) async {
    final response = await _getFeedUseCase(TwitterFeedParams(limit: 5, page: page));
    List<PostEntity> advertisements=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) async{
          if(data.isNotEmpty){
            advertisements = await getAdvertisements();
          }
          List<PostEntity> totalPosts=[];
          totalPosts.addAll(data);
          totalPosts.addAll(advertisements);
          final isLastPage = totalPosts.length < (4);
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

  // get advertisements
  Future<List<PostEntity>> getAdvertisements() async {
    final response =
    await _advertisementUseCase(TwitterFeedParams(limit: 1, page: state.advertisementsPage!+1));
    List<PostEntity> advertisements=[];
    response.fold(
            (l) => emit(state.copyWith(failure: l, status: StateStatus.error)),
            (data) {
          advertisements.addAll(data);
          int? page = state.advertisementsPage!+1;
          emit(state.copyWith(advertisementsPage: page,posts: data, status: StateStatus.success));
        });
    print("advertisements:${advertisements.length}");
    return advertisements;
  }


  void changeIndex(int index){
    emit(state.copyWith(pageIndex: index));
  }


// react on a post
  Future<bool> onReact({required PostReactParams params}) async {
    var response =await _postReactUseCase(params);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (r){
          value=r;
        }
    );
    return value;

  }


  void showPostComments(
      {required BuildContext context, required String postId}) async {
    final response = await _getPostCommentsUseCase(postId);
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (data) => bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: InstagramPostComments(
                comments: data,
                postId: postId,
                onAddComment: (PostCommentParams params) {
                  onPostComment(params: params);
                }),),);
  }

  // show comments with rendered data

  void showPostCommentReplies(
      {required BuildContext context, required String commentId,required String postId}) async {
    final response = await _getPostCommentRepliesUseCase(commentId);
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (data) => bottomSheet(
            context: context,
            isScrollControlled: true,
            widget: InstagramCommentReplies(
              replies: data,
              postId: postId, commentId: commentId, onAddReply: (ReplyOnCommentParams params) {
              replyOnComment(params: params);
            },
            )));
  }

// add comment usecase
  Future<CommentEntity> onPostComment({required PostCommentParams params}) async {
    var response = await _postCommentUseCase(params);
    CommentEntity? model;
    response.fold((failure)=>emit(state.copyWith(failure: failure,status: StateStatus.error),),
            (data){
          model=data;
          emit(state.copyWith(newComment: data,status: StateStatus.success));
        }
    );
    return model!;
  }

  // add comment usecase
  Future<CommentEntity> replyOnComment({required ReplyOnCommentParams params}) async {
    var response = await _replyOnCommentUseCase(params);
    CommentEntity? model;
    response.fold((failure)=>emit(state.copyWith(failure: failure,status: StateStatus.error),),
            (data){
          model=data;
          emit(state.copyWith(newComment: data,status: StateStatus.success));
        }
    );
    return model!;
  }


  // react on a comment
  Future<bool> onCommentReact({required PostReactParams params}) async {
    var response =await _commentReactUseCase(params);
    bool value = false;
    response.fold(
            (failure) =>
            emit(state.copyWith(failure: failure, status: StateStatus.error)),
            (r){
          value=r;
        }
    );
    return value;

  }

}
