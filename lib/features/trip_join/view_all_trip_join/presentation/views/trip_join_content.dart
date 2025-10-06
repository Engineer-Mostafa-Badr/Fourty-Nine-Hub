import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/widget/common/tab_widget.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import 'Modified_widgets/cards/available_trips_card.dart';
import 'widgets/trip_join/request_log_widget.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../helpers/manage_vibration.dart';
import '../cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';
import 'widgets/trip_join/my_trip_widget.dart';

class TripJoinContent extends StatefulWidget {
  const TripJoinContent({super.key});

  @override
  State<TripJoinContent> createState() => _TripJoinContentState();
}

class _TripJoinContentState extends State<TripJoinContent>
    with TickerProviderStateMixin {
  String _displayedCategory = LocaleKeys.availableTrips;
  int selectedIndex = 0;
  late TabController tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<ViewAllTripJoinCubit>().loadInitialTripJoin(false,'');

    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
        // Update category based on selected index
        switch (tabController.index) {
          case 0:
            _displayedCategory = LocaleKeys.availableTrips;
            break;
          case 1:
            _displayedCategory = LocaleKeys.requestLog;
            break;
          case 2:
            _displayedCategory = LocaleKeys.myAds;
            break;
        }
      });
    });

    // Load initial data for the default tab (Available Trips)
    context.read<ViewAllTripJoinCubit>().getRequestCount();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Call appropriate pagination method based on current category
      final cubit = context.read<ViewAllTripJoinCubit>();
      switch (_displayedCategory) {
        case LocaleKeys.availableTrips:
          cubit.getTripJoin();
          break;
        case LocaleKeys.requestLog:
          cubit.getRequestTripJoin();
          break;
        case LocaleKeys.myAds:
        cubit.getMyAds(); // Uncomment when implemented
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewAllTripJoinCubit, ViewAllTripJoinState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildStatusCategories(),
            Sizer(height: 10.h),
            Expanded(child:_buildCardForCategory(state)),
          ],
        );
      },
    );
  }

  Widget _buildCardForCategory( ViewAllTripJoinState state) {
    switch (_displayedCategory) {
      case LocaleKeys.availableTrips:
        return AvailableTripsCard();
      case LocaleKeys.requestLog:
        return RequestLogTripJoinWidget();
      case LocaleKeys.myAds:
        return MyAdsTripWidget();

      default:
        return const SizedBox.shrink();
    }
  }

  _buildStatusCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TabWidget(
            title: LocaleKeys.availableTrips,
            selected:tabController.index == 0, onTap: () {
            ManageVibration.vibrate();
            tabController.animateTo(0);
            context.read<ViewAllTripJoinCubit>().loadInitialTripJoin(false,'');
            setState(() {
              _displayedCategory = LocaleKeys.availableTrips;
              selectedIndex = 0;
            });

            // Load data for the selected category
            final cubit = context.read<ViewAllTripJoinCubit>();
            switch (LocaleKeys.availableTrips) {
              case LocaleKeys.availableTrips:
                break;
              case LocaleKeys.requestLog:
                break;
              case LocaleKeys.myAds:
                cubit.loadInitialMyAds(); // Uncomment and reload when implemented
                break;
            }
          },
          ),
        ),
        const Sizer(width: 10),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.requestLog,
            index: 1,
          ),
        ),
        const Sizer(width: 10),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.myAds,
            index: 2,
          ),
        ),
      ],
    );
  }

  _buildCategory({
    required String title,
    required int index,
  }) {
    bool selected = tabController.index == index;
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
        tabController.animateTo(index);
        if(index==0){
          context.read<ViewAllTripJoinCubit>().loadInitialTripJoin(false,'');
        }
        if(index == 1){
          print("Second");
          context.read<ViewAllTripJoinCubit>().loadInitialRequestTripJoin();
          context.read<ViewAllTripJoinCubit>().getRequestCount();
        }
        setState(() {
          _displayedCategory = title;
          selectedIndex = index;
        });

        // Load data for the selected category
        final cubit = context.read<ViewAllTripJoinCubit>();
        switch (title) {
          case LocaleKeys.availableTrips:
            break;
          case LocaleKeys.requestLog:
            break;
          case LocaleKeys.myAds:
          cubit.loadInitialMyAds(); // Uncomment and reload when implemented
            break;
        }
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h),
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.h),
              color: selected
                  ? AppColors.getButtonPrimaryColor(context)
                  : AppColors.getFillColor(context),
              border: Border.all(
                color: AppColors.getButtonPrimaryColor(context),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                title.localize,
                style: Styles.headerText(
                  fontSize: 24,
                  color: selected
                      ? context.isDarkMode
                      ? Colors.black
                      : Colors.white
                      : AppColors.getTextColor(context),
                ),
              ),
            ),
          ),
          Visibility(
            visible: title == LocaleKeys.requestLog &&
                (context.read<ViewAllTripJoinCubit>().state.requestCountData?.countRequest ?? 0) > 0,
            child: Positioned(
              top: -3.h,
              right: 4.h,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.getRedColor(context),
                ),
                child: Center(
                  child: Text(
                    formatCount(context.read<ViewAllTripJoinCubit>().state.requestCountData?.countRequest ?? 0),
                    style: Styles.smallText(
                      color: context.isDarkMode
                          ? Colors.black
                          : AppColors.whiteColor,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  String formatCount(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).floor()}K';
    } else {
      return '${(number / 1000000).floor()}M';
    }
  }

}
