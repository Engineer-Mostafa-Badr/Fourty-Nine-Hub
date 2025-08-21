import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/story_model.dart';
import '../../../../res/style/app_colors.dart';

class StoryItemWidget extends StatelessWidget {
  final StoryModel story;
  final VoidCallback? onTap;

  const StoryItemWidget({
    super.key,
    required this.story,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 12.w),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: story.hasNewStory
                    ? Border.all(
                        color: AppColors.PRIMARY_COLOR,
                        width: 2,
                        style: BorderStyle.solid,
                      )
                    : story.isViewed
                        ? Border.all(
                            color: Colors.grey.shade300,
                            width: 2,
                          )
                        : Border.all(
                            color: AppColors.PRIMARY_COLOR,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: Container(
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: story.profileImage.isNotEmpty
                          ? Image.asset(
                              story.profileImage,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 30.sp,
                              color: Colors.grey.shade600,
                            ),
                    ),
                  ),
                  if (story.isMyStory)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              story.name,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
