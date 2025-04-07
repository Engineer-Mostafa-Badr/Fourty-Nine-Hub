import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class PriceAndSeatWidget extends StatelessWidget {
  const PriceAndSeatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.isArabic ? "السعر/المقعد" : "Price/Seat",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 20),
        RichText(
          text: TextSpan(
            text: "60 ",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: context.isArabic ? "جنيه مصري" : "EGP",
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
