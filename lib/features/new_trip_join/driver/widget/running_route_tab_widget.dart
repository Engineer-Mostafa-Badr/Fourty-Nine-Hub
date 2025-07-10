import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/one_way_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
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
    context.read<CaptainShareDashboardCubit>().getRunningRoute(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(builder: (context, state) {
      var cubit = context.read<CaptainShareDashboardCubit>();
      if(state.isLoading){
        return const Center(child: CircularProgressIndicator());
      }
      if(cubit.runningRoute==null){
        return _emptyMessage();
      }
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          OneWayWidget(
            requestType: LocaleKeys.regular.localize,
            hasAcceptButton:false,
            statusDriver: cubit.runningRoute?.status??'',
            model: cubit.runningRoute,
            cancelButton: false,
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

