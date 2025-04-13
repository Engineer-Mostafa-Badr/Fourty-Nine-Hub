import 'package:easy_localization/easy_localization.dart' as EasyLocale;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_card_bottom_section.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinCard extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  const TripJoinCard({
    super.key,
    required this.time,
    required this.seats,
    required this.status,
    required this.title,
    required this.isMale,
    required this.isContactInfo,
    required this.isRequestButton, required this.iconCar, required this.buttonTitle, required this.onTab, required this.subscribtionPlan,
  });

  final String time;
  final int seats;
  final String status;
  final String subscribtionPlan;
  final String title;
  final String buttonTitle;
  final bool isMale;
  final bool isContactInfo;
  final bool isRequestButton;
  final bool iconCar;
  final void Function() onTab;
  @override
  State<TripJoinCard> createState() => _TripJoinCardState();
}

class _TripJoinCardState extends State<TripJoinCard> {
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CustomCard(
                radius: 20,
                children: [
                  const Sizer(),
                  TripCardInfoWidget(
                    title: widget.title,
                    icon:widget.iconCar?Assets.tripJoinCarIcon: widget.isMale ? Assets.maleUser : Assets.femaleUser,
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  _locationWidget(
                      title: context.isArabic ? 'الجيزة، مصر' : 'Giza, Egypt',
                      iconColor: AppColors.LIGHT_BLUE),
                  const Sizer(),
                  _locationWidget(
                      title: context.isArabic ? 'الجيزة، مصر' : 'Giza, Egypt',
                      iconColor: AppColors.CHECK_MARK_COLOR),
                  const Sizer(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.time,
                          style: Styles.headerText(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.seats == 1
                              ? '${widget.seats} ${LocaleKeys.seat.localize}'
                              : '${widget.seats} ${LocaleKeys.seat.localize}',
                          style: Styles.headerText(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.status,
                          style: Styles.headerText(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.0.h,
                    ),
                    child: TripJoinButtonsSection(
                      isContactInfo: widget.isContactInfo,
                      isRequestButton:widget.isRequestButton,
                      buttonTitle: widget.buttonTitle,
                      onTap:widget.onTab,
                    ),
                  ),
                  const Sizer(),
                ],
              ),
            ],
          ),
          TripCardSubscribeText(),
        ],
      ),
    );
  }

  _locationWidget({required String title, required Color iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.trip_origin, color: iconColor, size: 20),
          const Sizer(width: 13),
          Flexible(
            child: Text(
              title,
              style: Styles.headerText(fontSize: 32),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  TripCardInfoWidget({
    required String title,
    required String icon,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: 48.h,
            fit: BoxFit.cover,
          ),
          const Sizer(),
          Text(
            title,
            style: Styles.headerText(),
          ),
          Expanded(child: Container()),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text: '${20} ',
                style: Styles.headerText(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            TextSpan(
              text: context.isArabic ? 'جنيه' : 'EGP',
              style: Styles.mediumText(
                  fontSize: context.locale.languageCode == "ar" ? 35 : 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.SECONDARY_COLOR),
            )
          ]))
        ],
      ),
    );
  }

  TripCardSubscribeText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 10.h, 20.h, 0),
      child: InkWell(
        onTap: () => showDialogTripJoin(
            context,
            DialogContent(
              subTitle: LocaleKeys.pleaseSubscribeToContactTheClient.localize,
              leftButtonTitle: LocaleKeys.close.localize,
              rightButtonTitle: LocaleKeys.subscribe.localize,
            )),
        child: Text(
          LocaleKeys.subscribeToContactClient.localize,
          style: Styles.headerText(
            color: AppColors.getSecondryColor(context),
            fontSize: 30,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}
