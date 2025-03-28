import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../widget/my_running_tab_widget.dart';

class RunningAndPastTripsScreen extends StatefulWidget {
  const RunningAndPastTripsScreen({super.key});

  @override
  State<RunningAndPastTripsScreen> createState() =>
      _RunningAndPastTripsScreenState();
}

class _RunningAndPastTripsScreenState extends State<RunningAndPastTripsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppbar(
        isWithBackArrow: false,
        language: true,
        isMenu: true,
        inNotifications: true,
      ),
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
        const SizedBox(height: 15),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBarRowRideModeWidget(
            tabController: _tabController,
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
          child: TabBarContentRideModeWidget(tabController: _tabController),
        ),
      ],
    );
  }
}

class ItemTabRideModeWidget extends StatelessWidget {
  final String text;
  final String icon;
  final int index;
  final TabController tabController;
  const ItemTabRideModeWidget(
      {super.key,
      required this.text,
      required this.icon,
      required this.index,
      required this.tabController});

  @override
  Widget build(BuildContext context) {
    bool isSelected = tabController.index == index;

    return GestureDetector(
      onTap: () => tabController.animateTo(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xffF88B92) : Colors.white,
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
                  color: isSelected ? Colors.black : Colors.grey),
            ),
          ),
          Positioned(top: -8, right: -8, child: SvgPicture.asset(icon)),
        ],
      ),
    );
  }
}

class TabBarRowRideModeWidget extends StatelessWidget {
  final TabController tabController;

  const TabBarRowRideModeWidget({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: ItemTabRideModeWidget(
            text: "My Running",
            icon: Assets.ideaIcon,
            index: 0,
            tabController: tabController,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ItemTabRideModeWidget(
            text: context.isArabic ? "الرحلات السابقة" : "Past Trips",
            icon: Assets.ideaIcon,
            index: 1,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AnimatedBuilder(
              animation: widget.tabController,
              builder: (context, child) {
                int index = widget.tabController.index;
                return Text(
                  context.isArabic ? arabicHints[index] : hints[index],
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              MyRunningTabWidget(
                clientNumberEn: "Go to first client",
                clientNumberAr: "الذهاب للعميل الأول",
                content: tabContents[0],
              ),
              PastTripsWidget(content: tabContents[1]),
            ],
          ),
        ),
      ],
    );
  }
}

class AvailableRideModeWidget extends StatelessWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final String? requestType;
  const AvailableRideModeWidget({
    super.key,
    this.statusDriver,
    this.cancelButton,
    this.requestType,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lady/ Lady Driver   ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    RichText(
                      text: const TextSpan(
                        text: "50 ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        children: [
                          TextSpan(
                            text: "EGP",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          context.isArabic ? "محجوز" : "Booked",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.bookedWoman),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          context.isArabic ? "محجوز" : "Booked",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.bookedWoman),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          context.isArabic ? "محجوز" : "Booked",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.bookedWoman),
                      ],
                    ),
                    Column(
                      children: [
                        Text(context.isArabic ? "مقعد" : "Seat",
                            style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.PRIMARY_COLOR)),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            statusDriver ?? "",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.circle, color: Colors.red, size: 12),
                    Expanded(
                      child: Divider(
                        color: AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    Icon(Icons.circle, color: Colors.red, size: 12),
                    Expanded(
                      child: Divider(
                        color: AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    Icon(Icons.circle, color: Colors.red, size: 12),
                    Expanded(
                      child: Divider(
                        color: AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    Icon(Icons.circle, color: Colors.blue, size: 12),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(Assets.circleGreen),
                    const SizedBox(width: 4),
                    const Text(
                      "Giza, Egypt",
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(Assets.circleBlue),
                    const SizedBox(width: 4),
                    const Text(
                      "Giza, Egypt",
                      style: TextStyle(
                        color: AppColors.PRIMARY_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                //      const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '10 mins ago',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        requestType ?? "",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    cancelButton == true
                        ? ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors.SECONDARY_COLOR)),
                            onPressed: () {},
                            child: const Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 160,
          child: SvgPicture.asset(
            Assets.frameIcon,
            width: 50,
          ),
        ),
      ],
    );
  }
}

class PastTripsWidget extends StatelessWidget {
  final List<String> content;
  const PastTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : const SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  cancelButton: false,
                  statusDriver: "Expired",
                  requestType: 'Regular',
                ),
                AvailableRideModeWidget(
                  statusDriver: "Expired",
                  requestType: 'Regular',
                ),
              ],
            ),
          );
  }
}

Widget _emptyMessage() {
  return Center(
    child: Text(
      'Your running trip right now.',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
    ),
  );
}
