import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/social_media/spot_light/presentation/widgets/friends_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class LockedProfileScreen extends StatelessWidget {
  const LockedProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.42,
            pinned: false,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: SizedBox(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          Assets.spotlight_profile,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    const Align(
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
                          height: 40,
                        ),
                        profileTile(context, isOnline: true),
                        const Sizer(
                          height: 40,
                        ),
                        customButton(color: AppColors.PRIMARY_COLOR,),
                        const Sizer(height: 40,),
                        sectionTitle(context.isArabic ? 'ابحث عن اصدقاء' : 'Find Friends'),
                        const Sizer(),
                        SizedBox(
                          height: 0.22.sh,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => FriendsCard(
                                  icon: Icons.add_outlined,
                                  iconTitle: LocaleKeys.add.localize,
                                  hasStory: true,
                                  text: 'Ahmed Mohamed'),
                              itemCount: 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget sectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style:const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        if (trailing != null)
          ClickableWidget(
            onTap: () {},
            child: Row(
              children: [
                Text(trailing, style: Styles.mediumText()),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 26.h,
                )
              ],
            ),
          ),
      ],
    );
  }
  Widget profileTile(BuildContext context, {bool isOnline = false}) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 75.h,
              backgroundImage: AssetImage(
                Assets.spotlight_profile,
              ),
            ),
            if (isOnline)
              Positioned(
                bottom: 10.h,
                right: 10.h,
                child: Container(decoration: BoxDecoration(shape: BoxShape.circle,color:Theme.of(context).scaffoldBackgroundColor ),
                    padding: EdgeInsets.all(4.h),
                    child:  CircleAvatar(
                      radius: 10.h,
                      backgroundColor: Colors.green,
                    )),
              ),
          ],
        ),
        const Sizer(
          width: 25,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: "Ahmed Mohamed",
              style: Styles.headerText(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Label(
              text: "AhmedMohamed21",
              style: Styles.mediumText(
                color: const Color(0xFF969696),
              ),
            ),
          ],
        ))
      ],
    );
  }
  Widget customButton( {
        required Color color,
      }) {
    return ClickableWidget(
      onTap: () {},
      child: Container(
         width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.person_add,
                color: Colors.white,
                size: 30.h,
              ),
              const Sizer(

              ),
              Text(
                LocaleKeys.add.localize,
                style: Styles.mediumText(
                    color: Colors.white, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }
}
