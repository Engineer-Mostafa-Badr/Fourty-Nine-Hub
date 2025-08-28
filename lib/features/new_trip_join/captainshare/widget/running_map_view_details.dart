import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/build_running_trip_sheet.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RunningMapViewDetails extends StatefulWidget {
  const RunningMapViewDetails({super.key, this.model});
  final MyBookingEntity? model;

  @override
  State<RunningMapViewDetails> createState() => _RunningMapViewDetailsState();
}

class _RunningMapViewDetailsState extends State<RunningMapViewDetails> {

  @override
  initState(){
    super.initState();
    context.read<CaptainShareCubit>().getRunningRoute(context);
  }

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[0], point[1])).toList();
  }
  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
      builder: (context,state) {

        return Scaffold(
          appBar: AppBar(
              title: Text(
                  context.isArabic ? 'تفاصيل الرحلة' : 'Route Details')),
          body: BlocBuilder<CaptainShareCubit, CaptainShareState>(
            builder: (context,state) {

              if(state.isLoading){
                return const Center(child: CustomCircularProgressIndicator(),);
              }else{
                List<LatLng> routePoints = [];
                List<dynamic> polyLine =context.read<CaptainShareCubit>().state.runningRoute?.currentPolyline ?? [];

                List<List<double>> parsedPolyline = polyLine
                    .map<List<double>>(
                        (item) => (item as List).map((e) => (e as num).toDouble()).toList())
                    .toList();
                routePoints = _convertPolylineToLatLng(parsedPolyline);

                LatLng? startLocation = routePoints.first;
                LatLng? targetLocation = routePoints.last;

                return Stack(
                  children: [
                    CustomGoogleMap(
                      startLocation: startLocation,
                      targetLocation: targetLocation,
                      polylinePoints: routePoints,
                    ),
                    BuildRunningTripSheet(
                      model: state.runningRoute!,
                    ),
                  ],
                );
              }
            }
          ),
        );
      }
    );
  }
}
