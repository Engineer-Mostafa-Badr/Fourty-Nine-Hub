import 'package:flutter/material.dart';

import 'widgets/map_section.dart';



class RideRequestScreen extends StatelessWidget {
  const RideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          const MapSection(),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Padding(
          //     padding: const EdgeInsets.only(top: 40.0),
          //     child: TopCardRequest(
          //       driverName: "IBRAHEM",
          //       driverRating: 4.0,
          //       ratingCount: 10,
          //       totalTrips: 1500,
          //       carModel: "Hyundai Verna",
          //       timeDistance: "4 min, 1.5 KM",
          //       price: 150,
          //       driverImage: "https://maps.gstatic.com/tactile/pane/default_geocode-2x.png",
          //       onAccept: () {
          //         context.push(Routes.RideStatusScreen);
          //       },
          //       onRefuse: () {
          //         context.push(Routes.RideStatusScreen);
          //
          //       },
          //     ),
          //   ),
          // ),

          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: BottomCardRequest(
          //     driversCount: 3,
          //     price: 120,
          //     onCancel: () {
          //
          //     },
          //   ),
          // ),

        ],
      ),
    );
  }
}
