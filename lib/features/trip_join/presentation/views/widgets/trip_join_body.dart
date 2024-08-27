import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/illustration_image.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/trip_join_google_map.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/welcome_text.dart';

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
            children: [
              ...welcomeText(),
              const Sizer(),
              const IllustrationImage(),
              const Sizer(height: 20),
              const StartTextFieldAndFindButon(),
              const Sizer(),
              const DestinationTextFieldAndFindButon(),
              const Sizer(height: 20),
              const TripJoinGoogleMap(),
            ],
          ),
        ),
      ),
    );
  }
}
