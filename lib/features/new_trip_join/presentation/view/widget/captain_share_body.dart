import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import '../../../../../res/assets/assets.dart';
import '../../../../../routes/routes.dart';
import 'header_text_widget.dart';
import '../../../captainshare/widget/tab_bar_content_widget.dart';
import 'taps/tab_bar_row_widget.dart';
import 'trip_option_widget.dart';

class CaptainShareBody extends StatefulWidget {
  const CaptainShareBody({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  _CaptainShareBodyState createState() => _CaptainShareBodyState();
}

class _CaptainShareBodyState extends State<CaptainShareBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.2).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _positionAnimation = Tween<double>(begin: 200, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 250), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _positionAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: TripOptionWidget(
                borderColor: Colors.red,
                containerColor: Colors.white,
                iconColor: const Color(0xffF33D49),
                textColor: const Color(0xffF33D49),
                imagePath: Assets.locationTripIcon,
                title: context.isArabic ? 'مشاركة كابتن' : 'Captain\nShare',
                onTap: () {},
              ),
            ),
            TripOptionWidget(
              imagePath: Assets.locationTripIcon,
              title: context.isArabic ? "جاي معاك" : "Trip Join",
              onTap: () {
                context.push(Routes.AVAILABLE_TRIPS);
              },
              icon: Assets.car,
            ),
            TripOptionWidget(
              imagePath: Assets.locationTripIcon,
              title: context.isArabic ? "وصلني معاك" : "Pick me",
              onTap: () {},
              icon: Assets.pickMeImage,
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Center(child: HeaderTextWidget()),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TabBarRowWidget(tabController: widget._tabController),
        ),
        Expanded(
            child: TabBarContentWidget(tabController: widget._tabController)),
      ],
    );
  }
}
