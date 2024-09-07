import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_card.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/custom_fading_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class NotificationCardLoadingList extends StatelessWidget {
  const NotificationCardLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(2));
    const double height = 50;
    return Column(
      children: [
        ...List.generate(
            10,
            (index) => CustomFadingWidget(
                  child: NotificationCardLoading(decoration: decoration, height: height),
                )),
      ],
    );
  }
}

class NotificationCardLoading extends StatelessWidget {
  const NotificationCardLoading({
    super.key,
    required this.decoration,
    required this.height,
  });

  final BoxDecoration decoration;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: NotificationCustomContainer(
        color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: CustomGrayContainer(decoration: decoration, height: height * 1.25, flex: 10),
            ),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  CustomGrayContainer(decoration: decoration, height: height, flex: 4),
                  CustomGrayContainer(decoration: decoration, height: height * 0.8, flex: 6),
                  CustomGrayContainer(decoration: decoration, height: height * 0.7, flex: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomGrayContainer extends StatelessWidget {
  const CustomGrayContainer({
    super.key,
    required this.decoration,
    required this.height,
    required this.flex,
  });

  final BoxDecoration decoration;
  final double height;
  final int flex;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Row(children: [
        Expanded(flex: flex, child: Container(height: height, decoration: decoration)),
        Expanded(flex: 1, child: Container(height: height))
      ]),
    );
  }
}
