import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../add_new_trip_join/presentation/views/widgets/card.dart';
import '../../../view_all_trip_join/presentation/views/widgets/custom_fading_widget.dart';

class TripJoinRequestHistoryLoadingList extends StatelessWidget {
  const TripJoinRequestHistoryLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(2));
    const double height = 30;
    return Column(
      children: [
        ...List.generate(
          10,
          (index) => CustomFadingWidget(
            child: TripJoinRequestHistoryLoadingWidget(
                decoration: decoration, height: height),
          ),
        ),
      ],
    );
  }
}

class TripJoinRequestHistoryLoadingWidget extends StatelessWidget {
  const TripJoinRequestHistoryLoadingWidget({
    super.key,
    required this.decoration,
    required this.height,
  });

  final BoxDecoration decoration;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: CustomCard(
        children: [
          CustomGrayContainer(decoration: decoration, height: height * 2),
          CustomGrayContainerEqualSizes(
              decoration: decoration, height: height, numberOfBoxes: 3),
        ],
      ),
    );
  }
}

class CustomGrayContainer extends StatelessWidget {
  const CustomGrayContainer({
    super.key,
    required this.decoration,
    required this.height,
  });

  final BoxDecoration decoration;
  final double height;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5),
      child: Row(children: [
        Expanded(
            flex: 1, child: Container(height: height, decoration: decoration)),
        const Sizer(),
        Expanded(
            flex: 1,
            child: Container(height: height * 0.5, decoration: decoration)),
        Expanded(flex: 3, child: Container(height: height)),
      ]),
    );
  }
}

class CustomGrayContainerEqualSizes extends StatelessWidget {
  const CustomGrayContainerEqualSizes({
    super.key,
    required this.decoration,
    required this.height,
    required this.numberOfBoxes,
  });

  final BoxDecoration decoration;
  final double height;
  final int numberOfBoxes;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
      ),
      child: Row(children: [
        ...List.generate(
          numberOfBoxes,
          (index) => Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                height: height,
                decoration: decoration),
          ),
        ),
      ]),
    );
  }
}
