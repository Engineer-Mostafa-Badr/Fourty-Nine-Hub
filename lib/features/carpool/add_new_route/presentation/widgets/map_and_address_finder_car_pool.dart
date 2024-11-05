import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/carpool_google_map.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/dest_text_field_googlemap.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/starting_text_field_googlemap.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/welcome_text_car_pool.dart';

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

        // MapboxNavigationWidget(
        //   origin: WayPoint(
        //     name: "Alexandria",
        //     latitude: 31.2001, // Latitude for Alexandria
        //     longitude: 29.9187, // Longitude for Alexandria
        //   ),
        //   destination: WayPoint(
        //     name: "Cairo",
        //     latitude: 30.0444, // Latitude for Cairo
        //     longitude: 31.2357, // Longitude for Cairo
        //   ),
        // ),

        // RouteMapWidget(
        //   startPoint: startPoint,
        //   endPoint: endPoint,
        // ),
        const Sizer(height: 20),
        const StartTextFieldAndFindButonGoogleMap(),
        const Sizer(height: 20),
        const DestinationTextFieldAndFindButonGoogleMap(),
        const Sizer(height: 30),
      ],
    );
  }
}
