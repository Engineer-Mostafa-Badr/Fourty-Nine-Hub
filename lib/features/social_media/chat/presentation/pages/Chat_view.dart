import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../widgets/home/chat_card.dart';
import '../widgets/home/chat_stories.dart';

class ChatView extends StatelessWidget {
  final List<String> groups = [
    'All',
    'Social',
    'Ride',
    'Shipping',
    'Anonimous'
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
            SliverAppBar(
              expandedHeight: kToolbarHeight * 1.5,
              automaticallyImplyLeading: false,
              floating: true,
              flexibleSpace: ChatStories(),
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: true,
              pinned: true,
              leading: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.mail_rounded,
                    color: Colors.grey,
                  )),
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
    return TabBarView(
        children: groups.map((e) {
      return _buildCategoryChats();
    }).toList());
  }

  Widget _buildCategoryChats() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const ChatCard(),
        separatorBuilder: (context, index) => SizedBox(),
        itemCount: 8);
  }
}
