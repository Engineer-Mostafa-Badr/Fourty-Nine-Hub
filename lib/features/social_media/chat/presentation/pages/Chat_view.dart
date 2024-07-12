import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../club_house/presentation/pages/club_house_home.dart';
import '../widgets/home/calling_card.dart';
import '../widgets/home/chat_card.dart';
import '../widgets/home/chat_stories.dart';

class ChatView extends StatelessWidget {
  final List<String> groups = [
    'Broadcast',
    'Social',
    'Services',
    'Call & Video (Social)',
    'Call & Video(Services)',
    'Anonymous',
    'Archive',
    'Lock Chat',
    'Unread',
  ];

  ChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: groups.length,
      initialIndex: 1,
      child: SharedScaffold(
          mainCategoryId: 2,
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
      const ClubHouseHome(),
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
