import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class FollowBroadcastCard extends StatelessWidget {
  final String title;
  final String iconPath;

  const FollowBroadcastCard(
    this.title,
    this.iconPath, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.BROADCAST),
      child: Container(
        padding: const EdgeInsets.only(right: 12, left: 12, top: 16),
        margin: const EdgeInsets.only(left: 16),
        decoration: BoxDecoration(
          color: AppColors.BACKGROUND_COLOR,
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
          ],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.GREY_BORDER_COLOR),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.network(iconPath, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 64),
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumText(
                      color: AppColors.PRIMARY_COLOR,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            InkWell(
              child: Text(
                "Follow",
                style: Styles.mediumText(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.PRIMARY_COLOR_DARK,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            )
          ],
        ),
      ),
    );
  }
}
