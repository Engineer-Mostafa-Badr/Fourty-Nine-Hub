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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.getRedColor(context),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: "50 ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.getTextColor(context),
                        ),
                        children: [
                          TextSpan(
                            text: context.isArabic ? "ج.م" : "EGP",
                            style: TextStyle(
                              color: AppColors.getRedColor(context),
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
                            color: AppColors.getTextColor(context),
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
                            color: AppColors.getTextColor(context),
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
                      Icon(Icons.circle,
                          color: AppColors.getRedColor(context), size: 12),
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
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 10,
                        child: CircleAvatar(
                            backgroundColor: AppColors.getFillColor(context),
                            radius: 5),
                      ),
                    ),
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
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.transparent,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 10,
                        child: CircleAvatar(
                            backgroundColor: AppColors.getFillColor(context),
                            radius: 5),
                      ),
                    ),
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
                _showContainer = !_showContainer; // تغيير حالة الـ Container
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
            bottom: 80,
            // تحديد المكان اللي هيظهر فيه الـ Container
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
        color: context.isDarkMode
            ? const Color(0xFF333333)
            : AppColors.BG_GRAY_COLOR,
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
                  Flexible(
                    child: TextAddressWidget(
                      color: Colors.green,
                      address:
                          context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: TextAddressWidget(
                      color: Colors.black,
                      address:
                          context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: TextAddressWidget(
                      color: Colors.black,
                      address:
                          context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Flexible(
                    child: TextAddressWidget(
                      color: Colors.blue,
                      address:
                          context.isArabic ? "الجيزة، مصر" : "Giza , Egypt",
                    ),
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
  final Color? color;

  const TextAddressWidget({
    super.key,
    this.address,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.transparent,
          child: CircleAvatar(
            backgroundColor: color,
            radius: 7,
            child: CircleAvatar(
                backgroundColor: context.isDarkMode
                    ? const Color(0xFF333333)
                    : AppColors.BG_GRAY_COLOR,
                radius: 3),
          ),
        ),
        SizedBox(width: 9.w),
        Text(
          context.isArabic ? address ?? "" : address ?? "",
          style: TextStyle(
            fontSize: 28.sp,
            color: AppColors.getTextColor(context),
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
