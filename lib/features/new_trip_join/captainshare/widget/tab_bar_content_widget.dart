import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_cubit/captain_share_cubit.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/header_text_widget.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';
import '../../presentation/view/widget/taps/tab_bar_row_widget.dart';
import 'one_way_widget.dart';

class TabBarContentWidget extends StatefulWidget {
  const TabBarContentWidget({super.key, required TabController tabController})
      : _tabController = tabController;
  final TabController _tabController;

  @override
  _TabBarContentWidgetState createState() => _TabBarContentWidgetState();
}

class _TabBarContentWidgetState extends State<TabBarContentWidget> {
  final List<String> hints = [
    "Explore trips that are active at the moment.",
    "All your bookings in one place!",
    "Join available trips near you now.",
    "Browse recently completed trips."
  ];
  final List<String> hintsArabic = [
    "استكشف الرحلات النشطة في الوقت الحالي",
    "جميع حجوزاتك في مكان واحد!",
    "انضم إلى الرحلات المتاحة بالقرب منك الآن.",
    "تصفح الرحلات المنجزة مؤخرًا."
  ];

  final List<List<String>> tabContents = [
    [""], // Active Trips
    [""], // Bookings
    [""], // Ongoing Trips
    [""], // Past Trips
  ];
  final bool _hasTappedTab = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
        builder: (context, state) {
      var cubit = context.read<CaptainShareCubit>();
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          const Center(child: HeaderTextWidget()),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.h),
            child: TabBarRowWidget(
              onTap: (index) {
                cubit.onChangeTapIndex(index, context);
                log("state.tapIndex ${state.tapIndex}");
              },
              onShowHint: (index) {
                cubit.onShowHintTap(index, context);
              },
              tabController: widget._tabController,
            ),
          ),
          SizedBox(height: 10.h),
          if (state.hintText != null && (state.hintText?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: AnimatedBuilder(
                  animation: widget._tabController,
                  builder: (context, child) {
                    return Text(
                      context.isArabic
                          ? hintsArabic[state.tapIndex ?? 0]
                          : hints[state.tapIndex ?? 0],
                      style: TextStyle(
                        color: const Color(0xffFF0808),
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
          Expanded(child: _buildCategory(controller: widget._tabController)),
        ],
      );
    });
  }

  _buildCategory({
    required TabController controller,
  }) {
    switch (context.read<CaptainShareCubit>().state.tapIndex) {
      case 0:
        return AvailableTripsWidget(content: tabContents[0]);
      case 1:
        return BookingsWidget(content: tabContents[1]);
      case 2:
        return RunningTripsWidget(content: tabContents[2]);
      case 3:
        return ExpiredTripsWidget(content: tabContents[3]);
      default:
        return const SizedBox.shrink();
    }
  }
}

// 🔹 ويدجيت لكل تاب
class AvailableTripsWidget extends StatefulWidget {
  final List<String> content;

  const AvailableTripsWidget({super.key, required this.content});

  @override
  State<AvailableTripsWidget> createState() => _AvailableTripsWidgetState();
}

class _AvailableTripsWidgetState extends State<AvailableTripsWidget> with TickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CaptainShareCubit>().getAvailableBookings(context);
    }
  }

  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
      builder: (context,state) {
        var cubit = context.read<CaptainShareCubit>();
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: isFloatingButtonVisible
              ? buildFloatingAction(context,child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.push(Routes.captainShareInfoScreen);
                  },
                  child: Container(
                    height: 48.h,
                    width: 48.h,
                    decoration: BoxDecoration(
                        color: AppColors.getButtonPrimaryColor(context),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                      size: 19,
                      Icons.question_mark,
                      color: context.isDarkMode
                          ? AppColors.black
                          : Colors.white,
                    ),
                  ),
                ),
                CustomElevatedButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                      cubit.onNavigateToCreateRoute(context);
                    },
                    backgoundColor: AppColors.getButtonPrimaryColor(context),
                    child: Label(
                      text: context.isArabic ? "إنشاء مسار +" : "Create Route +",
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.getReversedTextColor(context),
                      ),
                    ))
              ],
            ),
          ), () {
          })
              : null,
          body: cubit.isLoadingAvailableBookings
              ? const Center(child: CustomLoadingSearchWidget())
              : cubit.availableBookings.isEmpty
              ? _emptyMessage()
              : ListView.separated(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemBuilder: (context, index) => OneWayWidget(
              requestType: LocaleKeys.regular.localize,
              statusDriver: cubit.availableBookings[index].status,
              model: cubit.availableBookings[index],
              cancelButton: ((UserCubit.to.state.data?.id ?? '') ==
                  cubit.availableBookings[index].creatorId) &&
                  cubit.availableBookings[index].status == 'pending',
              onCancelBooking: () {
                if (cubit.availableBookings[index].status ==
                    'pending') {
                  cubit.cancelMyBooking(
                      id: cubit.availableBookings[index].id,
                      context: context,
                      from: 'available');
                }
              },
              onJoin: (phone) {
                print(
                    "(cubit.availableBookings[index].clients??[]).any((e)=>e.id==UserCubit.to.state.data?.id) ${(cubit.availableBookings[index].clients ?? []).any((e) => e.id == UserCubit.to.state.data?.id)}");
                if ((!(cubit.availableBookings[index].clients ?? [])
                    .any((e) =>
                e.id == UserCubit.to.state.data?.id)) &&
                    cubit.availableBookings[index].status ==
                        'pending') {
                  cubit.joinToRoute(
                      phone: phone,
                      id: cubit.availableBookings[index].id,
                      context: context);
                }
              },
            ),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: cubit.availableBookings.length,
          ),
        );
      }
    );
  }
}

