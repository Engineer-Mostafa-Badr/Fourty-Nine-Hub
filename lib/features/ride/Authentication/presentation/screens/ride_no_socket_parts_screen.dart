import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RideNoSocketPartsScreen extends StatelessWidget {
  const RideNoSocketPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: context.isDarkMode
            ? AppColors.UNSELECTED_DARK_GRAY_COLOR
            : Colors.white,
        boxShadow: context.isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 30,
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.PRIMARY_COLOR,
              ),
              Text(
                "Basic Info",
                style: Styles.mediumText(fontSize: 35),
              ),
            ],
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.PRIMARY_COLOR,
              ),
              Text(
                "Driver Licence",
                style: Styles.mediumText(fontSize: 35),
              ),
            ],
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.PRIMARY_COLOR,
              ),
              Text(
                "Car Licence",
                style: Styles.mediumText(fontSize: 35),
              ),
            ],
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.PRIMARY_COLOR,
              ),
              Text(
                "Vehicle info",
                style: Styles.mediumText(fontSize: 35),
              ),
            ],
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.PRIMARY_COLOR,
              ),
              Text(
                "Referral code",
                style: Styles.mediumText(fontSize: 35),
              ),
            ],
          ),
          const Sizer(
            height: 10,
          ),
          const Divider(),
          const Sizer(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.PRIMARY_COLOR,
              ),
              Text(
                "More info",
                style: Styles.mediumText(fontSize: 35),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
