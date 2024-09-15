import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_people_you_may_know.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../stories/presentation/cubit/stories_cubit.dart';

class FacebookBody extends StatelessWidget {
  const FacebookBody({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SocialPostsCubit>(
          create: (_) => serviceLocator()..loadData(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<StoryCubit>()..fetchStories(),
          // create: (context) => serviceLocator<StoryCubit>(),
        ),
      ],
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
      }, builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
        return RefreshIndicator(
          onRefresh: () async {
            context.read<StoryCubit>().fetchStories(loadMore: true);
            controller.onRefresh();
          },
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 5.h,
                      color: AppColors.LIGHT_GRAY_COLOR,
                    ),
                    const Stories(),
                  ],
                ),
              ),
              const SliverToBoxAdapter(
                child: BuildPeopleYouMayKnow(),
              ),
              BlocBuilder<SocialPostsCubit, SocialPostsState>(
                builder: (context, state) {
                  final controller = context.read<SocialPostsCubit>();
                  return PagedSliverList<int, PostEntity>(
                    pagingController: controller.feedPagingController,
                    builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                      noItemsFoundIndicatorBuilder: (context) {
                        return Center(
                          child: Text(
                            LocaleKeys.noPosts.localize,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context, item, index) {
                        final user = context.read<UserCubit>().state.data;
                        return Column(
                          children: [
                            FacebookPostCard(
                              deletePost: (String postId) => controller
                                  .deletePost(context: context, postId: postId),
                              hidePost: (String postId) => controller.hidePost(
                                  context: context, postId: postId),
                              post: controller
                                  .feedPagingController.itemList![index],
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
                                            controller.feedPagingController
                                                .itemList![index].id),
                                      child: FacebookPostComments(
                                        postId: controller.feedPagingController
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
                                                  .feedPagingController
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
                                                  .feedPagingController
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
                                                      .feedPagingController
                                                      .itemList![index]
                                                      .isShared ==
                                                  true
                                              ? controller.feedPagingController
                                                  .itemList![index].mainPost!.id
                                              : controller.feedPagingController
                                                  .itemList![index].id),
                                    child: PostDetailsPage(
                                      comments: const [],
                                      postId: controller.feedPagingController
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
                                      // post: controller.feedPagingController.itemList![index],

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
                                                .feedPagingController
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
                                                .feedPagingController
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
                              isMyPost: controller.feedPagingController
                                          .itemList?[index].user !=
                                      null
                                  ? (user?.id ==
                                      controller.feedPagingController
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
                              height: 5.h,
                              color: AppColors.TXTFIELD_GRAY_COLOR2,
                            ),
                          ],
                        );
                      },
                      noMoreItemsIndicatorBuilder: (context) => Container(),
                      firstPageProgressIndicatorBuilder: (context) =>
                          const CupertinoActivityIndicator(),
                      newPageProgressIndicatorBuilder: (context) =>
                          const CupertinoActivityIndicator(),
                    ),
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
