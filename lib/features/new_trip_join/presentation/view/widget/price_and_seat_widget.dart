import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';


class PriceAndSeatWidget extends StatefulWidget {
  const PriceAndSeatWidget({
    super.key,
    this.price
  });
  final num? price;

  @override
  State<PriceAndSeatWidget> createState() => _PriceAndSeatWidgetState();
}

class _PriceAndSeatWidgetState extends State<PriceAndSeatWidget> {

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
            text: widget.price!=null? "${widget.price?.toInt()} ":" ",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.isDarkMode?Colors.white:Colors.black,
            ),
            children: [
              TextSpan(
                text: context.isArabic ? "جنيه مصري" : "EGP",
                style: TextStyle(
                  color:AppColors.getRedColor(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
