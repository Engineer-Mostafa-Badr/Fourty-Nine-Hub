import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/other_account_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_people_you_may_know.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_global_posts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

class _SocialHomeViewState extends State<SocialHomeView> {
  late SocialPostsCubit controller;

  @override
  void initState() {
    controller = context.read<SocialPostsCubit>();
    controller.getMyPosts(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SharedScaffold(
        mainCategoryId: 2,
        body: NestedAppbar(appBars: [
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
        ], body: _buildBody()),
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBar(tabs: [
      Tab(
        icon: Icon(Icons.home),
      ),
      Tab(
        icon: Icon(Icons.add_home_outlined),
      ),
      Tab(
        icon: Icon(Icons.person),
      ),
    ]);
  }

  Widget _buildBody() {
    return TabBarView(children: [
      _buildFacebookWidget(),
      _buildMyPostsWidget(),
      const OtherAccountView(),
    ]);
  }

  Widget _buildFacebookWidget() {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
        listener: (context,state){
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
                          "لا يوجد بوستات",
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
                            deletePost: (String postId) => controller.deletePost(context: context, postId: postId),
                            hidePost: (String postId) => controller.deletePost(context: context, postId: postId),
                            post: controller.feedPagingController.itemList![index],
                            onReact: (PostReactParams item) => controller.onReact(params: item),
                            showPostComments: (String v) => controller.showPostComments(context: context, postId: v),
                            showPostDetails: (PostEntity post) => controller.showPostDetails(context: context, post: post),
                            isMyPost: controller.feedPagingController.itemList?[index].user!=null?(user?.id == controller.feedPagingController.itemList?[index].user.id):false,
                            onShare: (String id) {
                              controller.onShare(postId: id);
                            },
                            from: 'posts',
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
                    firstPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator(),
                    newPageProgressIndicatorBuilder: (context) => const CupertinoActivityIndicator(),
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMyPostsWidget() {
    return BlocConsumer<SocialPostsCubit, SocialPostsState>(
      listener: (context,state){
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
                      controller.onReact(params: item),
                  showPostComments: (String v) =>
                      controller.showPostComments(context: context, postId: v),
                  showPostDetails: (PostEntity post) =>
                      controller.showPostDetails(context: context, post: post), onShare: (String id) {
                    controller.onShare(postId: id);
            }, from: 'posts',
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

  Widget _buildInstagramWidget() {
    return ListView(
      children: [
        const ChatStories(),
        Container(),
        // ListView.separated(
        //     shrinkWrap: true,
        //     physics: const BouncingScrollPhysics(),
        //     itemBuilder: (context, index) => PostCard(
        //           postType: PostType.Instagram,
        //         ),
        //     separatorBuilder: (context, index) => const Sizer(),
        //     itemCount: 30),
      ],
    );
  }
}