class BookingsWidget extends StatefulWidget {
  final List<String> content;

  const BookingsWidget({super.key, required this.content});

  @override
  State<BookingsWidget> createState() => _BookingsWidgetState();
}

class _BookingsWidgetState extends State<BookingsWidget> with TickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _scrollController.addListener(_scrollListener);

  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CaptainShareCubit>().getMyBookings(context);
    }
  }
  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
        builder: (context,state) {
          var cubit = context.read<CaptainShareCubit>();
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isFloatingButtonVisible
                ? buildFloatingAction(context,child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(Routes.captainShareInfoScreen);
                    },
                    child: Container(
                      height: 48.h,
                      width: 48.h,
                      decoration: BoxDecoration(
                          color: AppColors.getButtonPrimaryColor(context),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        size: 19,
                        Icons.question_mark,
                        color: context.isDarkMode
                            ? AppColors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                      onPressed: () {
                        ManageVibration.vibrate();
                        cubit.onNavigateToCreateRoute(context);
                      },
                      backgoundColor: AppColors.getButtonPrimaryColor(context),
                      child: Label(
                        text: context.isArabic ? "إنشاء مسار +" : "Create Route +",
                        style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          color: AppColors.getReversedTextColor(context),
                        ),
                      ))
                ],
              ),
            ), () {
            })
                : null,
            body: cubit.isLoadingMyBookings
                ? const Center(child: CustomLoadingSearchWidget())
                : cubit.myBookings.isEmpty
                ? _emptyMessage()
                : ListView.separated(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ClickableWidget(
                onTap: cubit.myBookings[index].status=='accepted'||cubit.myBookings[index].status=='running'?(){
                  context.push(Routes.RunningMapDetails,extra: cubit.myBookings[index]);
                }:null,
                child: OneWayWidget(
                    onTap: (cubit.myBookings[index].status=='accepted'||cubit.myBookings[index].status=='running')?(){}:null,
                    requestType: LocaleKeys.regular.localize,
                    statusDriver: cubit.myBookings[index].status,
                    model: cubit.myBookings[index],
                    cancelButton: ((UserCubit.to.state.data?.id ?? '') ==
                        cubit.myBookings[index].creatorId) &&
                        cubit.myBookings[index].status == 'pending',
                    onCancelBooking: () {
                      if (cubit.myBookings[index].status == 'pending') {
                        cubit.cancelMyBooking(
                            id: cubit.myBookings[index].id,
                            context: context,
                            from: 'myBookings');
                      }
                    }),
              ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: cubit.myBookings.length,
            ),
          );
        }
    );
  }
}

class RunningTripsWidget extends StatefulWidget {
  final List<String> content;

  const RunningTripsWidget({super.key, required this.content});

  @override
  State<RunningTripsWidget> createState() => _RunningTripsWidgetState();
}

