import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_suggest_people.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/normal_post_screen.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/suggest_reels_facebook_section.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/create_post_banner.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/pages/facebook_stories.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class FaceBookView extends StatefulWidget {
  const FaceBookView({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<FaceBookView> createState() => _FaceBookViewState();
}

class _FaceBookViewState extends State<FaceBookView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (!mounted) return; // حماية إضافية
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      if (UserCubit.to.isLoggedIn) {
        context.read<SocialPostsCubit>().getAllFeed();
      }
      if (!UserCubit.to.isLoggedIn) {
        context.read<SocialPostsCubit>().getGlobalFeed();
      }
    }
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_onScroll);
    super.dispose();
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
      // print("allFeed ${controller.allFeed[0].posts?.length}");
      return RefreshIndicator(
        backgroundColor: AppColors.getFillColor(context),
        color: AppColors.getTextColor(context),
        onRefresh: () async {
          controller.loadData();
          if (UserCubit.to.isLoggedIn) {
            context.read<StoryCubit>()
              ..fetchStories(loadMore: true)
              ..getMutedStories();
          }
          controller.onRefresh();
        },
        child: ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  const CreatePostBanner(),
                  if (UserCubit.to.isLoggedIn)
                    Container(
                      width: double.infinity,
                      height: 1.h,
                      color: AppColors.LIGHT_GRAY_COLOR,
                    ),
                  if (UserCubit.to.isLoggedIn) const Stories(),
                ],
              ),
              // BuildPeopleYouMayKnow(),
              controller.loadFaceData
                  ? const Center(
                      child: CustomCircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        // Container(height: 10,color: Colors.black,),

                        ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.allFeed.length,
                            itemBuilder: (context, index) {
                              // final user = context.read<UserCubit>().state.data;
                              var post = controller.allFeed[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (post.suggestedFriends?.isNotEmpty ??
                                      false)
                                    BuildFacebookSuggestPeople(
                                      suggestedFriends:
                                          post.suggestedFriends ?? [],
                                    ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: post.posts?.length ?? 0,
                                    itemBuilder: (context, i) {
                                      return ClickableWidget(
                                        onTap: () async {
                                          ManageVibration.vibrate();
                                          if (!context
                                              .read<UserCubit>()
                                              .isLoggedIn) {
                                            return;
                                          }
                                          var model = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => BlocProvider(
                                                        create: (context) =>
                                                            serviceLocator<
                                                                SocialPostsCubit>()
                                                              ..loadPostDetails(
                                                                  context,
                                                                  post.posts?[i]
                                                                          .id ??
                                                                      ''),
                                                        child: PostDetailsPage(
                                                          comments: const [],
                                                          postId: post.posts?[i]
                                                                  .id ??
                                                              '',
                                                          deletePost: (String
                                                                  postId) =>
                                                              controller.deletePost(
                                                                  context:
                                                                      context,
                                                                  postId:
                                                                      postId),
                                                          hidePost: (String
                                                                  postId) =>
                                                              controller.hidePost(
                                                                  context:
                                                                      context,
                                                                  postId:
                                                                      postId),
                                                          onAddComment:
                                                              (PostCommentParams
                                                                      params) =>
                                                                  controller.onPostComment(
                                                                      params:
                                                                          params,
                                                                      from:
                                                                          'details'),
                                                          onReact: (params) =>
                                                              controller.onReact(
                                                                  params:
                                                                      params,
                                                                  from:
                                                                      'posts'),
                                                          showPostComments:
                                                              (postId) {},
                                                          showPostDetails:
                                                              (PostEntity
                                                                  post) {},
                                                          // post: controller.feedPagingController.itemList![index],

                                                          onCommentReply:
                                                              (ReplyOnCommentParams
                                                                  params) {
                                                            return controller
                                                                .replyOnComment(
                                                              params: ReplyOnCommentParams(
                                                                  postId: params
                                                                      .postId,
                                                                  content: params
                                                                      .content,
                                                                  commentId: params
                                                                      .commentId),
                                                              from: 'details',
                                                            );
                                                          },
                                                          onDeleteComment:
                                                              (String
                                                                  id) async {
                                                            return await controller
                                                                .deleteComment(
                                                                    context:
                                                                        context,
                                                                    commentId:
                                                                        id,
                                                                    postId: post
                                                                            .posts?[
                                                                                i]
                                                                            .id ??
                                                                        '',
                                                                    from:
                                                                        'feed');
                                                            // print(result);
                                                          },
                                                          onDeleteReply: (String
                                                              id) async {
                                                            return await controller
                                                                .deleteComment(
                                                                    context:
                                                                        context,
                                                                    commentId:
                                                                        id,
                                                                    postId: post
                                                                            .posts?[
                                                                                i]
                                                                            .id ??
                                                                        '',
                                                                    from:
                                                                        'feed');
                                                          },
                                                          onEditComment:
                                                              (PostCommentParams
                                                                  params) async {
                                                            var result =
                                                                await controller
                                                                    .editComment(
                                                                        params:
                                                                            params);
                                                            return result;
                                                          },
                                                        ),
                                                      )));
                                          print("modelmodelmodelmodel $model");
                                          if (model != null) {
                                            post.posts![i] = model;
                                          }
                                          setState(() {});
                                        },
                                        child: NormalPostScreen(
                                          postEntity: post.posts![i],
                                        ),
                                      );
                                    },
                                  ),
                                  if (post.reels?.isNotEmpty ?? false)
                                    SuggestReelsFaceBookSection(
                                      reels: post.reels ?? [],
                                    ),
                                ],
                              );
                            }),
                        if (controller.isLoadingFaceMore)
                          const Center(
                              child: CustomCircularProgressIndicator()),
                      ],
                    ),
            ]),
      );
    });
  }
}
