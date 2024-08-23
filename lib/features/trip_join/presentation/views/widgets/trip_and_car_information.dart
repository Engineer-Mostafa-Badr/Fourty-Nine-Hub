import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/car_info.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_info.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_additional_information.dart';

class TripAndCarInformation extends StatelessWidget {
  const TripAndCarInformation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TripJoinAdditionalInformation(),
        const Sizer(height: 20),
        const CarInfo(),
        const Sizer(height: 20),
        const TripInfoBuilder(),
        const Sizer(height: 20),
        CustomButton(onTap: () {}, title: 'Publish', height: 50),
        const Sizer(height: 20),
      ],
    );
  }
}
