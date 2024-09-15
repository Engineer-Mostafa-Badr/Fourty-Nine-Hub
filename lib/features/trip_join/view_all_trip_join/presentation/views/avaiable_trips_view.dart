import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trips_floating_action_button.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/avilable_trips_body.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class AvailableTripsView extends StatelessWidget {
  const AvailableTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    // FirebaseHelper.getToken();
    // FirebaseHelper.setupInteractedMessage();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Transform(
            transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
            child: Text(
              LocaleKeys.availableTrips.localize,
              style: Styles.headerText(),
            ),
          ),
        ),
        body: const Stack(
          children: [
            SizedBox(width: double.infinity, height: double.infinity),
            AvailableTripsBody(),
            AvailableTripsFloatingActionButton(),
          ],
        ),
      ),
    );
  }
}
