import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/insta_reel_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InstagramReels extends StatelessWidget {
  const InstagramReels({super.key, required this.reels});
  final List<PostEntity> reels;

  @override
  Widget build(BuildContext context) {
    return reels.isEmpty?const SizedBox.shrink():SizedBox(
      height: 460.h,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: reels.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: "Suggested Reels",style: Styles.headerText(color: Theme.of(context).textTheme.bodyLarge?.color),),
              const Sizer(),
              Container(
                color: Colors.black,
                height: 400.h,
                width: 350.w,
                child: InstagramReelCard(
                  item: reels[index],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
