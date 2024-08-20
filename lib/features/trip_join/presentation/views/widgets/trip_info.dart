import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripInfo extends StatelessWidget {
  const TripInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      title: 'Trip Info',
      children: [
        const Sizer(),
        Text(
          'Distance: 100KM',
          style: Styles.headerText(),
        ),
        Text(
          'Price: 300LE',
          style: Styles.headerText(),
        ),
        const Sizer(),
      ],
    );
  }
}
