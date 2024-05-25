import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/post_type_enum.dart';

import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../chat/presentation/widgets/home/chat_stories.dart';
import '../widgets/posts/PostCard.dart';
import '../widgets/posts/Stories.dart';
import 'my_account_view.dart';

class SocialHomeView extends StatelessWidget {
  const SocialHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.GRAY_LIGHT_COLOR3,
        appBar: const HomeAppbar(),
        drawer: const DrawerWidget(),
        bottomNavigationBar: const BottomNavigator(
          mainCategory: 0,
          index: 2,
        ),
        floatingActionButton: const FloatingButton(
          changeView: 2,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: NestedAppbar(appBars: [
          SliverAppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            floating: true,
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
    return ListView(
      shrinkWrap: true,
      children: [
        const Stories(),
        ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => PostCard(),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 30),
      ],
    );
  }

  Widget _buildInstagramWidget() {
    return ListView(
      children: [
        const ChatStories(),
        ListView.separated(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => PostCard(
                  postType: PostType.Instagram,
                ),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 30),
      ],
    );
  }
}
