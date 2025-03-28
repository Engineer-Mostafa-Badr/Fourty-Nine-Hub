import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../res/style/app_colors.dart';

class AvailableRideModeWidget extends StatelessWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final String? requestType;
  final void Function()? onTap;
  const AvailableRideModeWidget({
    super.key,
    this.statusDriver,
    this.cancelButton,
    this.requestType,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Lady/ Lady Driver   ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      RichText(
                        text: const TextSpan(
                          text: "50 ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "EGP",
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            context.isArabic ? "محجوز" : "Booked",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SvgPicture.asset(Assets.bookedWoman),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            context.isArabic ? "محجوز" : "Booked",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SvgPicture.asset(Assets.bookedWoman),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            context.isArabic ? "محجوز" : "Booked",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          SvgPicture.asset(Assets.bookedWoman),
                        ],
                      ),
                      Column(
                        children: [
                          Text(context.isArabic ? "مقعد" : "Seat",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.PRIMARY_COLOR)),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              statusDriver ?? "",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 12),
                      Expanded(
                        child: Divider(
                          color: AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      Icon(Icons.circle, color: Colors.red, size: 12),
                      Expanded(
                        child: Divider(
                          color: AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      Icon(Icons.circle, color: Colors.red, size: 12),
                      Expanded(
                        child: Divider(
                          color: AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      Icon(Icons.circle, color: Colors.blue, size: 12),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SvgPicture.asset(Assets.circleGreen),
                      const SizedBox(width: 4),
                      const Text(
                        "Giza, Egypt",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(Assets.circleBlue),
                      const SizedBox(width: 4),
                      const Text(
                        "Giza, Egypt",
                        style: TextStyle(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  //      const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        '10 mins ago',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          requestType ?? "",
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      cancelButton == true
                          ? ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      AppColors.SECONDARY_COLOR)),
                              onPressed: () {},
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          left: 160,
          child: SvgPicture.asset(
            Assets.frameIcon,
            width: 50,
          ),
        ),
      ],
    );
  }
}
