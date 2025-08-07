import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

// Function to open Google Maps with a polyline, start, and end points
Future<void> openGoogleMapsWithRoute(
    String start, String end, String polyline) async {
  // Base URL for Google Maps
  const String baseUrl = 'https://www.google.com/maps/dir/?api=1';

  // Format the URL for Google Maps with start, end, and polyline
  final String url =
      '$baseUrl&origin=$start&destination=$end&path=enc:$polyline';

  // Check if the URL can be launched
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class TestPolyLineWithGoogleMap extends StatelessWidget {
  // Sample polyline string
  final String polylineString =
      "_swvDqhc~DnAkDa@UiAo@aGkDwDwBl@gBdB}Et@iBR]\\e@Z]rBcB~EcEnA}@zDgDx@u@Zi@T_@fAkBx@uBJk@Ts@|CaGtDcHnFaLrCgFh@_An@o@l@qAj@u@pDeH|@iCXg@Pe@hA{B|A_DrBkEbAuBvB{DzA}Ct@sAtCgFl@m@b@S`BN|ANdFb@|E\\JAPI`AL|@LnAJpBLvBJtBP~El@dBP~BRpACfAFV@lCRnCRxFd@lOlAjD`@~@NVNzAD~D^nCZ|NnAhGd@tCTjF`@pE`@dABfALZBZNPNPTVv@P`AF|AFbANTh@Rj@J`@Cj@EfAGhAG~BMrEa@|@QfAIxBOnE[`CMVAF^RtBRbD\\vFFl@Lj@LnCPlE`@hHBp@V\\@@?@B@H@FCBI?ICGCCA?C[Ea@EgBMmB";

  // Define the start and end points
  final String startLocation = '30.1088,31.31545'; // Example: San Francisco
  final String endLocation = '30.06141,31.33169';

  const TestPolyLineWithGoogleMap({super.key}); // Example: Los Angeles

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
      ManageVibration.vibrate();
          await openGoogleMapsWithRoute(
              startLocation, endLocation, polylineString);
        },
        child: const Text('Show Route in Google Maps'),
      ),
    );
  }
}