import 'package:flutter/material.dart';

import '../widgets/instagram_user_follow_widget.dart';

class InstagramBlockListBody extends StatelessWidget {
  const InstagramBlockListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InstagramUserFollowWidget(inBlock: true,),
            InstagramUserFollowWidget(inBlock: true,),
            InstagramUserFollowWidget(inBlock: true,),
            InstagramUserFollowWidget(inBlock: true,),
            InstagramUserFollowWidget(inBlock: true,),
            InstagramUserFollowWidget(inBlock: true,),
          ],
        ),
      ),
    );
  }
}
