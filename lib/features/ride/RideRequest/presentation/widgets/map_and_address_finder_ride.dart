import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/carpool_google_map.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dest_text_field_googlemap.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/starting_text_field_googlemap.dart';

class MapAndAddressFinderRide extends StatelessWidget {
  const MapAndAddressFinderRide({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CarPoolGoogleMap(),
        const Sizer(height: 20),
        const StartTextFieldAndFindButonGoogleMap(),
        const Sizer(height: 20),
        const DestinationTextFieldAndFindButonGoogleMap(),
      ],
    );
  }
}
