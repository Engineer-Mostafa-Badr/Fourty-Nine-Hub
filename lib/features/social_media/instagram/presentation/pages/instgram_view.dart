import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_global_posts.dart';
import '../../../social_posts/presentation/pages/my_account_view.dart';

class InstagramView extends StatelessWidget {
  const InstagramView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SharedScaffold(
          backgroundColor:Colors.white,
          mainCategoryId: 3,
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
          )),
    );
  }

  Widget _buildInstagramWidget() {
    return const InstagramGlobalPosts();
  }


}
