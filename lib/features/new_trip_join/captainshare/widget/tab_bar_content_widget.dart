import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../driver/widget/available_ride_mode_widget.dart';
import '../../presentation/view/widget/taps/tab_bar_row_widget.dart';
import 'one_way_widget.dart';

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
  bool _hasTappedTab = false; // ✅ أضفنا دا

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TabBarRowWidget(
            onTap: () {
              setState(() {
                _hasTappedTab = !_hasTappedTab; // ✅ يقلب الحالة
              });
            },
            tabController: widget.tabController,
          ),
        ),
        SizedBox(height: 10.h),
        if (_hasTappedTab)
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
                ...List.generate(
                  5,
                  (index) => OneWayWidget(
                    requestType: LocaleKeys.regular.localize,
                    statusDriver: LocaleKeys.expired.localize,
                  ),
                ),

                // OneWayWidget(
                //   requestType: LocaleKeys.comfort.localize,
                //   statusDriver: LocaleKeys.expired.localize,
                // ),
                SizedBox(height: 100.h),
              ],
            ),
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
