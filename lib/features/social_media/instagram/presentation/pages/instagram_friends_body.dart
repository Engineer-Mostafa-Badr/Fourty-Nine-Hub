import 'package:flutter/material.dart';


class InstagramFriendsBody extends StatelessWidget {
  const InstagramFriendsBody({super.key});

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
            // Label(text: LocaleKeys.cantLoadCategories.localize),
            // InstagramFriendsCategoriseWidget(),
            // InstagramFriendsCategoriseWidget(),
            // InstagramFriendsCategoriseWidget(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Label(text: 'Sorted by Default'),
            //     Icon(
            //       Icons.swap_vert,
            //       color: Colors.black45,
            //       size: 16,
            //     ),
            //   ],
            // ),
            Column(
              spacing: 16,
              children: [
                // InstagramUserFollowWidget(inFriends: true,),
                // InstagramUserFollowWidget(inFriends: true,),
                // InstagramUserFollowWidget(inFriends: true,),
                // InstagramUserFollowWidget(inFriends: true,),
                // InstagramUserFollowWidget(inFriends: true,),
                // InstagramUserFollowWidget(inFriends: true,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
