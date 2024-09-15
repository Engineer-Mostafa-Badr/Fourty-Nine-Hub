import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/comment_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/bloc/twitter_bloc.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_post_comments.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserTweets extends StatefulWidget {
  const UserTweets({super.key, required this.userData});
  final UserProfileEntity userData;
  @override
  State<UserTweets> createState() => _UserTweetsState();
}

class _UserTweetsState extends State<UserTweets> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TwitterCubit>(
      create: (_) => serviceLocator()..loadUserTweets(widget.userData.id),
      child:
          BlocConsumer<TwitterCubit, TwitterState>(listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? UnknownFailure(''),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<TwitterCubit>();
        return PagedSliverList<int, TwitterPostEntity>(
          // padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
          pagingController: controller.userTweetsPagingController,
          // shrinkWrap: true,
          // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
              noItemsFoundIndicatorBuilder: (context) {
                print(controller.userTweetsPagingController.itemList?.length);
                return Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Center(
                      child: Text(
                        "No Posts",
                        style: TextStyle(
                          fontSize: 18.sp,
                        ),
                      ),
                    ));
              },
              itemBuilder: (context, item, index) {
                final user = context.read<UserCubit>().state.data;
                return state.status == StateStatus.success
                    ? TwitterPostCard(
                        fromProfile: user?.id == widget.userData.id,
                        post: controller
                            .userTweetsPagingController.itemList![index],
                        onReact: () async {
                          var result = await controller.onReact(
                              params: TwitterPostReactParams(
                                  postId: controller.userTweetsPagingController
                                      .itemList![index].id,
                                  react: 'love'));
                          if (result == true) {
                            if (controller.userTweetsPagingController
                                    .itemList?[index].isReact ==
                                false) {
                              controller.userTweetsPagingController
                                  .itemList?[index].isReact = true;
                              controller.userTweetsPagingController
                                  .itemList?[index].loveCount = (controller
                                      .userTweetsPagingController
                                      .itemList![index]
                                      .loveCount! +
                                  1);
                              setState(() {});
                            } else {
                              controller.userTweetsPagingController
                                  .itemList?[index].isReact = false;
                              controller.userTweetsPagingController
                                  .itemList?[index].loveCount = (controller
                                      .userTweetsPagingController
                                      .itemList![index]
                                      .loveCount! -
                                  1);
                              setState(() {});
                            }
                          }
                        },
                        shareSuccess: state.shareSuccess,
                        onShare: () {
                          var tweet = controller
                              .userTweetsPagingController.itemList![index];
                          controller.onShare(
                            postId: tweet.isShared == true
                                ? tweet.mainPost.id
                                : tweet.id,
                          );
                          setState(() {});
                        },
                        showPostComments: (String v) {
                          final user = context.read<UserCubit>().state.data;

                          print(
                              "mainId ${controller.userTweetsPagingController.itemList![index].id}");
                          bottomSheet(
                            context: context,
                            isScrollControlled: true,
                            widget: BlocProvider.value(
                              value: serviceLocator<TwitterCubit>()
                                ..loadComments(
                                    context,
                                    controller.userTweetsPagingController
                                        .itemList![index].id),
                              child: TwitterPostComments(
                                comments: const [],
                                postId: controller.userTweetsPagingController
                                    .itemList![index].id,
                                user: user,
                                onAddComment:
                                    (TwitterPostCommentParams params) async {
                                  var result = await controller.onPostComment(
                                      params: params);
                                  controller.userTweetsPagingController.itemList
                                      ?.firstWhere((element) =>
                                          element.id == params.postId)
                                      .commentsCount = (controller
                                          .userTweetsPagingController.itemList!
                                          .firstWhere((element) =>
                                              element.id == params.postId)
                                          .commentsCount! +
                                      1);
                                  setState(() {});
                                  return result;
                                },
                                onAddReply:
                                    (TwitterCommentReplyParams params) async {
                                  final result = await controller
                                      .onCommentReply(params: params);
                                  controller.userTweetsPagingController.itemList
                                      ?.firstWhere((element) =>
                                          element.id == params.postId)
                                      .commentsCount = (controller
                                          .userTweetsPagingController.itemList!
                                          .firstWhere((element) =>
                                              element.id == params.postId)
                                          .commentsCount! +
                                      1);
                                  setState(() {});
                                  return result;
                                },
                                onCommentReact:
                                    (TwitterCommentReactParams params) {
                                  controller.onCommentReact(params: params);
                                },
                                onGetReplies: (String id,
                                    TwitterPostCommentEntity comment) async {
                                  // getCommentReplies(
                                  //   context: context,
                                  //   commentId: id,
                                  //   comment: comment,
                                  //   postId: postId, userData: userData,
                                  // );
                                },
                                newCommentId: '',
                                state: state,
                                onReport: (TwitterReportParams params) {
                                  controller.onReport(params);
                                },
                                onEditComment:
                                    (TwitterPostCommentParams params) async =>
                                        await controller.editComment(
                                            params: params),
                                onDeleteComment: (String id) async {
                                  var result = await controller.deleteComment(
                                      context: context,
                                      commentId: id,
                                      postId: controller
                                          .userTweetsPagingController
                                          .itemList![index]
                                          .mainPost
                                          .id,
                                      from: 'details');
                                  controller
                                      .userTweetsPagingController
                                      .itemList![index]
                                      .commentsCount = ((controller
                                          .userTweetsPagingController
                                          .itemList![index]
                                          .commentsCount)! -
                                      1);
                                  setState(() {});
                                  return result;
                                },
                              ),
                            ),
                          );
                        },
                        getPost: () {
                          controller.getTwitterPost(
                              context,
                              controller.userTweetsPagingController
                                  .itemList![index].mainPost.id,
                              state.newCommentId ?? '');
                        },
                        onReport: (TwitterReportParams params) {
                          controller.onReport(params);
                        },
                        deletePost: (String id) {
                          controller.deletePost(context: context, postId: id);
                        },
                        hidePost: (String id) {
                          controller.hidePost(context: context, postId: id);
                        },
                        onDeleteComment: (String id) async {
                          var result = await controller.deleteComment(
                              context: context,
                              commentId: id,
                              postId: controller.userTweetsPagingController
                                  .itemList![index].mainPost.id,
                              from: 'details');
                          controller.userTweetsPagingController.itemList?[index]
                              .commentsCount = (controller
                                  .userTweetsPagingController
                                  .itemList![index]
                                  .commentsCount! -
                              1);
                          setState(() {});
                          return result;
                        },
                        onEditComment:
                            (TwitterPostCommentParams params) async =>
                                controller.editComment(params: params),
                      )
                    : Center(
                        child: Label(
                            text: getFailureMessage(
                          state.failure ?? UnknownFailure(''),
                          context,
                        )),
                      );
              },
              noMoreItemsIndicatorBuilder: (context) => Container(),
              firstPageProgressIndicatorBuilder: (context) => Container(
                  margin: const EdgeInsets.only(top: 150),
                  child: const CupertinoActivityIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const CupertinoActivityIndicator()),
        );
      }),
    );
  }
}
