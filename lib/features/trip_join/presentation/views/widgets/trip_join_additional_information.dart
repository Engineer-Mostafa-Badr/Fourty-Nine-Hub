import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/repeated_check_box.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/seats_number.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinAdditionalInformation extends StatelessWidget {
  const TripJoinAdditionalInformation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Additonal Information',
      children: [
        const Sizer(),
        const RepeatedCheckBox(),
        Text(
          'If the trip is repeated regulary please select the above checkbox',
          style: Styles.mediumText(),
        ),
        const Sizer(),
        const SeatsNumberWidget(),
        const Sizer(),
      ],
    );
  }
}
