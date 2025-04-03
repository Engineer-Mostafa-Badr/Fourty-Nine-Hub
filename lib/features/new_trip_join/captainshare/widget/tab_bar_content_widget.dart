import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
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
                  context.isArabic ? hintsArabic[index] : hints[index],
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
        : SingleChildScrollView(
            child: Column(
              children: [
                OneWayWidget(
                  requestType: LocaleKeys.regular.localize,
                  cancelButton: true,
                  statusDriver: LocaleKeys.expired.localize,
                ),
                OneWayWidget(
                  requestType: LocaleKeys.comfort.localize,
                  statusDriver: LocaleKeys.expired.localize,
                ),
                SizedBox(height: 100.h),
              ],
            ),
          );
  }
}

class OneWayWidget extends StatefulWidget {
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
  _OneWayWidgetState createState() => _OneWayWidgetState();
}

class _OneWayWidgetState extends State<OneWayWidget> {
  bool isContainerVisible = false; // لتخزين حالة ظهور الـ Container

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.normal.localize,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "50 ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: context.isArabic ? "جنيه مصري" : "EGP",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
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
                          LocaleKeys.booked.localize,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(Assets.bookedMan),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          LocaleKeys.free.localize,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(
                          Assets.freeIcon,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          LocaleKeys.free.localize,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SvgPicture.asset(
                          Assets.freeIcon,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          LocaleKeys.seat.localize,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, left: 5),
                          child: Text(
                            widget.statusDriver ?? "",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.red, size: 12),
                      Expanded(
                        child: Divider(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      const Icon(Icons.circle, color: Colors.green, size: 12),
                      Expanded(
                        child: Divider(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      const Icon(Icons.circle, color: Colors.green, size: 12),
                      Expanded(
                        child: Divider(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      const Icon(Icons.circle, color: Colors.blue, size: 12),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(Assets.circleGreen),
                    const SizedBox(width: 4),
                    Text(
                      context.isArabic ? "الجيزة، مصر" : "Giza, Egypt",
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SvgPicture.asset(Assets.circleBlue),
                    const SizedBox(width: 4),
                    Text(
                      context.isArabic ? "الجيزة، مصر" : "Giza, Egypt",
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      context.isArabic ? "منذ 10 دقائق" : '10 mins ago',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        widget.requestType ?? "",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    widget.cancelButton == true
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
                                  LocaleKeys.cancel.localize,
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

        // الأيقونة التي عند الضغط عليها ستظهر الـ Container
        Positioned(
          bottom: 9,
          left: 170, // جعلها أسفل الكونتينر قليلاً
          child: GestureDetector(
            onTap: () {
              setState(() {
                isContainerVisible =
                    !isContainerVisible; // تغيير الحالة عند الضغط
              });
            },
            child: SvgPicture.asset(
              Assets.frameIcon,
              width: 50,
            ),
          ),
        ),

        // هنا يتم التحكم في ظهور الـ Container
        // Visibility(
        //   visible: isContainerVisible,
        //   child: Positioned(
        //     //  bottom: 20,
        //     top: 220,
        //     left: 30,
        //     child: Container(
        //       width:
        //           MediaQuery.of(context).size.width - 60, // عرض الـ Container
        //       padding: const EdgeInsets.all(20),
        //       decoration: BoxDecoration(
        //         color: Colors.blue, // لون الـ Container
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: Column(
        //         children: [
        //           Text(
        //             "هذا هو الـ Container الذي يظهر فوق الكونتينر الأصلي",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           Text(
        //             "هذا هو الـ Container الذي يظهر فوق الكونتينر الأصلي",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           Text(
        //             "هذا هو الـ Container الذي يظهر فوق الكونتينر الأصلي",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           Text(
        //             "هذا هو الـ Container الذي يظهر فوق الكونتينر الأصلي",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           Text(
        //             "هذا هو الـ Container الذي يظهر فوق الكونتينر الأصلي",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //           Text(
        //             "هذا هو الـ Container الذي يظهر فوق الكونتينر الأصلي",
        //             style: TextStyle(color: Colors.white),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
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
        : SingleChildScrollView(
            child: Column(
              children: [
                OneWayWidget(
                  cancelButton: true,
                  statusDriver: LocaleKeys.expired.localize,
                  requestType: LocaleKeys.regular.localize,
                ),
                OneWayWidget(
                  statusDriver: LocaleKeys.expired.localize,
                  requestType: LocaleKeys.regular.localize,
                ),
                SizedBox(height: 100.h),
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
        : SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  requestType: LocaleKeys.regular.localize,
                  cancelButton: false,
                  statusDriver: LocaleKeys.running.localize,
                ),
                AvailableRideModeWidget(
                  requestType: LocaleKeys.regular.localize,
                  cancelButton: false,
                  statusDriver: LocaleKeys.running.localize,
                ),
                SizedBox(height: 100.h),
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
        : SingleChildScrollView(
            child: Column(
              children: [
                AvailableRideModeWidget(
                  requestType: LocaleKeys.regular.localize,
                  cancelButton: false,
                  statusDriver: LocaleKeys.expired.localize,
                ),
              ],
            ),
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
