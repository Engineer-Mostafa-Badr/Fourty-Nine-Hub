import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/story_model.dart';
import 'story_item_widget.dart';

class StoriesSectionWidget extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesSectionWidget({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return StoryItemWidget(
            story: stories[index],
            onTap: () {
              // TODO: Handle story tap
            },
          );
        },
      ),
    );
  }
}
