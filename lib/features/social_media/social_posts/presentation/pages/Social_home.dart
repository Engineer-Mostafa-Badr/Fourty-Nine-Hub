import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/other_account_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_people_you_may_know.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../domain/entities/post_entity.dart';
import '../widgets/posts/Stories.dart';
import '../widgets/posts/create_post_banner.dart';
import '../widgets/posts/facebook_post_card.dart';

class SocialHomeView extends StatefulWidget {
  final String userId;
  const SocialHomeView({super.key, required this.userId});

  @override
  State<SocialHomeView> createState() => _SocialHomeViewState();
}

class _SocialHomeViewState extends State<SocialHomeView>
    with SingleTickerProviderStateMixin {
  // late SocialPostsCubit controller;
  @override
  void initState() {
    super.initState();
    // controller = context.read<SocialPostsCubit>();
    // controller.getMyPosts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: const HomeAppbar(
            isWithBackArrow: true,
          ),
          drawer: const DrawerWidget(),
          bottomNavigationBar: const BottomNavigator(
            mainCategory: 2,
            index: 2,
          ),
          floatingActionButton: const FloatingButton(
            changeView: 2,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
            return context.read<UserCubit>().isLoggedIn
                ? NestedAppbar(appBars: [
                    const SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      floating: true,
                      // pinned: true,
                      flexibleSpace: CreatePostBanner(),
                    ),
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      // floating: true,
                      pinned: true,
                      flexibleSpace: _buildTabBar(),
                    )
                  ], body: _buildBody())
                : Center(
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () => context.push(Routes.LOGIN),
                          child: Label(
                              text: 'Login',
                              style: Styles.headerText(color: Colors.blue))),
                      Label(
                          text: ', To continue in using chat services',
                          style: Styles.headerText()),
                    ],
                  ));
          })),
    );
  }

  Widget _buildTabBar() {
    return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            2,
            (i) => GestureDetector(
              onTap: () {
                if (i == 1) {
                  context.push(Routes.OTHERSACCOUNT);
                }
              },
              child: Container(
                  decoration: i == 0
                      ? const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.blue, width: 2)))
                      : null,
                  child: Icon(
                    i == 0 ? Icons.home : Icons.person,
                    color: i == 0 ? Colors.blue : AppColors.DARK_GRAY_COLOR,
                  )),
            ),
          ),
        ));
  }

  Widget _buildBody() {
    return _buildFacebookWidget();
  }

  Widget _buildFacebookWidget() {
    return BlocProvider<SocialPostsCubit>(
      create: (_) => serviceLocator()..loadData(),
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
          onRefresh: () async => controller.onRefresh(),
          child: CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(
                child: Stories(),
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
                        return const Center(
                          child: Text(
                            "No Posts",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
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
                                              params: params);
                                        },
                                        onCommentReply:
                                            (ReplyOnCommentParams params) {
                                          return controller.replyOnComment(
                                            params: ReplyOnCommentParams(
                                                postId: params.postId,
                                                content: params.content,
                                                commentId: params.commentId),
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
                                                context: context,
                                                postId: postId),
                                        hidePost: (String postId) =>
                                            controller.hidePost(
                                                context: context,
                                                postId: postId),
                                        onAddComment: (PostCommentParams
                                                params) =>
                                            controller.onPostComment(
                                                params: params),
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
                                        }),
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
                              height: 5,
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

  Widget _buildMyPostsWidget() {
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
        onRefresh: () async => controller.loadData(),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => FacebookPostCard(
                  deletePost: (String postId) =>
                      controller.deletePost(context: context, postId: postId),
                  hidePost: (String postId) =>
                      controller.deletePost(context: context, postId: postId),
                  isMyPost: true,
                  post: state.myPosts![index],
                  onReact: (PostReactParams item) =>
                      controller.onReact(params: item, from: 'posts'),
                  showPostComments: (String v) {},
                  showPostDetails: (PostEntity post) {},
                  onShare: (String id) {
                    controller.onShare(postId: id);
                  },
                  from: 'posts',
                  index: index,
                ),
            separatorBuilder: (context, index) {
              if (index == 4) {}
              return Container(
                color: AppColors.LIGHT_GRAY_COLOR,
                height: 4,
              );
            },
            itemCount: state.myPosts?.length ?? 0),
      );
    });
  }
}
