import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../core/localization/locale_keys.g.dart';

class OneWayWidget extends StatefulWidget {
  final String? statusDriver;
  final bool? cancelButton;
  final String? requestType;
  const OneWayWidget({
    super.key,
    this.statusDriver,
    this.cancelButton,
    this.requestType,
  });

  @override
  _OneWayWidgetState createState() => _OneWayWidgetState();
}

class _OneWayWidgetState extends State<OneWayWidget> {
  bool _showContainer = false; // متغير للتحكم في ظهور الـ Container

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // محتوى الكونتينر الأساسي
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.normal.localize,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "50 ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: context.isArabic ? "جنيه مصري" : "EGP",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            LocaleKeys.booked.localize,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SvgPicture.asset(Assets.bookedMan),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            LocaleKeys.free.localize,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SvgPicture.asset(
                            Assets.freeIcon,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            LocaleKeys.free.localize,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SvgPicture.asset(
                            Assets.freeIcon,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            LocaleKeys.seat.localize,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          // const SizedBox(height: 4),
                          Padding(
                            padding: EdgeInsets.only(top: 15.h, left: 8.h),
                            child: Text(
                              widget.statusDriver ?? "",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: context.isDarkMode
                                    ? Colors.white
                                    : AppColors.PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.red, size: 12),
                      Expanded(
                        child: Divider(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      const Icon(Icons.circle, color: Colors.green, size: 12),
                      Expanded(
                        child: Divider(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      const Icon(Icons.circle, color: Colors.green, size: 12),
                      Expanded(
                        child: Divider(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          thickness: 2,
                        ),
                      ),
                      const Icon(Icons.circle, color: Colors.blue, size: 12),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(Assets.circleGreen),
                    const SizedBox(width: 4),
                    Text(
                      context.isArabic ? "الجيزة، مصر" : "Giza, Egypt",
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SvgPicture.asset(Assets.circleBlue),
                    const SizedBox(width: 4),
                    Text(
                      context.isArabic ? "الجيزة، مصر" : "Giza, Egypt",
                      style: TextStyle(
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      context.isArabic ? "منذ 10 دقائق" : '10 mins ago',
                      style: TextStyle(
                        fontSize: 14,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        widget.requestType ?? "",
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    widget.cancelButton == true
                        ? GestureDetector(
                            child: Container(
                              width: 120.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: AppColors.SECONDARY_COLOR_DARK,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  LocaleKeys.cancel.localize,
                                  style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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
        Positioned(
          bottom: 9,
          left: 270.h,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _showContainer = !_showContainer;
              });
            },
            child: SvgPicture.asset(
              Assets.frameIcon,
              width: 50,
            ),
          ),
        ),
        if (_showContainer)
          const Positioned(
            top: 0,
            bottom: 80, // تحديد المكان اللي هيظهر فيه الـ Container
            left: 0,
            right: 0,
            child: AddressWidget(),
          ),
      ],
    );
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffE8E8E8),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextAddressWidget(
                    icon: Assets.circleGreen,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                  SizedBox(height: 12.h),
                  TextAddressWidget(
                    icon: Assets.circleBlack,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                  SizedBox(height: 12.h),
                  TextAddressWidget(
                    icon: Assets.circleBlack,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                  SizedBox(height: 12.h),
                  TextAddressWidget(
                    icon: Assets.circleBlue,
                    address: context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -1,
              right: 5,
              left: 2,
              child: SvgPicture.asset(
                Assets.redFrame,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextAddressWidget extends StatelessWidget {
  final String? address;
  final String? icon;
  const TextAddressWidget({
    super.key,
    this.address,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon ?? ""),
        SizedBox(width: 9.w),
        Text(
          context.isArabic ? address ?? "" : address ?? "",
          style: TextStyle(
            fontSize: 22.sp,
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
