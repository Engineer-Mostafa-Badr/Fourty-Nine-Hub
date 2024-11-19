import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/destination_text_field_and_find_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/google_map_view_addres.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/start_text_field_and_find_widget.dart';

class MapAndAddressFinderRide extends StatelessWidget {
  const MapAndAddressFinderRide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        GoogleMapViewAddres(),
        Sizer(height: 20),
        StartTextFieldAndFindWidget(),
        Sizer(height: 20),
        DestinationTextFieldAndFindRideWidget(),
      ],
    );
  }
}
