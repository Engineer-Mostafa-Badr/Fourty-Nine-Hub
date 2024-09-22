import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/car_info_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/date_time_picker_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/distance_and_price_per_person_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/driver_phone_number_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/publish_button_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/select_seat_and_repeat_v2.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/total_price_v2.dart';

class TripAndCarInformationV2 extends StatefulWidget {
  const TripAndCarInformationV2({super.key});

  @override
  State<TripAndCarInformationV2> createState() => _TripAndCarInformationV2State();
}

class _TripAndCarInformationV2State extends State<TripAndCarInformationV2> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double size = 30;
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Sizer(),
          DistanceAndPricePerPersonV2(size: size),
          const Sizer(),
          DateAndTimePickerV2(size: size),
          SelectSeatAndRepeatV2(size: size),
          Sizer(height: 3.h),
          TotalPriceV2(size: size),
          const Sizer(),
          const DriverPhoneNumberV2(),
          const Sizer(),
          const CarInfoV2(),
          Sizer(height: 20.h),
          PublishButton(formKey: formKey),
          const Sizer(),
        ],
      ),
    );
  }
}
