import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/rotating_car.dart';

class LoadingTripWidget extends StatelessWidget {
  const LoadingTripWidget({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const RotatingCar(),
        const SizedBox(height: 44,),
        Label(text: title ?? "Bukle up - your first \n orders are just around\n the corner!",maxLines: 3,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14
        ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
