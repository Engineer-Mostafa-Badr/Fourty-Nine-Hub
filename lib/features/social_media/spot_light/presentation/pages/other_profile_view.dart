import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/widgets/posts_grid.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
              flexibleSpace: const FlexibleSpaceBar(
                background: SizedBox(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: SafeArea(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 10),
                            child: Icon(Icons.arrow_back, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                              infoButton('🎈', "Apr 2", Colors.red),
                              const Sizer(),
                              infoButton(null, "3", Colors.grey.shade300),
                              const Sizer(),
                              infoButton('♈', "Aries", Colors.purple.shade200),
                            ],
                          ),
                          const Sizer(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              postsButton(Icons.camera_alt),
                              const Sizer(),
                              postsButton(Icons.messenger),
                              const Sizer(),
                              postsButton(Icons.videocam_rounded),
                              const Sizer(),
                              postsButton(Icons.call),
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

  Widget infoButton(String? icon, String text, Color color) {
    return Container(
      width: 152.h,
      height: 80.h,
      //padding: const EdgeInsets.symmetric( vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFF333231),
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
                    fontSize: icon == null ? 34 : 24,
                  )),
              Sizer(width: 10.h),
            ],
            Text(text,
                style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    fontSize: icon == null ? 34 : 24,
                    color: Color(0xFF6A6A6A))),
          ],
        ),
      ),
    );
  }

  Widget postsButton(
    IconData icon,
  ) {
    return ClickableWidget(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 30.h),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
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
                color: Colors.black,
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
                color: Color(0xFF606060),
              ),
            ),
          ],
        ))
      ],
    );
  }
}
