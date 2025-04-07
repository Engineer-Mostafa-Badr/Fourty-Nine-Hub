import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_list/health_card_bottom_section.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/health_custom_card.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HealthEmergencyCard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const HealthEmergencyCard({
    super.key,
    required this.title,
    required this.isSubscribed,
    required this.buttonTitle,
    required this.onTab, required this.status,
  });

  final String title;
  final String buttonTitle;
  final String status;
  final bool isSubscribed;
  final void Function() onTab;

  @override
  State<HealthEmergencyCard> createState() => _HealthEmergencyCardState();
}

class _HealthEmergencyCardState extends State<HealthEmergencyCard> {
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
                margin: EdgeInsets.only(top: 56.h),
                padding: EdgeInsets.symmetric(horizontal: 32.h),
                radius: 20,
                children: [
                  const Sizer(),
                  TripCardInfoWidget(
                    title: widget.title,
                    icon:widget.isSubscribed? 'assets/images/doctor_profile.jpeg':Assets.maleUser ,
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
                  HealthCardButtonsSection(
                    isSubscribed: widget.isSubscribed,
                    buttonTitle: widget.buttonTitle,
                    onTap: widget.onTab,
                  ),
                  const Sizer(),
                ],
              ),
              _statusStack(),
            ],
          ),
        ],
      ),
    );
  }

  TripCardInfoWidget({
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
        Column(
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
        )
      ],
    );
  }
  _statusStack(){
    return Positioned(
      right: 0,
      top: 0,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)),
          color: Colors.white,
          border: Border.all(
            color: context.isDarkMode
                ? AppColors.PRIMARY_COLOR_DARK
                : AppColors.PRIMARY_COLOR_LIGHT,
          ),
        ),
        child: Text(
          widget.isSubscribed?widget.status:LocaleKeys.notSubscribed.localize,
          style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
        ),
      ),
    );
  }
}
