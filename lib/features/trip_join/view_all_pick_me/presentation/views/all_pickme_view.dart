import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/views/my_pick_me_offers_widget.dart';
import 'package:fourtyninehub/features/trip_join/view_all_pick_me/presentation/views/request_log_pick_me.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/cubits/view_all_trip_join_cubit/view_all_trip_join_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'available_pickme_screen.dart';

class AllPickMeView extends StatefulWidget {
  const AllPickMeView({super.key});

  @override
  State<AllPickMeView> createState() => _AllPickMeViewState();
}

class _AllPickMeViewState extends State<AllPickMeView>
    with TickerProviderStateMixin {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _displayedCategory = LocaleKeys.availableTrips;

  //
  // late AnimationController _controller;
  // late Animation<double> _scaleAnimation;
  // late Animation<double> _positionAnimation;
  late TabController tabController;
  int selectedIndex = 0; // Changed to 0 to match availableTrips as default
  
  // Search functionality variables
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchText = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [
          _buildStatusCategories(),
          Sizer(
            height: 10.h,
          ),
          Expanded(child: _buildCardForCategory()),
        ]),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ViewAllTripJoinCubit>().getPickMeRequestCount();

    tabController = TabController(length: 3, vsync: this);
    // tabController.addListener(() {
    //   setState(() {});
    // });
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
    
    // Add listener to search controller
    _searchController.addListener(() {
      setState(() {
        _hasSearchText = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          setState(() {
            _isSearchVisible = !_isSearchVisible;
            if (!_isSearchVisible) {
              _searchController.clear();
              _hasSearchText = false;
            }
          });
        },
        child:Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: _isSearchVisible
                ? AppColors.SECONDARY_COLOR.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.search,
            size: 24,
            color: _isSearchVisible
                ? AppColors.SECONDARY_COLOR
                : null,
          ),
        ),
      ),
    );
  }


  Widget _buildCardForCategory() {
    switch (_displayedCategory) {
      case LocaleKeys.availableTrips:
        //TODO: Dont forget to add CustomLoadingSearchWidget for loading state in every DisplayTripJoinCard
        // اياك تنسى 🙂🔪
        return AvailablePickMeCard();
      case LocaleKeys.requestLog:
        return PickMeRequestLogTripJoinWidget();
      case LocaleKeys.myAds:
        return MyPickMeOffersWidget();

      default:
        return const SizedBox.shrink();
    }
  }

  _buildCategory({
    required String title,
    required int index,
  }) {
    bool selected = tabController.index == index;
    return GestureDetector(
      // onTap: () {
      //   tabController.animateTo(index);
      //   setState(() {
      //     _displayedCategory = title;
      //   });
      // },
      onTap: () {
        ManageVibration.vibrate();
        tabController.animateTo(index);
        if (index == 0) {
          // context.read<ViewAllTripJoinCubit>().loadInitialTripJoin();
          print("Fiiiiiiiiiirst");
        }
        if (index == 1) {
          print("Seeeeeecond");

          // context.read<ViewAllTripJoinCubit>().loadInitialRequestTripJoin();
        }
        setState(() {
          _displayedCategory = title;
          selectedIndex = index;
        });

        // Load data for the selected category
        // final cubit = context.read<ViewAllTripJoinCubit>();
        switch (title) {
          case LocaleKeys.availableTrips:
            break;
          case LocaleKeys.requestLog:
            break;
          case LocaleKeys.myAds:
            // cubit.loadInitialMyAds(); // Uncomment and reload when implemented
            break;
        }
      },
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10.h),
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40.h),
                color: selected
                    ? AppColors.getButtonPrimaryColor(context)
                    : AppColors.getFillColor(context),
                border: Border.all(
                    color: selected
                        ? AppColors.getRedColor(context)
                        : AppColors.getButtonPrimaryColor(context),
                    width: 2)),
            child: Center(
              child: Text(
                title.localize,
                style: Styles.headerText(
                    fontSize: 24,
                    color: selected
                        ? context.isDarkMode
                            ? Colors.black
                            : Colors.white
                        : AppColors.getTextColor(context)),
              ),
            ),
          ),
          Visibility(
            visible: title == LocaleKeys.requestLog &&
                (context.read<ViewAllTripJoinCubit>().state.pickMeRequestCountData?.countRequest ?? 0) > 0,
            child: Positioned(
              top: -3.h,
              right: 4.h,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.getRedColor(context)),
                child: Center(
                  child: Text(
                    formatCount(context.read<ViewAllTripJoinCubit>().state.pickMeRequestCountData?.countRequest ?? 0),
                    style: Styles.smallText(
                        color: context.isDarkMode
                            ? Colors.black
                            : AppColors.whiteColor,
                        fontSize: 20),
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
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.requestLog,
            index: 1,
          ),
        ),
        const Sizer(
          width: 10,
        ),
        Expanded(
          child: _buildCategory(
            title: LocaleKeys.myAds,
            index: 2,
          ),
        ),
      ],
    );
  }
}
