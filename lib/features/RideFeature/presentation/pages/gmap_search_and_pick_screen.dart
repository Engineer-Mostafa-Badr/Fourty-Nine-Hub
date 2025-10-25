import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/gmap_search_and_pick.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

import '../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../controllers/cubits/ride_cubit.dart';

class RideOpenGoogleMapSearchAndPickScreen extends StatefulWidget {
  final RideGoogleMapSearchAndPickParams params;
  const RideOpenGoogleMapSearchAndPickScreen({super.key, required this.params});

  @override
  State<RideOpenGoogleMapSearchAndPickScreen> createState() => _RideOpenGoogleMapSearchAndPickScreenState();
}

class _RideOpenGoogleMapSearchAndPickScreenState extends State<RideOpenGoogleMapSearchAndPickScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedAppbar(
        scrollController: _scrollController,
        appBars: const [],
        body: RideGoogleMapSearchAndPick(
          params: RideGoogleMapSearchAndPickParams(
            onPicked: widget.params.onPicked,
            minAllowedDistanceKm: widget.params.minAllowedDistanceKm,
            minDistanceReferencePoint: widget.params.minDistanceReferencePoint,
            initialPosition: widget.params.initialPosition,
            initialAddress: widget.params.initialAddress,
            allowedCountryCode: serviceLocator<RideCubit>().getAvailableMapCountryKey, // eg, us, my, ae, sa
          ),
        ),
      ),
    );
  }
}
