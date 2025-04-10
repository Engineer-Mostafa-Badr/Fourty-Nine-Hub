import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_card_bottom_section.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/health_custom_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CurrentBookingCard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const CurrentBookingCard({
    super.key,
    required this.title,
    required this.isSubscribed,
  });

  final String title;
  final bool isSubscribed;

  @override
  State<CurrentBookingCard> createState() => _CurrentBookingCardState();
}

class _CurrentBookingCardState extends State<CurrentBookingCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              HealthCustomCard(
                padding: EdgeInsets.symmetric(horizontal: 16.h),
                radiusGeometry: BorderRadius.circular(20.h),
                children: [
                  const Sizer(),
                  _tripCardInfoWidget(
                    title: widget.title,
                    icon: widget.isSubscribed
                        ? 'assets/images/doctor_profile.jpeg'
                        : Assets.maleUser,
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        color: AppColors.PRIMARY_COLOR,size: 48.h,
                      ),
                      const Sizer(),
                      Label(
                        text: 'Nasr City, Cairo',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      SvgPicture.asset(

                        Assets.cash,
                        fit: BoxFit.cover,height: 48.h,width: 48.h,
                      ),
                      const Sizer(),
                      Expanded(
                        child: Label(
                          text: context.isArabic ? 'خدمة' : 'Fees',
                          style: Styles.mediumText(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Label(
                        text: '100 ${LocaleKeys.egp.localize}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Sizer(),
                  Row(
                    children: [
                      Icon(
                          Icons.watch_later_outlined,
                          color: AppColors.black,size: 48.h
                      ),
                      const Sizer(),
                      Label(
                        text: '${context.isArabic?'وقت الانتظار':'Waiting time'}: 10 ${context.isArabic?'دقيقة':'min'}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  const Sizer(),
                  HealthCardButtonsSection(
                    isButton: false,
                    isSubscribed: widget.isSubscribed,
                    buttonTitle: '',
                    onTap: (){},
                  ),
                  const Sizer(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _tripCardInfoWidget({
    required String title,
    required String icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 112.h,
                  height: 112.h,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.asset(
                    icon,
                    fit: BoxFit.cover,
                  ),
                ),
                const Sizer(),
              ],
            ),
            Positioned(
                top: 0,
                right: 0,
                child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.cF5F5F5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Row(children: [
                          SvgPicture.asset(Assets.star2, width: 8, height: 8),
                          const Sizer(width: 4),
                          Label(text: '4.4', style: Styles.smallText())
                        ]))))
          ],
        ),
        const Sizer(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: title,
                style:
                Styles.headerText(fontWeight: FontWeight.w600, fontSize: 32),
              ),
              if (widget.isSubscribed)
                Label(
                  text: 'Ear/Nose',
                  style: Styles.mediumText(),
                )
            ],
          ),
        ),
        Column(
          children: [
            Label(
              text: '20/01/2025',
              style:
              Styles.mediumText(),
            ),
              Label(
                text: '07:00 PM',
                style: Styles.mediumText(),
              )
          ],
        )
      ],
    );
  }

}
