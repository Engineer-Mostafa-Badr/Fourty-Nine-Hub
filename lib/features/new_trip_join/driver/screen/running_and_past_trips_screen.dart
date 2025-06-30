import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/new_trip_join/controllers/captain_share_dashboard_cubit/captain_share_dashboard_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/assets/assets.dart';
import '../widget/my_running_tab_widget.dart';
import '../widget/past_trips_widget.dart';
import '../../../../core/widget/custom_scaffold.dart';

class RunningAndPastTripsScreen extends StatefulWidget {
  const RunningAndPastTripsScreen({super.key});

  @override
  State<RunningAndPastTripsScreen> createState() =>
      _RunningAndPastTripsScreenState();
}

class _RunningAndPastTripsScreenState extends State<RunningAndPastTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SharedScaffold(
    mainCategoryId: 1,isWithBackArrow: true,
      body: RunningAndPastTripsBody(
        tabController: _tabController,
      ),
    );
  }
}

class RunningAndPastTripsBody extends StatelessWidget {
  const RunningAndPastTripsBody({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 25),
        const SizedBox(height: 5),
        Expanded(
          child: TabBarContentRideModeWidget(tabController: _tabController),
        ),
      ],
    );
  }
}

class ItemTabRideModeWidget extends StatelessWidget {
  final void Function()? onTap;

  final String text;
  final String icon;
  final int index;
  final TabController tabController;
  const ItemTabRideModeWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.index,
      required this.tabController,
      this.onTap});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
  builder: (context, state) {
    var cubit = context.read<CaptainShareDashboardCubit>();
    bool isSelected = cubit.state.tapIndex == index;
    return GestureDetector(
      onTap: () => cubit.changeTapIndex(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xffF88B92) : AppColors.getFillColor(context),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : context.isDarkMode?Colors.white:Colors.grey),
            ),
          ),
          Positioned(
            top: -14,
            right: -6,
            child: GestureDetector(
              onTap: onTap,
              child: SvgPicture.asset(
                icon,
              ),
            ),
          ),
        ],
      ),
    );
  },
);
  }
}

class TabBarRowRideModeWidget extends StatelessWidget {
  final void Function()? onTap;

  final TabController tabController;

  const TabBarRowRideModeWidget(
      {super.key, required this.tabController, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ItemTabRideModeWidget(
            onTap: onTap,
            text: context.isArabic ? "رحلات متاحة" : "Available Routes",
            icon: Assets.ideaIcon,
            index: 0,
            tabController: tabController,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ItemTabRideModeWidget(
            onTap: onTap,
            text: context.isArabic ? "رحلات جارية" : "Running Routes",
            icon: Assets.ideaIcon,
            index: 1,
            tabController: tabController,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ItemTabRideModeWidget(
            onTap: onTap,
            text: context.isArabic ? "رحلات منتهية" : "Expired Routes",
            icon: Assets.ideaIcon,
            index: 2,
            tabController: tabController,
          ),
        ),
      ],
    );
  }
}

class TabBarContentRideModeWidget extends StatefulWidget {
  final TabController tabController;

  const TabBarContentRideModeWidget({super.key, required this.tabController});
  @override
  _TabBarContentRideModeWidgetState createState() =>
      _TabBarContentRideModeWidgetState();
}

class _TabBarContentRideModeWidgetState
    extends State<TabBarContentRideModeWidget> {
  final List<String> hints = [
    "Join available trips near you now.",
    "Browse recently completed trips.",
  ];
  final List<String> arabicHints = [
    "انضم إلى الرحلات المتاحة بالقرب منك الآن.",
    "تصفح الرحلات المنجزة مؤخرًا.",
  ];
  final List<List<String>> tabContents = [
    [""],
    [""],
  ];
  bool showHint = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CaptainShareDashboardCubit, CaptainShareDashboardState>(
  builder: (context, state) {
    var cubit = context.read<CaptainShareDashboardCubit>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBarRowRideModeWidget(
            onTap: () {
              setState(() {
                showHint = !showHint;
              });
            },
            tabController: widget.tabController,
          ),
        ),
        SizedBox(height: 10),
        if (showHint)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: context.isDarkMode?AppColors.fill_Color_DARK:Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: AnimatedBuilder(
                animation: widget.tabController,
                builder: (context, child) {
                  int index = widget.tabController.index;
                  return Text(
                    context.isArabic ? arabicHints[index] : hints[index],
                    style: TextStyle(
                      color: AppColors.getRedColor(context),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        Expanded(
          child: state.tapIndex==0?MyRunningTabWidget(
            clientNumberEn: "Go to first client",
            clientNumberAr: "الذهاب للعميل الأول",
            content: tabContents[0],
          ):state.tapIndex==1?PastTripsWidget(
            content: tabContents[1],
          ):Container(),)
      ],
    );
  },
);
  }
}
