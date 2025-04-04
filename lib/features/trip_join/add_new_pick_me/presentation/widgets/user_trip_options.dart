import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/add_new_pick_me/presentation/widgets/publish_button_v3_user_trip.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/date_time_picker_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/distance_and_price_per_person_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/driver_phone_number_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/select_seat_and_repeat_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/total_price_v2.dart';

import '../../../../../res/style/app_colors.dart';

class UserTripOptions extends StatelessWidget {
  const UserTripOptions({super.key});

  @override
  Widget build(BuildContext context) {
    const double size = 30;
    // Using GlobalKey as a field in a stateless widget is fine
    // It persists across rebuilds of this widget
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          const Sizer(),
          const DriverPhoneNumberV2(),
          const Sizer(),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(245, 245, 245, 1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const DistanceAndPricePerPersonV2(size: size),
                const Sizer(),
                const DateAndTimePickerV2(size: size),
                const SelectSeatAndRepeatV2(size: size),
                Sizer(height: 3.h),
                const TotalPriceV2(size: size),
              ],
            ),
          ),
          Sizer(height: 50.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PublishButtonV3UserTrip(
                  text: LocaleKeys.publish_permiun.localize,
                  formKey: formKey,
                  color: AppColors.colorRed,
                ),
              ),
              6.horizontalSpace,
              Expanded(child: PublishButtonV3UserTrip(formKey: formKey)),
            ],
          ),
        ],
      ),
    );
  }
}
