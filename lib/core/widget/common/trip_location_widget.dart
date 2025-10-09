import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class TripLocationWidget extends StatelessWidget {
  const TripLocationWidget({super.key, required this.isFrom,this.fontSize, required this.title});
  final bool isFrom;
  final String title;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          isFrom?Assets.rideFrom:Assets.rideTo,
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Label(
            maxLines: 2,
            text: title,
            style: Styles.headerText(fontSize: fontSize??24),
          ),
        ),
      ],
    );
  }
}
