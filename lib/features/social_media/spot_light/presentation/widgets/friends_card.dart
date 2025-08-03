import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class FriendsCard extends StatelessWidget {
  const FriendsCard({super.key,required this.icon,
  required this.text,
  required this.hasStory,
  required this.iconTitle});

  final IconData icon;
  final String text;
  final bool hasStory;
  final String iconTitle;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(4, 0),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            hasStory
                ? Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.all(Radius.circular(100)),
                    ),
                    child: CircleAvatar(
                      radius: 48.h, // Responsive radius
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CircleAvatar(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              backgroundImage: AssetImage(
                                Assets.spotlight_profile,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
                : Expanded(
              child: CircleAvatar(
                radius: 50.h,
                backgroundImage: AssetImage(
                  Assets.spotlight_profile,
                ),
              ),
            ),
            const Sizer(
              height: 8,
            ),
            Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Sizer(),
            customButton(
                color: Color(0xFFEDEDED),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: Colors.black,
                      size: 25.h,
                    ),
                    const Sizer(
                      width: 8,
                    ),
                    Text(
                      iconTitle,
                      // context.isArabic ? 'محادثة' : 'Chat',
                      style: Styles.mediumText(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget customButton(
      Widget widget, {
        required Color color,
      }) {
    return ClickableWidget(
      onTap: () {

      ManageVibration.vibrate();
      },
      child: Container(
        height: 56.h,
        // width: 84.h,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}