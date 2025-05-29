import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:latlong2/latlong.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../../../../common/widgets/OpenStreetMapSearchAndPick/open_street_map_search_and_pick.dart';
import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
class RideOpenStreetMapSearchAndPickParams{
  final void Function(PickedData) onPicked;
  final double minAllowedDistanceKm;
  final LatLng? minDistanceReferencePoint;
  const RideOpenStreetMapSearchAndPickParams({required this.onPicked, this.minAllowedDistanceKm = 1.5, this.minDistanceReferencePoint});
}
class RideOpenStreetMapSearchAndPick extends StatefulWidget {
  final RideOpenStreetMapSearchAndPickParams params;
  const RideOpenStreetMapSearchAndPick({super.key, required this.params});

  @override
  State<RideOpenStreetMapSearchAndPick> createState() => _RideOpenStreetMapSearchAndPickState();
}

class _RideOpenStreetMapSearchAndPickState extends State<RideOpenStreetMapSearchAndPick> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SharedScaffold(
          mainCategoryId: 2,
          body: NestedAppbar(
            scrollController: _scrollController,
            appBars: const [],
            body: OpenStreetMapSearchAndPick(
              buttonText: context.isArabic? 'تعيين الموقع المحدد' : 'Set Selected Location',
              buttonColor: AppColors.PRIMARY_COLOR,
              // baseUri: 'https://nominatim.openstreetmap.org',
              buttonTextStyle:
              const TextStyle(fontSize: 18, fontStyle: FontStyle.normal),
              onPicked: widget.params.onPicked,
              buttonTextColor: Colors.white,
              currentLocationIcon: Icons.my_location,
              hintText: context.isArabic? 'ابحث عن موقع' : 'Search for a location...',
              locationPinIcon: Icons.location_on,
              locationPinIconColor: Colors.red,
              locationPinText: context.isArabic? 'الموقع المحدد' : 'Selected Location',
              locationPinTextStyle:
               const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.PRIMARY_COLOR),
              zoomInIcon: Icons.zoom_in,
              zoomOutIcon: Icons.zoom_out,
              minAllowedDistanceKm: widget.params.minAllowedDistanceKm,
              minDistanceReferencePoint: widget.params.minDistanceReferencePoint,
              allowedCountryCode: 'eg', // eg, us, my, ae, sa
            ),
          ),
        ),
      ),
    );
  }
}
