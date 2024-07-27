import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';

import '../../../chat/chat_view/presentation/widgets/chat_stories.dart';
import '../../../social_posts/presentation/pages/my_account_view.dart';

class InstagramView extends StatelessWidget {
  const InstagramView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SharedScaffold(
          mainCategoryId: 3,
          body: Column(
            children: [
              TabBar(tabs: [
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
