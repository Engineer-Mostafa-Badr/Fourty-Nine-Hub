import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/available_trips_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/cards/display_trip_join_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_bottom_sheet/submit_bottom_sheet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/dialog_content.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/Modified_widgets/trip_join_dialog/show_dialog_trip_join.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/trip_join/request_log_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
  int selectedIndex = 0; // Changed to 0 to match availableTrips as default
  late TabController tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController()..addListener(_onScroll);

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
    context.read<ViewAllTripJoinCubit>().loadInitialTripJoin();
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
        return Stack(
          children: [
            Column(
              children: [
                _buildStatusCategories(),
                Sizer(height: 10.h),
                // SizedBox(
                //   height: 900,
                //   child: ListView.builder(
                //     shrinkWrap: true,
                //     controller: _scrollController,
                //     physics: const AlwaysScrollableScrollPhysics(),
                //     itemCount: _getItemCount(state) + (_isLoading(state) ? 1 : 0),
                //     itemBuilder: (BuildContext context, int index) {
                //       // Show loading indicator at the end
                //       if (index == _getItemCount(state) && _isLoading(state)) {
                //         return const Padding(
                //           padding: EdgeInsets.all(16.0),
                //           child: Center(child: CircularProgressIndicator()),
                //         );
                //       }
                //
                //       return _buildCardForCategory(index, state);
                //     },
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height,
                  child: Builder(
                    builder: (_) {
                      final itemCount = _getItemCount(state);
                      if (itemCount == 0 && !_isLoading(state)) {
                        return const Center(child: Text("No data found"));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: itemCount + (_isLoading(state) ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == itemCount && _isLoading(state)) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return _buildCardForCategory(index, state);
                        },
                      );
                    },
                  ),
                ),


              ],
            ),
          ],
        );
      },
    );
  }

  int _getItemCount(ViewAllTripJoinState state) {
    switch (_displayedCategory) {
      case LocaleKeys.availableTrips:
        return state.availableTripJoinEntity?.length ?? 0;
      case LocaleKeys.requestLog:
        return state.requestTripJoinEntity?.length ?? 0;
      case LocaleKeys.myAds:
        return state.myAdsTripJoinData?.length ?? 0;
      default:
        return 0;
    }
  }

  bool _isLoading(ViewAllTripJoinState state) {
    final cubit = context.read<ViewAllTripJoinCubit>();
    switch (_displayedCategory) {
      case LocaleKeys.availableTrips:
        return cubit.isLoadingMoreTripJoin;
      case LocaleKeys.requestLog:
        return cubit.isLoadingMoreRequestTripJoin;
      case LocaleKeys.myAds:
        return cubit.isLoadingMoreMyAds;
      default:
        return false;
    }
  }

  Widget _buildCardForCategory(int index, ViewAllTripJoinState state) {
    switch (_displayedCategory) {
      case LocaleKeys.availableTrips:
        final trip = state.availableTripJoinEntity?[index];
        if (trip == null) return const SizedBox.shrink();

        return AvailableTripsCard(
         // data: trip,
        );
      case LocaleKeys.requestLog:
        final requestList = context.read<ViewAllTripJoinCubit>().requestTripJoinData;

        if (requestList.isEmpty) {
          return const Center(child: Column(
            children: [
              Text("Empty data"),
            ],
          ));
        }

        final request = requestList[index];

        return RequestLogTripJoinWidget(
          data: request,
        );


      // case LocaleKeys.requestLog:
      //   final request = context.read<ViewAllTripJoinCubit>().requestTripJoinData?[index];
      //   // if (request == null) return const SizedBox.shrink();
      //   if(context.read<ViewAllTripJoinCubit>().requestTripJoinData.isEmpty && request == null){
      //     return Center(child: Text("Empty data"),);
      //   }
      //   // return Column(
      //   //   children: [
      //   //     Text("${request.phone}"),
      //   //     Text("${request.trip.toAr}"),
      //   //   ],
      //   // );
      //   return RequestLogTripJoinWidget(
      //    data: request!,
      //     fullRequestData: state.fullRequestTripJoinData,
      //   );

      case LocaleKeys.myAds:
        final myAd = context.read<ViewAllTripJoinCubit>().myAdsData[index];
        if (myAd == null) return const SizedBox.shrink();
        return MyAdsTripWidget(data: myAd,);
        // return TripJoinCard(
        //   subscribtionPlan: LocaleKeys.premium.localize,
        //   title: myAd.carModel ?? (context.isArabic ? 'كيا، سيراتو' : 'Kia, Cerato'),
        //   isMale: true,
        //   buttonTitle: LocaleKeys.deleteAd.localize,
        //   time: myAd.departureTime ?? (context.isArabic ? '8:00 م' : '8:00 Pm'),
        //   seats: myAd.availableSeats ?? 2,
        //   status: myAd.tripType ?? (context.isArabic ? 'مرة واحدة' : 'One Time'),
        //   isRequestButton: true,
        //   isContactInfo: false,
        //   iconCar: true,
        //   onTab: () => showDialogTripJoin(
        //     context,
        //     DialogContent(
        //       subTitle: LocaleKeys.areDeleteThisAd.localize,
        //       leftButtonTitle: LocaleKeys.deleteAd.localize,
        //       rightButtonTitle: LocaleKeys.close.localize,
        //     ),
        //   ),
        // );

      default:
        return const SizedBox.shrink();
    }
  }

  _buildStatusCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.availableTrips,
            index: 0,
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
        tabController.animateTo(index);
        setState(() {
          _displayedCategory = title;
          selectedIndex = index;
        });

        // Load data for the selected category
        final cubit = context.read<ViewAllTripJoinCubit>();
        switch (title) {
          case LocaleKeys.availableTrips:
            cubit.loadInitialTripJoin(); // Reload data every time
            break;
          case LocaleKeys.requestLog:
            cubit.loadInitialRequestTripJoin(); // Reload data every time
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
                color: selected
                    ? AppColors.getRedColor(context)
                    : AppColors.getButtonPrimaryColor(context),
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
            visible: title == LocaleKeys.requestLog,
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
                   "${formatCount(context.read<ViewAllTripJoinCubit>().state.requestCountData?.countRequest ?? 0)}",
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

