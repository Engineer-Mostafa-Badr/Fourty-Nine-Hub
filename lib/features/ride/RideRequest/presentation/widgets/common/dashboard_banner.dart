import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class DashboardBanner extends StatelessWidget {
  final String title;
  final String? subTitle;
  final String? route;
  final restaurantId;
  final void Function()? onTap;

  const DashboardBanner(
      {super.key,
      this.subTitle,
      required this.title,
      this.route,
      this.onTap,
      this.restaurantId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            if (route != null) {
              context.push(route!, extra: restaurantId);
            }
          },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Label(
                text: title,
                style: Styles.mediumText(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 35.w,
            ),
          ],
        ),
      ),
    );
  }
}
