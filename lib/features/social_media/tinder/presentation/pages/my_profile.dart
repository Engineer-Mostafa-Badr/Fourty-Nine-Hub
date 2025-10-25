import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/clickable_widget.dart';
import '../widgets/count_down.dart';
import '../widgets/custom_circular_percent_indicator.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../helpers/manage_vibration.dart';
// import 'package:percent_indicator/percent_indicator.dart';

class FindMyProfileScreen extends StatefulWidget {
  const FindMyProfileScreen({super.key});

  @override
  State<FindMyProfileScreen> createState() => _FindMyProfileScreenState();
}

class _FindMyProfileScreenState extends State<FindMyProfileScreen> {
  double progress = 0.9;
  int superLikes = 0;
  bool isVerified = true;
  bool isContinueEditing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getFillColor(context),
        leadingWidth: 200,
        leading: Row(
          children: [
            const Sizer(),
            ClickableWidget(
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.getTextColor(context),
              ),
              onTap: () => context.pop(),
            ),
            const Sizer(),
            Label(
              text: LocaleKeys.profile.localize,
              style: Styles.headerText(color: AppColors.getTextColor(context)),
            )
          ],
        ),
        actions: [
          ClickableWidget(
              child: Image.asset(
            Assets.shield,
            height: 50.h,
            color: context.isDarkMode ? null : Colors.black54,
          )),
          const Sizer(
            width: 30,
          ),
          ClickableWidget(
              child: Image.asset(
            Assets.setting,
            height: 50.h,
            color: context.isDarkMode ? null : Colors.black54,
          )),
          const Sizer(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: profileImageSection(),
          ),
          SliverToBoxAdapter(
            child: Container(
              //height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: AppColors.getReversedTextColor(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Sizer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            likesContainer(
                              context.isArabic ? 'سوبر لايك' : 'Super Likes',
                              true,
                              Color(0xff1D8ADC),
                              icon: Assets.blue_star,
                            ),
                            const Sizer(),
                            likesContainer(
                              context.isArabic ? 'تعزيزاتي' : 'My Boosts',
                              true,
                              Color(0xff9D14E6),
                              icon: Assets.volt,
                            ),
                            const Sizer(),
                            likesContainer('\u200E49 HUB', true,
                                AppColors.getTextColor(context),
                                titleStyle: Styles.headerText(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                                bottomText: context.isArabic
                                    ? 'اشتراكات'
                                    : 'Subscriptions'),
                          ],
                        ),
                        const Sizer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 32.h, horizontal: 35.h),
                          height: 420.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xffFFE9A9),
                                Color(0xffFFFFFF),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Column(
                            // textDirection: TextDirection.ltr,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // textDirection: TextDirection.ltr,
                                children: [
                                  Image.asset(
                                    Assets.tinder_ads,
                                    height: 50.h,
                                  ),
                                  const Sizer(),
                                  Label(
                                    text: '\u200E49 Hub',
                                    style: Styles.headerText(
                                        fontSize: 64,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              const Sizer(
                                height: 60,
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                  text: '50% ',
                                  style: Styles.headerText(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: context.isArabic
                                      ? 'خصم اول شهر'
                                      : 'OFF FIRST 1 MONTH',
                                  style: Styles.headerText(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ])),
                              const Sizer(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Label(
                                    text: context.isArabic
                                        ? 'ينتهي العرض خلال '
                                        : 'Offer ends in ',
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xff8D7731)),
                                  ),
                                  CountdownTimer(
                                      endTime: DateTime.now()
                                          .add(Duration(hours: 5))),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ClickableWidget(
                                      child: Container(
                                          height: 90.h,
                                          width: 250.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xffE9AA43),
                                                Color(0xffF6D36E),
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          child: Center(
                                            child: Label(
                                                text: context.isArabic
                                                    ? 'ترقية'
                                                    : 'Upgrade',
                                                style: Styles.headerText(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 28)),
                                          )),
                                    ),
                                    Label(
                                      text: context.isArabic
                                          ? 'امتيازات آخري'
                                          : 'See All Features',
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff8D7731)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
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

  Widget profileImageSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        color: AppColors.getFillColor(context),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: CustomCircularPercentIndicator(
                    radius: 140.0.h,
                    lineWidth: 6.0,
                    startAngle: 180,
                    percent: progress,
                    backgroundColor: Colors.grey.shade800,
                    gradientColors: [
                      AppColors.getTextColor(context),
                      AppColors.getFillColor(context),
                    ],
                    center: CircleAvatar(
                      radius: 125.h,
                      backgroundImage: AssetImage(Assets.personalImage),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 6,
                  child: Stack(
                    children: [
                      ClickableWidget(
                        onTap: () => context.push(Routes.EditProfileTinder),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.getFillColor(context),
                              border: Border.all(
                                  color: AppColors.getTextColor(context))),
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: AppColors.getTextColor(context),
                          ),
                        ),
                      ),
                      if (isContinueEditing)
                        Positioned(
                            top: 0,
                            right: 2,
                            child: Icon(
                              Icons.circle,
                              color: Colors.red,
                              size: 8,
                            ))
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 280.h,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF0B1035), Color(0xFFFF3308)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.3, 0.8]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        context.isArabic
                            ? ' مكتمل ${(progress * 100).toInt()}%'
                            : "${(progress * 100).toInt()}% COMPLETE",
                        style: Styles.headerText(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Sizer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.ltr,
              children: [
                Text(
                  'Mohamed Magdy, 24',
                  //"${capitalizeAndSplit(cardUser.firstName ?? '')} ${capitalizeAndSplit(cardUser.lastName ?? '')}",
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 50.sp,
                    shadows: [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: AppColors.getReversedTextColor(context),
                      ),
                    ],
                  ),
                ),
                if (isVerified) const Sizer(),
                if (isVerified)
                  Image.asset(
                    Assets.verified,
                    height: 50.h,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget likesContainer(String title, bool getMore, Color color,
      {String? icon,
      String? bottomText,
      int? superLikes,
      TextStyle? titleStyle}) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.0.h, right: 20.w),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.getFindFillColor(context)),
            width: 192.w,
            height: 192.h,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 25.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Image.asset(
                    icon,
                    height: 50.h,
                    fit: BoxFit.cover,
                  ),
                const Sizer(),
                RichText(
                    text: TextSpan(
                  children: [
                    if (superLikes != null)
                      TextSpan(
                        text: '$superLikes',
                        style: Styles.mediumText(fontSize: 24, color: color),
                      ),
                    TextSpan(
                      text: title,
                      style: titleStyle ??
                          Styles.mediumText(
                              fontSize: 24,
                              color: AppColors.getTextColor(context)),
                    ),
                  ],
                )),
                const Sizer(
                  height: 10,
                ),
                if (getMore)
                  Label(
                    text: bottomText ??
                        (context.isArabic ? 'جمع المزيد' : 'Get More'),
                    style: Styles.mediumText(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color),
                  ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.getFillColor(context),
                    border: Border.all(color: AppColors.getTextColor(context))),
                child: Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.getTextColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        if (trailing != null)
          ClickableWidget(
            onTap: () {
              ManageVibration.vibrate();
            },
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
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor),
                    padding: EdgeInsets.all(4.h),
                    child: CircleAvatar(
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

  Widget customButton({
    required Color color,
  }) {
    return ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();
      },
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
              const Sizer(),
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