class _RunningTripsWidgetState extends State<RunningTripsWidget> with TickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CaptainShareCubit>().getRunningBookings(context);
    }
  }

  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState((){});
    }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
        builder: (context,state) {
          var cubit = context.read<CaptainShareCubit>();
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isFloatingButtonVisible
                ? buildFloatingAction(context,child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push(Routes.captainShareInfoScreen);
                    },
                    child: Container(
                      height: 48.h,
                      width: 48.h,
                      decoration: BoxDecoration(
                          color: AppColors.getButtonPrimaryColor(context),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(
                        size: 19,
                        Icons.question_mark,
                        color: context.isDarkMode
                            ? AppColors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                      onPressed: () {
                        ManageVibration.vibrate();
                        cubit.onNavigateToCreateRoute(context);
                      },
                      backgoundColor: AppColors.getButtonPrimaryColor(context),
                      child: Label(
                        text: context.isArabic ? "إنشاء مسار +" : "Create Route +",
                        style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          color: AppColors.getReversedTextColor(context),
                        ),
                      ))
                ],
              ),
            ), () {
            })
                : null,
            body: cubit.isLoadingRunningBookings
                ? const Center(child: CustomLoadingSearchWidget())
                : cubit.runningBookings.isEmpty
                ? _emptyMessage()
                : ListView.separated(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => ClickableWidget(
                onTap: (){
                  context.push(Routes.RunningMapDetails,extra: cubit.runningBookings[index]);
                },
                child: OneWayWidget(
                    onTap: (){
                    },
                    requestType: LocaleKeys.regular.localize,
                    statusDriver: cubit.runningBookings[index].status,
                    model: cubit.runningBookings[index],
                    cancelButton: ((UserCubit.to.state.data?.id ?? '') ==
                        cubit.runningBookings[index].creatorId) &&
                        cubit.runningBookings[index].status == 'pending',
                    onCancelBooking: () {
                      if (cubit.runningBookings[index].status == 'pending') {
                        cubit.cancelMyBooking(
                            id: cubit.runningBookings[index].id,
                            context: context,
                            from: 'runningBookings');
                      }
                    }),
              ),
              separatorBuilder: (context, index) => const Sizer(),
              itemCount: cubit.runningBookings.length,
            )
          );
        }
    );
  }
}

class ExpiredTripsWidget extends StatefulWidget {
  final List<String> content;

  const ExpiredTripsWidget({super.key, required this.content});

  @override
  State<ExpiredTripsWidget> createState() => _ExpiredTripsWidgetState();
}

class _ExpiredTripsWidgetState extends State<ExpiredTripsWidget> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CaptainShareCubit>().getExpiredBookings(context);
    }
  }

  bool isFloatingButtonVisible = true;
  void _scrollListener() {

    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      isFloatingButtonVisible = false;
    } else {
      isFloatingButtonVisible = true;
    }
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareCubit, CaptainShareState>(
        builder: (context,state) {
          var cubit = context.read<CaptainShareCubit>();
          return Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
              floatingActionButton: isFloatingButtonVisible
                  ? buildFloatingAction(context,child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(Routes.captainShareInfoScreen);
                      },
                      child: Container(
                        height: 48.h,
                        width: 48.h,
                        decoration: BoxDecoration(
                            color: AppColors.getButtonPrimaryColor(context),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          size: 19,
                          Icons.question_mark,
                          color: context.isDarkMode
                              ? AppColors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    CustomElevatedButton(
                        onPressed: () {
                          ManageVibration.vibrate();
                          cubit.onNavigateToCreateRoute(context);
                        },
                        backgoundColor: AppColors.getButtonPrimaryColor(context),
                        child: Label(
                          text: context.isArabic ? "إنشاء مسار +" : "Create Route +",
                          style: Styles.mediumText(
                            fontWeight: FontWeight.bold,
                            color: AppColors.getReversedTextColor(context),
                          ),
                        ))
                  ],
                ),
              ), () {
              })
                  : null,
              body: cubit.isLoadingExpiredBookings
                  ? const Center(child: CustomLoadingSearchWidget())
                  : cubit.expiredBookings.isEmpty
                  ? _emptyMessage()
                  : ListView.separated(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => OneWayWidget(
                    requestType: LocaleKeys.regular.localize,
                    statusDriver: cubit.expiredBookings[index].status,
                    model: cubit.expiredBookings[index],
                    cancelButton: ((UserCubit.to.state.data?.id ?? '') ==
                        cubit.expiredBookings[index].creatorId) &&
                        cubit.expiredBookings[index].status == 'pending',
                    onCancelBooking: () {
                      if (cubit.expiredBookings[index].status ==
                          'pending') {
                        cubit.cancelMyBooking(
                            id: cubit.expiredBookings[index].id,
                            context: context,
                            from: 'expiredBookings');
                      }
                    }),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: cubit.expiredBookings.length,
              )
          );
        }
    );
  }
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
