import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/enums/post_type_enum.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_react_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../chat/presentation/widgets/home/chat_stories.dart';
import '../widgets/posts/PostCard.dart';
import '../widgets/posts/Stories.dart';
import '../widgets/posts/create_post_banner.dart';
import '../widgets/posts/facebook_post_card.dart';
import 'my_account_view.dart';

class SocialHomeView extends StatelessWidget {
  const SocialHomeView({super.key});

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
        icon: Icon(Icons.grid_4x4_outlined),
      ),
      Tab(
        icon: Icon(Icons.person),
      ),
    ]);
  }

  Widget _buildBody() {
    return TabBarView(children: [
      _buildFacebookWidget(),
      _buildInstagramWidget(),
      const MyAccountView(),
    ]);
  }

  Widget _buildFacebookWidget() {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      return ListView(
        shrinkWrap: true,
        children: [
          const Stories(),
          ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => FacebookPostCard(
                    post: state.posts![index],
                    onReact: (PostReactParams item) =>
                        controller.onReact(params: item),
                      showPostComments: (String v)=> controller.showPostComments(context: context, postId: v),
                  ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: state.posts?.length ?? 0),
        ],
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
