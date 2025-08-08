import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/screen/custom_map.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/build_route_clients_sheet.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/driver_route_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/running_trip_client_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';

class RunningRouteTabWidget extends StatefulWidget {
  const RunningRouteTabWidget({
    super.key,
  });

  @override
  State<RunningRouteTabWidget> createState() => _RunningRouteTabWidgetState();
}

class _RunningRouteTabWidgetState extends State<RunningRouteTabWidget> {
  @override
  void initState() {
    super.initState();
    // context.read<CaptainShareDashboardCubit>().getRunningRoute(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(builder: (context, state) {
      var cubit = context.read<CaptainShareDashboardCubit>();
      if (cubit.isLoadingRunningTrip) {
        return const Center(child: CustomLoadingSearchWidget());
      }
      if (state.runningRoute == null || state.runningRoute?.status == '') {
        return _emptyMessage();
      }

      int currentIndex = cubit.getCurrentClientIndex(state.runningRoute?.clients ?? []);
      print("state.runningRoute?.clients??[] ${state.runningRoute?.clients?.length}");
      return RefreshIndicator(
        onRefresh: ()async{
          await cubit.getRunningRoute(context);
        },
        child: Expanded(
          child: Stack(
            // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            children: [
              _buildTopMap(context,state),
              // DriverRouteWidget(
              //   hasAcceptButton: false,
              //   statusDriver: state.runningRoute?.status ?? '',
              //   model: state.runningRoute,
              //   cancelButton: false,
              // ),
              BuildRouteClientsSheet(clients: cubit.clients),
          
            ],
          ),
        ),
      );
    });
  }
  Widget _buildTopMap(BuildContext context, CaptainShareDashboardState state) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: ClipRect(
        child: CustomGoogleMap(
          startLocation: null,
          targetLocation: null,
          enableScrolling: true,
        ),
      ),
    );
  }

  List<LatLng> _convertPolylineToLatLng(List<List<double>> polyline) {
    return polyline.map((point) => LatLng(point[1], point[0])).toList();
  }


  Widget _emptyMessage() {
    return Center(
      child: Text(
        LocaleKeys.thereIsNoTripsInThisList.localize,
        style: TextStyle(
          fontSize: 28.sp,
          fontWeight: FontWeight.w600,
          color: const Color(
            0xff727272,
          ),
        ),
      ),
    );
  }
}
