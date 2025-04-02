import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../driver/screen/running_and_past_trips_screen.dart';
import '../../driver/widget/available_ride_mode_widget.dart';

class TabBarContentWidget extends StatefulWidget {
  final TabController tabController;

  const TabBarContentWidget({super.key, required this.tabController});

  @override
  _TabBarContentWidgetState createState() => _TabBarContentWidgetState();
}

class _TabBarContentWidgetState extends State<TabBarContentWidget> {
  final List<String> hints = [
    "Explore trips that are active at the moment.",
    "Manage and review your bookings here.",
    "Check your ongoing trips and track progress.",
    "See your past trips and history."
  ];

  final List<List<String>> tabContents = [
    [""], // Active Trips
    [""], // Bookings
    [""], // Ongoing Trips
    [""], // Past Trips
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedBuilder(
              animation: widget.tabController,
              builder: (context, child) {
                int index = widget.tabController.index;
                return Text(
                  hints[index],
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
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: [
              AvailableTripsWidget(content: tabContents[0]),
              BookingsWidget(content: tabContents[1]),
              RunningTripsWidget(content: tabContents[2]),
              ExpiredTripsWidget(content: tabContents[3]),
            ],
          ),
        ),
      ],
    );
  }
}

// 🔹 ويدجيت لكل تاب
class AvailableTripsWidget extends StatelessWidget {
  final List<String> content;
  const AvailableTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : const SingleChildScrollView(
            child: Column(
              children: [
                OneWayWidget(
                  requestType: 'Regular',
                  cancelButton: true,
                  statusDriver: "In Progress",
                ),
                OneWayWidget(
                  requestType: 'Comfort',
                  statusDriver: "In Progress",
                ),
              ],
            ),
          );
  }
}

class OneWayWidget extends StatelessWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final String? requestType;
  const OneWayWidget({
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
                      "Normal",
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
                        Text("Booked",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.bookedMan),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Free",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.freeIcon),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Free",
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.freeIcon),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Seat",
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
                    Icon(Icons.circle, color: Colors.green, size: 12),
                    Expanded(
                      child: Divider(
                        color: AppColors.PRIMARY_COLOR,
                        thickness: 2,
                      ),
                    ),
                    Icon(Icons.circle, color: Colors.green, size: 12),
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
                //   const SizedBox(height: 4),
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
                        ? GestureDetector(
                            child: Container(
                              width: 120.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: AppColors.SECONDARY_COLOR_DARK,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
          left: 160, // جعلها أسفل الكونتينر قليلاً
          child: SvgPicture.asset(
            Assets.frameIcon,
            width: 50,
          ),
        ),
      ],
    );
  }
}

class BookingsWidget extends StatelessWidget {
  final List<String> content;
  const BookingsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : const SingleChildScrollView(
            child: Column(
              children: [
                OneWayWidget(
                  statusDriver: "In Progress",
                  cancelButton: true,
                  requestType: "Comfort",
                ),
                OneWayWidget(
                  requestType: "Regular",
                ),
              ],
            ),
          );
  }
}

class RunningTripsWidget extends StatelessWidget {
  final List<String> content;
  const RunningTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : const SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  requestType: 'Regular',
                  cancelButton: false,
                  statusDriver: "Running",
                ),
                AvailableRideModeWidget(
                  requestType: 'Regular',
                  cancelButton: false,
                  statusDriver: "Running",
                ),
              ],
            ),
          );
  }
}

class ExpiredTripsWidget extends StatelessWidget {
  final List<String> content;
  const ExpiredTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : const SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  requestType: 'Regular',
                  cancelButton: false,
                  statusDriver: "Expired",
                ),
              ],
            ),
          );
  }
}

Widget _emptyMessage() {
  return Center(
    child: Text(
      "There is no trips in this list.",
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
