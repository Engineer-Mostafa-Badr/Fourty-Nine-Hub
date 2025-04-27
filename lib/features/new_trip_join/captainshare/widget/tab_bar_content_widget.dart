import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/new_trip_join/presentation/view/widget/header_text_widget.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../driver/widget/available_ride_mode_widget.dart';
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
  bool _hasTappedTab = false; // ✅ أضفنا دا
  @override
  void initState() {
    super.initState();
    print(widget._tabController.index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        const Center(child: HeaderTextWidget()),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0.h),
          child: TabBarRowWidget(
            onTap: () {
              setState(() {
                _hasTappedTab = !_hasTappedTab; // ✅ يقلب الحالة
              });
              print(widget._tabController.index);
            },
            tabController: widget._tabController,
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
                animation: widget._tabController,
                builder: (context, child) {
                  int index = widget._tabController.index;
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
        _buildCategory(controller: widget._tabController),
      ],
    );
  }

  _buildCategory({
     required TabController controller,
  }) {
    switch (controller.index) {
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
class AvailableTripsWidget extends StatelessWidget {
  final List<String> content;

  const AvailableTripsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) => OneWayWidget(
                  requestType: LocaleKeys.regular.localize,
                  statusDriver: LocaleKeys.expired.localize,
                ),
            separatorBuilder: (context, index) => const Sizer(),
            itemCount: 5);
  }
}

class BookingsWidget extends StatelessWidget {
  final List<String> content;

  const BookingsWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return content.isEmpty
        ? _emptyMessage()
        : Column(
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
        : Column(
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
        : Column(
            children: [
              AvailableRideModeWidget(
                requestType: LocaleKeys.regular.localize,
                cancelButton: false,
                statusDriver: LocaleKeys.expired.localize,
              ),
            ],
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
