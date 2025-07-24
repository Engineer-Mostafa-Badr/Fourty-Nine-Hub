import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/font_manager.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/one_way_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/domain/entities/my_booking_entity.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/driver_route_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/driver/widget/running_trip_client_widget.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../res/style/app_colors.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'available_ride_mode_widget.dart';

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
    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
        builder: (context, state) {
      var cubit = context.read<CaptainShareDashboardCubit>();
      if (cubit.isLoadingRunningTrip) {
        return const Center(child: CustomLoadingSearchWidget());
      }
      if(state.runningRoute==null||state.runningRoute?.status==''){
        return _emptyMessage();
      }
      BookingClientEntity? currentClient = cubit.getCurrentClient(state.runningRoute?.clients??[]);
      int currentIndex = cubit.getCurrentClientIndex(state.runningRoute?.clients??[]);
      print("state.runningRoute?.clients??[] ${state.runningRoute?.clients?.length}");
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        children: [
          DriverRouteWidget(
            hasAcceptButton:false,
            statusDriver: state.runningRoute?.status??'',
            model: state.runningRoute,
            cancelButton: false,
          ),
          if(state.runningRoute!=null&&(state.runningRoute?.clients?.isNotEmpty??false))RunningTripClientWidget(client:
          currentClient,index: currentIndex,
          onPickClient: (otp){
            cubit.goToClient(routeId: state.runningRoute?.id??'', passengerId: currentClient?.id??'', otp: otp, context: context);
          }, onDriverArrived: () {
              cubit.onDriverArrivedToClient(routeId: state.runningRoute?.id??'', passengerId: currentClient?.id??'');

            },onClientNotShown: () {
              cubit.onClientNotShown(routeId: state.runningRoute?.id??'', passengerId: currentClient?.id??'');
            },
          ),
        ],
      );
    });
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
