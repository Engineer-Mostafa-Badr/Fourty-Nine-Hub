import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/widgets/chat_stories.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/other_account_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_people_you_may_know.dart';
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
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return RefreshIndicator(
        onRefresh: () async => controller.loadData(),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Stories(),
            const BuildPeopleYouMayKnow(),
            // render posts
            ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => FacebookPostCard(
                      deletePost: (String postId) => controller.deletePost(
                          context: context, postId: postId),
                      hidePost: (String postId) => controller.deletePost(
                          context: context, postId: postId),
                      post: state.posts![index],
                      onReact: (PostReactParams item) =>
                          controller.onReact(params: item),
                      showPostComments: (String v) => controller
                          .showPostComments(context: context, postId: v),
                      showPostDetails: (PostEntity post) => controller
                          .showPostDetails(context: context, post: post),
                    ),
                separatorBuilder: (context, index) {
                  if (index == 4) {}
                  return Container(
                    color: AppColors.LIGHT_GRAY_COLOR,
                    height: 4,
                  );
                },
                itemCount: state.posts?.length ?? 0),

            // on loading
            if (state.status == StateStatus.loading)
              const SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(child: CircularProgressIndicator.adaptive()))
          ],
        ),
      );
    });
  }



  Widget _buildMyPostsWidget() {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return RefreshIndicator(
        onRefresh: () async => controller.getMyPosts(context: context),
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
                      controller.showPostDetails(context: context, post: post),
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
