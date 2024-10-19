import 'package:flutter/material.dart';
// import 'package:flutter_mapbox_navigation/flutter_mapbox_navigation.dart';

class MapboxNavigationWidget extends StatefulWidget {
  // final WayPoint origin;
  // final WayPoint destination;

  const MapboxNavigationWidget({
    // required this.origin,
    // required this.destination,
    Key? key,
  }) : super(key: key);

  @override
  _MapboxNavigationWidgetState createState() => _MapboxNavigationWidgetState();
}

class _MapboxNavigationWidgetState extends State<MapboxNavigationWidget> {
  // late MapBoxNavigation _directions;
  // late MapBoxOptions _options;
  // bool _isNavigating = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _directions = MapBoxNavigation();
  //   _options = MapBoxOptions(
  //     mode: MapBoxNavigationMode.drivingWithTraffic,
  //     simulateRoute: false,
  //     language: "en",
  //     units: VoiceUnits.metric,
  //   );
  // }

  // Future<void> _startNavigation() async {
  //   var wayPoints = <WayPoint>[];
  //   wayPoints.add(widget.origin);
  //   wayPoints.add(widget.destination);

  //   await _directions.startNavigation(
  //     wayPoints: wayPoints,
  //     options: _options,
  //   );

  //   setState(() {
  //     _isNavigating = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SizedBox(
        //   height: 400,
        //   child: MapBoxNavigationView(
        //     options: _options,
        //     onCreated: (controller) async {
        //       await controller.buildRoute(
        //         wayPoints: [widget.origin, widget.destination],
        //       );
        //     },
        //   ),
        // ),
        // ElevatedButton(
        //   onPressed: _startNavigation,
        //   child: Text("Start Navigation"),
        // ),
        // if (_isNavigating)
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Text("Navigation in progress..."),
        //   ),
      ],
    );
  }
}
