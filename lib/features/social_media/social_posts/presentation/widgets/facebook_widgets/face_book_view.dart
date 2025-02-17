import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/normal_post_screen.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/create_post_banner.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_advirtesement_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_tweet_card.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';

class FaceBookView extends StatefulWidget {
  const FaceBookView({super.key});

  @override
  State<FaceBookView> createState() => _FaceBookViewState();
}

class _FaceBookViewState extends State<FaceBookView> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SocialPostsCubit>().getAllFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
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
          controller.loadData();
          context.read<StoryCubit>()
            ..fetchStories(loadMore: true)
            ..getMutedStories();
          controller.onRefresh();
        },
        child: ListView(
            controller: _scrollController,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  CreatePostBanner(),
                  Container(
                    width: double.infinity,
                    height: 5.h,
                    color: AppColors.LIGHT_GRAY_COLOR,
                  ),
                  const Stories(),
                ],
              ),
              // BuildPeopleYouMayKnow(),
              controller.loadFaceData?Center(
                child: CircularProgressIndicator(),
              ):Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller
                          .allFeed.length,
                      itemBuilder: (context, index) {
                        final user = context.read<UserCubit>().state.data;
                        var post = controller
                            .allFeed[index];
                        return Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: post.posts?.length??0,
                              itemBuilder: (context,i)=>NormalPostScreen(postEntity: post.posts![i],),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: post.tweets?.length??0,
                              itemBuilder: (context,i)=>FacebookTweetCard(post: post.tweets![i],),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: post.ads?.length??0,
                              itemBuilder: (context,i)=>FacebookAdvertisementCard(post: post.ads![i],),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: post.reels?.length??0,
                              itemBuilder: (context,i)=>SizedBox(
                                  height: 400.h,
                                  child: InstagramReelCard(item: post.reels![i],playVideo: false,)),
                            ),
                            // FacebookPostCard(
                            //   deletePost: (String postId) => controller
                            //       .deletePost(context: context, postId: postId),
                            //   hidePost: (String postId) => controller.hidePost(
                            //       context: context, postId: postId),
                            //   post: controller
                            //       .feedPagingController.itemList![index],
                            //   onReact: (PostReactParams item) => controller
                            //       .onReact(params: item, from: 'posts'),
                            //   showPostComments: (String v) {
                            //     bottomSheet(
                            //         context: context,
                            //         isScrollControlled: true,
                            //         widget: BlocProvider.value(
                            //           value: serviceLocator<SocialPostsCubit>()
                            //             ..loadComments(
                            //                 context,
                            //                 controller.feedPagingController
                            //                     .itemList![index].id),
                            //           child: FacebookPostComments(
                            //             postId: controller.feedPagingController
                            //                 .itemList![index].id,
                            //             onAddComment:
                            //                 (PostCommentParams params) {
                            //               return controller.onPostComment(
                            //                   params: params, from: 'feed');
                            //             },
                            //             onCommentReply:
                            //                 (ReplyOnCommentParams params) {
                            //               return controller.replyOnComment(
                            //                 params: ReplyOnCommentParams(
                            //                     postId: params.postId,
                            //                     content: params.content,
                            //                     commentId: params.commentId),
                            //                 from: 'feed',
                            //               );
                            //             },
                            //             onDeleteComment: (String id) async {
                            //               return await controller.deleteComment(
                            //                   context: context,
                            //                   commentId: id,
                            //                   postId: controller
                            //                       .feedPagingController
                            //                       .itemList![index]
                            //                       .id,
                            //                   from: 'feed');
                            //               // print(result);
                            //             },
                            //             onDeleteReply: (String id) async {
                            //               return await controller.deleteComment(
                            //                   context: context,
                            //                   commentId: id,
                            //                   postId: controller
                            //                       .feedPagingController
                            //                       .itemList![index]
                            //                       .id,
                            //                   from: 'feed');
                            //             },
                            //             from: 'feed',
                            //             onEditComment:
                            //                 (PostCommentParams params) async {
                            //               var result = await controller
                            //                   .editComment(params: params);
                            //               return result;
                            //             },
                            //           ),
                            //         ));
                            //   },
                            //   showPostDetails: (PostEntity post) {
                            //     return bottomSheet(
                            //         context: context,
                            //         isScrollControlled: true,
                            //         widget: BlocProvider.value(
                            //           value: serviceLocator<SocialPostsCubit>()
                            //             ..loadPostDetails(
                            //                 context,
                            //                 controller
                            //                             .feedPagingController
                            //                             .itemList![index]
                            //                             .isShared ==
                            //                         true
                            //                     ? controller
                            //                         .feedPagingController
                            //                         .itemList![index]
                            //                         .mainPost!
                            //                         .id
                            //                     : controller
                            //                         .feedPagingController
                            //                         .itemList![index]
                            //                         .id),
                            //           child: PostDetailsPage(
                            //             comments: const [],
                            //             postId: controller.feedPagingController
                            //                 .itemList![index].id,
                            //             deletePost: (String postId) =>
                            //                 controller.deletePost(
                            //                     context: context,
                            //                     postId: postId),
                            //             hidePost: (String postId) =>
                            //                 controller.hidePost(
                            //                     context: context,
                            //                     postId: postId),
                            //             onAddComment:
                            //                 (PostCommentParams params) =>
                            //                     controller.onPostComment(
                            //                         params: params,
                            //                         from: 'details'),
                            //             onReact: (params) => controller.onReact(
                            //                 params: params, from: 'posts'),
                            //             showPostComments: (postId) {},
                            //             showPostDetails: (PostEntity post) {},
                            //             // post: controller.feedPagingController.itemList![index],
                            //             onCommentReply:
                            //                 (ReplyOnCommentParams params) {
                            //               return controller.replyOnComment(
                            //                 params: ReplyOnCommentParams(
                            //                     postId: params.postId,
                            //                     content: params.content,
                            //                     commentId: params.commentId),
                            //                 from: 'details',
                            //               );
                            //             },
                            //             onDeleteComment: (String id) async {
                            //               return await controller.deleteComment(
                            //                   context: context,
                            //                   commentId: id,
                            //                   postId: controller
                            //                       .feedPagingController
                            //                       .itemList![index]
                            //                       .id,
                            //                   from: 'feed');
                            //               // print(result);
                            //             },
                            //             onDeleteReply: (String id) async {
                            //               return await controller.deleteComment(
                            //                   context: context,
                            //                   commentId: id,
                            //                   postId: controller
                            //                       .feedPagingController
                            //                       .itemList![index]
                            //                       .id,
                            //                   from: 'feed');
                            //             },
                            //             onEditComment:
                            //                 (PostCommentParams params) async {
                            //               var result = await controller
                            //                   .editComment(params: params);
                            //               return result;
                            //             },
                            //           ),
                            //         ));
                            //   },
                            //   isMyPost: controller.feedPagingController
                            //               .itemList?[index].user !=
                            //           null
                            //       ? (user?.id ==
                            //           controller.feedPagingController
                            //               .itemList?[index].user.id)
                            //       : false,
                            //   onShare: (String id) {
                            //     controller.onShare(postId: id);
                            //   },
                            //   from: 'posts',
                            //   index: index,
                            // ),
                            Container(
                              width: double.infinity,
                              height: 10.h,
                              color: AppColors.TXTFIELD_GRAY_COLOR2,
                            ),
                          ],
                        );
                      }
                  ),
                  if(controller.isLoadingFaceMore) Center(child: const CircularProgressIndicator()),
                ],
              ),

            ]
        ),
      );
    });
  }
}
