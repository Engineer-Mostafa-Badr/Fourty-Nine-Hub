import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';

// import 'location';
class GoogleMapTracking extends StatefulWidget {
  const GoogleMapTracking(
      {super.key, required this.startLocation, required this.endLocation});
  final LatLng startLocation;
  final LatLng endLocation;

  @override
  State<GoogleMapTracking> createState() => _GoogleMapTrackingState();
}

class _GoogleMapTrackingState extends State<GoogleMapTracking> {
  final Completer<GoogleMapController> _controller = Completer();
  List<LatLng> polyLine = [];
  List<List> polyLineLatLong = [
    [31.315524, 30.108829],
    [31.316347, 30.108433],
    [31.316367, 30.108465],
    [31.317304, 30.107986],
    [31.317479, 30.107874],
    [31.318179, 30.107427],
    [31.318579, 30.107896],
    [31.318925, 30.108306],
    [31.319023, 30.108421],
    [31.319227, 30.108661],
    [31.319277, 30.10872],
    [31.31945, 30.108924],
    [31.319677, 30.109191],
    [31.319818, 30.109348],
    [31.320071, 30.10964],
    [31.320255, 30.109852],
    [31.320349, 30.109823],
    [31.320481, 30.109767],
    [31.320698, 30.109635],
    [31.32083, 30.109512],
    [31.32137, 30.1089],
    [31.321684, 30.108543],
    [31.321818, 30.108386],
    [31.322068, 30.108106],
    [31.322206, 30.107985],
    [31.322287, 30.107937],
    [31.322355, 30.107915],
    [31.322487, 30.107761],
    [31.322931, 30.10724],
    [31.32313, 30.107007],
    [31.323249, 30.106866],
    [31.323409, 30.106705],
    [31.323811, 30.106361],
    [31.323987, 30.106173],
    [31.324141, 30.106086],
    [31.324256, 30.106051],
    [31.324436, 30.105992],
    [31.324613, 30.105902],
    [31.325261, 30.105521],
    [31.325551, 30.105349],
    [31.325644, 30.105294],
    [31.328453, 30.103637],
    [31.330089, 30.102623],
    [31.331429, 30.101815],
    [31.331734, 30.101631],
    [31.331944, 30.101505],
    [31.332346, 30.101263],
    [31.332534, 30.10115],
    [31.33375, 30.10042],
    [31.334443, 30.100003],
    [31.335592, 30.099313],
    [31.335678, 30.09926],
    [31.336049, 30.099042],
    [31.337849, 30.097983],
    [31.340581, 30.096326],
    [31.340847, 30.096165],
    [31.341041, 30.096049],
    [31.341686, 30.095662],
    [31.34172, 30.095546],
    [31.34178, 30.095472],
    [31.341989, 30.095322],
    [31.342085, 30.095177],
    [31.342113, 30.095045],
    [31.342071, 30.09474],
    [31.34205, 30.094606],
    [31.341975, 30.094176],
    [31.341598, 30.091691],
    [31.341628, 30.091533],
    [31.341586, 30.091244],
    [31.341574, 30.09117],
    [31.341423, 30.090114],
    [31.341344, 30.089578],
    [31.341163, 30.088387],
    [31.341105, 30.088012],
    [31.341067, 30.087766],
    [31.341037, 30.087562],
    [31.340983, 30.087196],
    [31.340901, 30.086777],
    [31.340926, 30.086669],
    [31.340924, 30.086517],
    [31.339858, 30.079484],
    [31.339776, 30.079121],
    [31.339677, 30.0787],
    [31.339576, 30.078118],
    [31.339396, 30.077035],
    [31.339117, 30.075098],
    [31.339015, 30.074561],
    [31.338953, 30.074149],
    [31.338876, 30.073635],
    [31.338805, 30.073169],
    [31.33875, 30.072802],
    [31.338678, 30.072323],
    [31.338611, 30.071882],
    [31.338552, 30.071486],
    [31.338545, 30.071426],
    [31.338512, 30.071214],
    [31.338479, 30.071002],
    [31.338418, 30.0706],
    [31.338349, 30.070145],
    [31.33834, 30.070081],
    [31.338286, 30.069727],
    [31.338237, 30.06942],
    [31.338163, 30.069229],
    [31.338004, 30.069018],
    [31.337782, 30.068855],
    [31.336961, 30.068768],
    [31.336527, 30.068604],
    [31.336467, 30.068559],
    [31.33633, 30.068398],
    [31.336281, 30.068277],
    [31.336264, 30.06815],
    [31.336271, 30.068114],
    [31.336421, 30.067257],
    [31.336484, 30.066804],
    [31.336505, 30.066638],
    [31.33665, 30.065626],
    [31.336672, 30.065476],
    [31.336807, 30.064442],
    [31.336833, 30.064297],
    [31.336978, 30.0633],
    [31.337003, 30.063096],
    [31.337071, 30.062422],
    [31.336985, 30.062346],
    [31.336829, 30.062247],
    [31.336674, 30.062179],
    [31.336557, 30.062145],
    [31.334741, 30.061928],
    [31.334185, 30.061863],
    [31.331388, 30.061563],
    [31.331011, 30.061523],
    [31.330193, 30.061432],
    [31.330072, 30.061404],
    [31.330002, 30.061391],
    [31.329948, 30.061351],
    [31.329921, 30.061294],
    [31.329943, 30.061205],
    [31.33003, 30.06115],
    [31.330102, 30.061148],
    [31.330167, 30.061177],
    [31.330193, 30.061203],
    [31.330363, 30.061246],
    [31.33121, 30.06132],
    [31.331694, 30.061371]
  ];
  // LocationData? currentLocation;
  Future<void> getCurrentLocation() async {
    // Location location = Location();
    // location.getLocation().then(
    //   (value) {
    //     log(value.toString(), name: "location");
    //     currentLocation = value;
    //   },
    // );
    GoogleMapController googleMapController = await _controller.future;
    // location.onLocationChanged.listen(
    //   (event) {
    //     currentLocation = event;
    //     googleMapController.animateCamera(CameraUpdate.newCameraPosition(
    //         CameraPosition(target: LatLng(event.latitude!, event.longitude!))));
    //     setState(() {});
    //   },
    // );
  }

  Future<void> getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
            origin: PointLatLng(
                widget.startLocation.latitude, widget.startLocation.longitude),
            destination: PointLatLng(
                widget.endLocation.latitude, widget.endLocation.longitude),
            mode: TravelMode.driving),
        googleApiKey: UIConst.googleGeocodingApiKey);
    if (result.points.isNotEmpty) {
      for (var element in result.points) {
        polyLine.add(LatLng(element.latitude, element.longitude));
      }
    }
    log(polyLine.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    getPolyPoints();
  }

  @override
  Widget build(BuildContext context) {
    // log(currentLocation.toString());
    return Scaffold(
      body: 
      // currentLocation == null
          // ? const Center(
          //     child: CircularProgressIndicator(
          //       color: AppColors.PRIMARY_COLOR,
          //     ),
          //   )
          // :
           GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: widget.startLocation, zoom: 13),
              polylines: {
                Polyline(
                  polylineId: const PolylineId("polyline"),
                  points: polyLineLatLong.map((e) => LatLng(e.last, e.first),).toList(),
                  color: Colors.blue,
                  // width: 2
                )
              },
              markers: {
                Marker(
                    markerId: const MarkerId("start"),
                    position: widget.startLocation),
                Marker(markerId: const MarkerId("end"), position: widget.endLocation),
              },
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
            ),
    );
  }
}
