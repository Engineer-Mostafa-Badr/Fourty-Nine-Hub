import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_global_post_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FacebookGlobalBody extends StatelessWidget {
  const FacebookGlobalBody({super.key, required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialPostsCubit>(
      create: (_) => serviceLocator()..loadGlobalData(),
      child: BlocConsumer<SocialPostsCubit, SocialPostsState>(
          listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure!,
              context,
            ),
          );
        }
      },
          builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
        return RefreshIndicator(
          onRefresh: () async => controller.refreshGlobalPosts(),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              BlocBuilder<SocialPostsCubit, SocialPostsState>(
                builder: (context, state) {
                  final controller = context.read<SocialPostsCubit>();
                  return PagedSliverList<int, PostEntity>(
                    pagingController: controller.globalFeedPagingController,
                    builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                        noItemsFoundIndicatorBuilder: (context) {
                          print(controller.globalFeedPagingController.itemList?.length);
                          return const Padding(
                              padding: EdgeInsets.only(top: 200),
                              child: Center(
                                child: Text(
                                  "No Media",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ));
                        },
                        itemBuilder: (context, item, index) {
                          final user = context.read<UserCubit>().state.data;

                          return state.status == StateStatus.success
                              ? Column(
                            children: [
                              FacebookGlobalPostCard(
                                deletePost: (String postId) => controller
                                    .deletePost(context: context, postId: postId),
                                hidePost: (String postId) => controller.hidePost(
                                    context: context, postId: postId),
                                post: controller
                                    .globalFeedPagingController.itemList![index],
                                onReact: (PostReactParams item) => controller
                                    .onReact(params: item, from: 'posts'),
                                showPostComments: (String v) {
                                  bottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      widget: BlocProvider.value(
                                        value: serviceLocator<SocialPostsCubit>()
                                          ..loadComments(
                                              context,
                                              controller.globalFeedPagingController
                                                  .itemList![index].id),
                                        child: FacebookPostComments(
                                          postId: controller.globalFeedPagingController
                                              .itemList![index].id,
                                          onAddComment:
                                              (PostCommentParams params) {
                                            return controller.onPostComment(
                                                params: params, from: 'feed');
                                          },
                                          onCommentReply:
                                              (ReplyOnCommentParams params) {
                                            return controller.replyOnComment(
                                              params: ReplyOnCommentParams(
                                                  postId: params.postId,
                                                  content: params.content,
                                                  commentId: params.commentId),
                                              from: 'feed',
                                            );
                                          },
                                          onDeleteComment: (String id) async {
                                            return await controller.deleteComment(
                                                context: context,
                                                commentId: id,
                                                postId: controller
                                                    .globalFeedPagingController
                                                    .itemList![index]
                                                    .id,
                                                from: 'feed');
                                            // print(result);
                                          },
                                          onDeleteReply: (String id) async {
                                            return await controller.deleteComment(
                                                context: context,
                                                commentId: id,
                                                postId: controller
                                                    .globalFeedPagingController
                                                    .itemList![index]
                                                    .id,
                                                from: 'feed');
                                          },
                                          from: 'feed',
                                          onEditComment:
                                              (PostCommentParams params) async {
                                            var result = await controller
                                                .editComment(params: params);
                                            return result;
                                          },
                                        ),
                                      ));
                                },
                                showPostDetails: (PostEntity post) => bottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    widget: BlocProvider.value(
                                      value: serviceLocator<SocialPostsCubit>()
                                        ..loadPostDetails(
                                            context,
                                            controller
                                                .globalFeedPagingController
                                                .itemList![index]
                                                .isShared ==
                                                true
                                                ? controller.globalFeedPagingController
                                                .itemList![index].mainPost!.id
                                                : controller.globalFeedPagingController
                                                .itemList![index].id),
                                      child: PostDetailsPage(
                                        comments: const [],
                                        postId: controller.globalFeedPagingController
                                            .itemList![index].id,
                                        deletePost: (String postId) =>
                                            controller.deletePost(
                                                context: context, postId: postId),
                                        hidePost: (String postId) =>
                                            controller.hidePost(
                                                context: context, postId: postId),
                                        onAddComment:
                                            (PostCommentParams params) =>
                                            controller.onPostComment(
                                                params: params,
                                                from: 'details'),
                                        onReact: (params) => controller.onReact(
                                            params: params, from: 'posts'),
                                        showPostComments: (postId) {},
                                        showPostDetails: (PostEntity post) {},
                                        // post: controller.globalFeedPagingController.itemList![index],

                                        onCommentReply:
                                            (ReplyOnCommentParams params) {
                                          return controller.replyOnComment(
                                            params: ReplyOnCommentParams(
                                                postId: params.postId,
                                                content: params.content,
                                                commentId: params.commentId),
                                            from: 'details',
                                          );
                                        },
                                        onDeleteComment: (String id) async {
                                          return await controller.deleteComment(
                                              context: context,
                                              commentId: id,
                                              postId: controller
                                                  .globalFeedPagingController
                                                  .itemList![index]
                                                  .id,
                                              from: 'feed');
                                          // print(result);
                                        },
                                        onDeleteReply: (String id) async {
                                          return await controller.deleteComment(
                                              context: context,
                                              commentId: id,
                                              postId: controller
                                                  .globalFeedPagingController
                                                  .itemList![index]
                                                  .id,
                                              from: 'feed');
                                        },
                                        onEditComment:
                                            (PostCommentParams params) async {
                                          var result = await controller
                                              .editComment(params: params);
                                          return result;
                                        },
                                      ),
                                    )),
                                isMyPost: controller.globalFeedPagingController
                                    .itemList?[index].user !=
                                    null
                                    ? (user?.id ==
                                    controller.globalFeedPagingController
                                        .itemList?[index].user.id)
                                    : false,
                                onShare: (String id) {
                                  controller.onShare(postId: id);
                                },
                                from: 'posts',
                                index: index,
                              ),
                              Container(
                                width: double.infinity,
                                height: 5,
                                color: AppColors.TXTFIELD_GRAY_COLOR2,
                              ),
                            ],
                          )
                              : Center(
                            child: Label(
                                text: getFailureMessage(
                                  state.failure ??  UnknownFailure(''),
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

                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
