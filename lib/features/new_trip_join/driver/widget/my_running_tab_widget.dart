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

class MyRunningTabWidget extends StatefulWidget {
  final String? clientNumberEn;
  final String? clientNumberAr;
  final void Function()? onPressed;
  final List<String> content;

  const MyRunningTabWidget({
    super.key,
    required this.content,
    this.clientNumberEn,
    this.clientNumberAr,
    this.onPressed,
  });

  @override
  State<MyRunningTabWidget> createState() => _MyRunningTabWidgetState();
}

class _MyRunningTabWidgetState extends State<MyRunningTabWidget> {
  final TextEditingController otpController = TextEditingController();
  late ScrollController _scrollController;
  bool _isVisible = true;
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<CaptainShareDashboardCubit>().getAvailableBookings(context);
    }
  }
  // @override
  // void dispose() {
  //   otpController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(builder: (context, state) {
      var cubit = context.read<CaptainShareDashboardCubit>();
      return Stack(
        children: [
          cubit.isLoadingAvailableBookings?const Center(child: CircularProgressIndicator()):cubit.availableBookings.isEmpty?_emptyMessage():ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) => OneWayWidget(
              requestType: LocaleKeys.regular.localize,
              statusDriver: cubit.availableBookings[index].status,
              model: cubit.availableBookings[index],
              cancelButton: ((UserCubit.to.state.data?.id ?? '') == cubit.availableBookings[index].creatorId) && cubit.availableBookings[index].status == 'pending',
              onCancelBooking: () {
                if (cubit.availableBookings[index].status == 'pending') {
                  // cubit.cancelMyBooking(id: cubit.availableBookings[index].id, context: context, from: 'available');
                }
              },
              onJoin: (){
                if((!(cubit.availableBookings[index].clients??[]).contains((UserCubit.to.state.data?.id ?? '')))&&cubit.availableBookings[index].status == 'pending'){
                  // cubit.joinToRoute(id: cubit.availableBookings[index].id, context: context);
                }
              },
            ),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: cubit.availableBookings.length,
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

