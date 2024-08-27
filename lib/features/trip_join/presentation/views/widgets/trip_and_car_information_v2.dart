import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/car_info_v2.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/date_time_picker_v2.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/distance_and_price_per_person_v2.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/driver_phone_number_v2.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/publish_button_v2.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/select_seat_and_repeat_v2.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/total_price_v2.dart';

class TripAndCarInformationV2 extends StatelessWidget {
  const TripAndCarInformationV2({super.key});

  @override
  Widget build(BuildContext context) {
    double size = 30;
    return Column(
      children: [
        const Sizer(),
        DistanceAndPricePerPersonV2(size: size),
        const Sizer(),
        DateAndTimePickerV2(size: size),
        SelectSeatAndRepeatV2(size: size),
        const Sizer(height: 3),
        TotalPriceV2(size: size),
        const Sizer(),
        const DriverPhoneNumberV2(),
        const Sizer(),
        const CarInfoV2(),
        const Sizer(height: 20),
        const PublishButton(),
        const Sizer(),
      ],
    );
  }
}
