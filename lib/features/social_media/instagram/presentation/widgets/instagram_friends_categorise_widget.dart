import 'package:flutter/material.dart';
import 'post_instagram_widget.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class InstagramFriendsCategoriseWidget extends StatelessWidget {
  const InstagramFriendsCategoriseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            PositionedDirectional(
              // bottom: 7,
              bottom: 5,
              end: 7,
              child: ImageFromInternet(
                width: 25,
                height: 25,
                image: testImage,
                isCircle: true,
                fit: BoxFit.cover,
                // decoration: const BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: Colors.green,
                // ),
              ),
            ),
            PositionedDirectional(
              child: ImageFromInternet(
                width: 25,
                height: 25,
                image: testImage2,
                isCircle: true,
                fit: BoxFit.cover,
                // decoration: const BoxDecoration(
                //   shape: BoxShape.circle,
                //   color: Colors.blue,
                // ),
              ),
            ),
          ],
        ),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: "Least interacted with"),
              Label(
                text: "alicasmd and 49 others",
                color: Colors.black45,
              ),
            ])
      ],
    );
  }
}
