import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/common/profile_picture_widget.dart';
import 'package:fourtyninehub/core/widget/common/trip_location_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/loading_dashboard/loading_dashboard_details_screen.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/domain/entities/available_trip_join_entity.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/trip_join/request_log_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AvailablePickMeBody extends StatelessWidget {
  const AvailablePickMeBody({super.key, required this.data});
  final AvailableTripJoinEntity data;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Sizer(),
        TripCardInfoWidget(
          firstName: data.creatorFirstName??'',lastName: data.creatorLastName??'',
            isMale: data.creatorGender == 'male',
            isVerified: data.creatorVerification??false,
            title: context.isArabic ? data.vehicleDetails?.brandAr ?? "" : data.vehicleDetails?.brandEn ?? "",
            model: context.isArabic ? data.vehicleDetails?.modelAr ?? "" : data.vehicleDetails?.modelEn ?? "",
            icon: Assets.tripJoinCarIcon,
            price: formatPrice(data.pricePerSeat?.round() ?? 0, context),
            seats: LocaleKeys.eachSeat.localize, context: context),
        const Sizer(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0.h,
          ),
          child: Column(
            children: [
              TripLocationWidget(title: data.location?.start?.address ?? "", isFrom: true),
              const Sizer(),
              TripLocationWidget(title: data.location?.target?.address ?? "", isFrom: false),
            ],
          ),
        ),
        const Sizer(),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatTimestamp(data.startDate ?? '', context),
                style: Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                // data.passengers == 1
                //     ? '${data.passengers} ${LocaleKeys.seat.localize}'
                //     : ''
                '${formatPrice(data.passengers ?? 1, context)} ${LocaleKeys.seat.localize}',
                style: Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                data.isRepeat == true ? LocaleKeys.repeated.localize : LocaleKeys.oneTime.localize,
                style: Styles.headerText(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  TripCardInfoWidget({
    required String firstName,
    required String lastName,
    required bool isMale,
    required bool isVerified,
    required String title,
    required String model,
    required String icon,
    required String price,
    required String seats,
    required BuildContext context,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 32.0.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                ProfilePictureWidget(
                  image: '',
                  firstChar: firstName[0].toUpperCase(),
                  hasStories: false,
                  isMale: isMale,
                  isVerified: isVerified,
                ),
                const Sizer(),
                Expanded(
                  child: Text(
                    "$firstName $lastName",
                    style: Styles.mediumText(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Sizer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                  text: TextSpan(children: [
                    TextSpan(text: "$price  ", style: Styles.headerText(color: AppColors.getTextColor(context), fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: context.isArabic ? 'ج.م' : 'EGP',
                      style: Styles.mediumText(fontSize: context.locale.languageCode == "ar" ? 35 : 28, fontWeight: FontWeight.w500, color: AppColors.getRedColor(context)),
                    )
                  ])),
              Row(
                spacing: 5,
                children: [
                  Label(
                    text: seats,
                    style: Styles.mediumText(fontWeight: FontWeight.bold, color: AppColors.getTextColor(context)),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
