import 'package:flutter/material.dart';
import 'package:google_static_maps_controller/google_static_maps_controller.dart';

import '../../../../res/style/const.dart';

class StaticMapWidget extends StatelessWidget {
  final double? height, width, radius;
  final List<Location> paths;
  final List<Marker> markers;
  const StaticMapWidget(
      {super.key,
      this.height,
      this.width,
      this.radius,
      this.paths = const [],
      this.markers = const []});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: StaticMap(
        googleApiKey: UIConst.googleMapAPIKey,
        width: width,
        height: height,
        scaleToDevicePixelRatio: true,
        zoom: 13,

        // styles: retroMapStyle,
        paths: <Path>[
          Path(
            color: Colors.black,
            points: paths,
          ),
        ],
        markers: markers,
      ),
    );
  }
}
