import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../res/assets/assets.dart';
import '../widgets/home/calling_card.dart';
import '../widgets/home/chat_card.dart';
import '../widgets/home/chat_stories.dart';

class ChatView extends StatelessWidget {
  final List<String> groups = [
    'Social',
    'Services',
    'Call (Social)',
    'Video (Social)',
    'Call (Services)',
    'Video (Services)',
    'Anonymous',
    'Archive',
    'Lock Chat',
    'Un Read',
  ];

  ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: groups.length,
      child: Scaffold(
          appBar: const HomeAppbar(),
          drawer: const DrawerWidget(),
          bottomNavigationBar: const BottomNavigator(
            mainCategory: 0,
            index: 2,
          ),
          floatingActionButton: const FloatingButton(
            changeView: 2,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: NestedAppbar(appBars: [
            const SliverAppBar(
              expandedHeight: kToolbarHeight * 1.5,
              automaticallyImplyLeading: false,
              floating: true,
              flexibleSpace: ChatStories(),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              flexibleSpace: _buildCategoriesLabels(),
            )
          ], body: _buildCategoriesViews())),
    );
  }

  Widget _buildCategoriesLabels() {
    return TabBar(
        isScrollable: true,
        tabs: groups.map((e) {
          return Tab(
            text: e,
          );
        }).toList());
  }

  Widget _buildCategoriesViews() {
    return TabBarView(children: [
      _buildCategoryChats(),
      _buildCategoryChats(),
      _buildCallingHistory(isVideo: false),
      _buildCallingHistory(isVideo: true),
      _buildCallingHistory(isVideo: false),
      _buildCallingHistory(isVideo: true),
      _buildCategoryChats(isSecret: true),
      _buildCategoryChats(),
      _buildCategoryChats(),
      _buildCategoryChats(),
    ]);
  }

  Widget _buildCategoryChats({bool isSecret = false}) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ChatCard(isSecret: isSecret),
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: 8);
  }

  Widget _buildCallingHistory({required bool isVideo}) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => CallingCard(
              isVideo: isVideo,
            ),
        separatorBuilder: (context, index) => const SizedBox(),
        itemCount: 8);
  }
}
