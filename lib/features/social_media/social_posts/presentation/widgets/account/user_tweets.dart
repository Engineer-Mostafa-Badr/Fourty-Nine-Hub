import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
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

class UserTweets extends StatefulWidget {
  const UserTweets({super.key, required this.userData});
  final UserEntity userData;
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
              state.failure ?? const UnknownFailure(),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<TwitterCubit>();
        return RefreshIndicator(
          onRefresh: () async => controller.loadUserTweets(widget.userData.id),
          child: state.status == StateStatus.success
              ? PagedListView<int, TwitterPostEntity>(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  pagingController: controller.userTweetsPagingController,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  builderDelegate: PagedChildBuilderDelegate<TwitterPostEntity>(
                      noItemsFoundIndicatorBuilder: (context) {
                        print(controller
                            .userTweetsPagingController.itemList?.length);
                        return const Padding(
                            padding: EdgeInsets.only(top: 200),
                            child: Center(
                              child: Text(
                                "No Posts",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ));
                      },
                      itemBuilder: (context, item, index) {
                        return TwitterPostCard(
                          post: controller
                              .userTweetsPagingController.itemList![index],
                          onReact: () {
                            controller.onReact(
                                params: TwitterPostReactParams(
                                    postId: controller
                                        .userTweetsPagingController
                                        .itemList![index]
                                        .id,
                                    react: 'love'));
                            controller.userTweetsPagingController
                                    .itemList?[index].isReact =
                                !controller.userTweetsPagingController
                                    .itemList![index].isReact!;
                          },
                          shareSuccess: state.shareSuccess,
                          onShare: () {
                            controller.onShare(
                              postId: controller.userTweetsPagingController
                                  .itemList![index].id,
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
                              widget: TwitterPostComments(
                                comments: [],
                                postId: controller.userTweetsPagingController
                                    .itemList![index].id,
                                user: user,
                                onAddComment:
                                    (TwitterPostCommentParams params) =>
                                        controller.onPostComment(
                                            params: params),
                                onAddReply: (TwitterCommentReplyParams params) {
                                  controller.onCommentReply(params: params);
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
                              ),
                            );
                          },
                          getPost: () {
                            controller.getTwitterPost(
                                context,
                                controller.userTweetsPagingController
                                    .itemList![index].mainPost.id,
                                state.newCommentId ?? '',
                                widget.userData);
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
                        );
                      },
                      noMoreItemsIndicatorBuilder: (context) => Container(),
                      firstPageProgressIndicatorBuilder: (context) => Container(
                          margin: const EdgeInsets.only(top: 150),
                          child: const CupertinoActivityIndicator()),
                      newPageProgressIndicatorBuilder: (context) =>
                          const CupertinoActivityIndicator()),
                )
              : Center(
                  child: Label(
                      text: getFailureMessage(
                    state.failure ?? const UnknownFailure(),
                    context,
                  )),
                ),
        );
      }),
    );
  }
}
