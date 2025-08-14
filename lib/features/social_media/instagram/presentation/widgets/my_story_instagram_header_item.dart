import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import 'image_story_instagram_header.dart';
import 'stores_instagram_widget.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class MyStoryInstagramHeaderItem extends StatelessWidget {
  const MyStoryInstagramHeaderItem({
    super.key,
    required this.storyItemEntity,
  });

  final StoryItemEntity storyItemEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ImageStoryInstagramHeader(
              imageUrl: storyItemEntity.imageUrl,
              storyCount: storyItemEntity.storyCount,
              currentSegment: storyItemEntity.storyCount,
            ),
            Positioned(
              right: 0,
              bottom: 3,
              child: Container(
                width: 23,
                height: 23,
                // padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.c0B1035,
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          width: 62,
          child: Label(
            text: LocaleKeys.myStory.localize,
            textAlign: TextAlign.center,
            style: Styles.mediumText(
              fontSize: 26,
            ),
          ),
        ),
      ],
    );
  }
}
