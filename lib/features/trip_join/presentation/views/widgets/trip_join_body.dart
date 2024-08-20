import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_google_map.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/welcome_text.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripJoinBody extends StatelessWidget {
  const TripJoinBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...welcomeText(),
              const Sizer(),
              const Divider(),
              const Sizer(),
              const TripJoinGoogleMap(),
              const Sizer(height: 20),
              Text('Starting Point', style: Styles.headerText()),
              const StartTextFieldAndFindButon(),
              const Sizer(height: 20),
              Text('Destination Point', style: Styles.headerText()),
              const DestinationTextFieldAndFindButon(),
              const Sizer(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
