import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/captainshare/widget/one_way_widget.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';


class PastRoutesTabWidget extends StatefulWidget {
  final String? clientNumberEn;
  final String? clientNumberAr;
  final void Function()? onPressed;
  final List<String> content;

  const PastRoutesTabWidget({
    super.key,
    required this.content,
    this.clientNumberEn,
    this.clientNumberAr,
    this.onPressed,
  });

  @override
  State<PastRoutesTabWidget> createState() => _PastRoutesTabWidgetState();
}

class _PastRoutesTabWidgetState extends State<PastRoutesTabWidget> {
  final TextEditingController otpController = TextEditingController();
  late ScrollController _scrollController;
  final bool _isVisible = true;
  final double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CaptainShareDashboardCubit>().getPastBookings(context);
    }
  }
  // @override
  // void dispose() {
  //   otpController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
        builder: (context, state) {
      var cubit = context.read<CaptainShareDashboardCubit>();
      return Stack(
        children: [
          cubit.isLoadingPastBookings
              ? const Center(child: CustomLoadingSearchWidget())
              : cubit.pastBookings.isEmpty
                  ? _emptyMessage()
                  : ListView.separated(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => OneWayWidget(
                        requestType: LocaleKeys.regular.localize,
                        hasAcceptButton: true,
                        onAccept: () {
                          cubit.acceptRoute(
                              id: cubit.pastBookings[index].id,
                              context: context);
                        },
                        statusDriver: cubit.pastBookings[index].status,
                        model: cubit.pastBookings[index],
                        cancelButton: ((UserCubit.to.state.data?.id ?? '') ==
                                cubit.pastBookings[index].creatorId) &&
                            cubit.pastBookings[index].status == 'pending',
                        onCancelBooking: () {
                          if (cubit.pastBookings[index].status == 'pending') {
                            // cubit.cancelMyBooking(id: cubit.pastBookings[index].id, context: context, from: 'available');
                          }
                        },
                        onJoin: (phone) {
                          if ((!(cubit.pastBookings[index].clients ?? [])
                                  .contains(
                                      (UserCubit.to.state.data?.id ?? ''))) &&
                              cubit.pastBookings[index].status == 'pending') {
                            // cubit.joinToRoute(id: cubit.pastBookings[index].id, context: context);
                          }
                        },
                      ),
                      separatorBuilder: (context, index) => const Sizer(),
                      itemCount: cubit.pastBookings.length,
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
