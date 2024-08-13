import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_global_posts.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../social_posts/presentation/pages/my_account_view.dart';

class InstagramView extends StatelessWidget {
  const InstagramView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar:  const HomeAppbar(
          isWithBackArrow: true,
        ),
        drawer: const DrawerWidget(),
    bottomNavigationBar: const BottomNavigator(
    mainCategory: 3,
    index: 2,

    ),
    floatingActionButton: const FloatingButton(
    changeView: 3,
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: [
            const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.grid_4x4_outlined),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
            ]),
            Expanded(
              child: TabBarView(children: [
                _buildInstagramWidget(),
                const MyAccountView(),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInstagramWidget() {
    return const InstagramGlobalPosts();
  }


}
