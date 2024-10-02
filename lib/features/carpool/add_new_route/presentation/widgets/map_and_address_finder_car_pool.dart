import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/carpool_google_map.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/welcome_text_car_pool.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';

class MapAndAddressFinderCarPool extends StatelessWidget {
  const MapAndAddressFinderCarPool({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...welcomeTextCarPool(context),
        const CarPoolGoogleMap(),
        const Sizer(height: 20),
        const StartTextFieldAndFindButon(),
        const Sizer(height: 20),
        const DestinationTextFieldAndFindButon(),
        const Sizer(height: 30),
      ],
    );
  }
}
