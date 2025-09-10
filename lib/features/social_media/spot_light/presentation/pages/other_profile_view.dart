import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../widgets/posts_grid.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class SpotLightOtherProfileScreen extends StatelessWidget {
  const SpotLightOtherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
                image: AssetImage(Assets.spotlight_profile))),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height * 0.42,
              pinned: false,
              backgroundColor: Colors.transparent,
            ),
            SliverToBoxAdapter(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                decoration:  BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  //context.isDarkMode?AppColors.QUANTITY_COLOR:Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Sizer(
                            height: 24,
                          ),
                          profileTile(context),
                          const Sizer(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              infoButton(context,'🎈', "Apr 2", Colors.red),
                              const Sizer(),
                              infoButton(context,null, "3", Colors.grey.shade300),
                              const Sizer(),
                              infoButton(context,'♈', "Aries", Colors.purple.shade200),
                            ],
                          ),
                          const Sizer(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              postsButton(context,Icons.camera_alt),
                              const Sizer(),
                              postsButton(context,Icons.messenger),
                              const Sizer(),
                              postsButton(context,Icons.videocam_rounded),
                              const Sizer(),
                              postsButton(context,Icons.call),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Sizer(
                      height: 30,
                    ),
                    const PostsGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoButton(BuildContext context,String? icon, String text, Color color) {
    return Container(
      width: 152.h,
      height: 80.h,
      //padding: const EdgeInsets.symmetric( vertical: 8),
      decoration: BoxDecoration(
        color: context.isDarkMode?AppColors.SPLASH_BLACK_COLOR:Colors.transparent,
        border: Border.all(
          color: const Color(0xFF333231),
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Text(icon,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  )),
              Sizer(width: 10.h),
            ],
            Text(text,
                style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    fontSize: icon == null ? 34 : 24,
                    color: const Color(0xFF6A6A6A))),
          ],
        ),
      ),
    );
  }

  Widget postsButton(
      BuildContext context,
    IconData icon,
  ) {
    return ClickableWidget(
      onTap: () {

      ManageVibration.vibrate();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.h),
        decoration: BoxDecoration(
          color: context.isDarkMode?Colors.white: AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(
            icon,
            color:context.isDarkMode?AppColors.PRIMARY_COLOR: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget profileTile(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(
            Assets.spotlight_profile,
            // fit: BoxFit.cover,
          ),
          radius: 75.h,
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: "Ghada Khlifah",
              style: Styles.headerText(
                color: AppColors.getTextColor(context),
                fontSize: 54,
                fontWeight: FontWeight.bold,
              ),
            ),
            Label(
              text: "ghada_khlifah",
              style: Styles.headerText(
                color: Color(0xFF969696),
              ),
            ),
            const Sizer(
              height: 8,
            ),
            Label(
              text:
                  context.isArabic ? "بيننا اصدقاء مشتركين" : "Mutual Friends",
              style: Styles.smallText(
                color: context.isDarkMode?Color(0xFF969696):Color(0xFF606060),
              ),
            ),
          ],
        ))
      ],
    );
  }
}