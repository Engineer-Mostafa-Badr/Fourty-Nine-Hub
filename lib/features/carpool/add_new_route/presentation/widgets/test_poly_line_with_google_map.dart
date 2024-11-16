import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/drawer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMapsWithRoute(
    String start, String end, String polyline) async {
  const String baseUrl = 'https://www.google.com/maps/dir/?api=1';

  final String url =
      '$baseUrl&origin=$start&destination=$end&path=enc:$polyline';

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class TestPolyLineWithGoogleMap extends StatelessWidget {
  // final String startLocation = '30.1088,31.31545'; // Example: San Francisco
  // final String endLocation = '30.06141,31.33169'; // Example: Los Angeles
  final String start;
  final String end;
  final String polyLine;

  const TestPolyLineWithGoogleMap(
      {super.key,
      required this.start,
      required this.end,
      required this.polyLine});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AvaialbleTripsButton(
        onTap: () async {
          await openGoogleMapsWithRoute(start, end, polyLine);
        },
        title: LocaleKeys.viewRoute.localize,
      ),
    );
  }
}
