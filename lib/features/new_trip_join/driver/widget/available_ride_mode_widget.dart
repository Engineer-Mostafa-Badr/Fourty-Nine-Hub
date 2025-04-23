import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../res/style/app_colors.dart';
import '../../captainshare/widget/one_way_widget.dart';

class AvailableRideModeWidget extends StatefulWidget {
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
  State<AvailableRideModeWidget> createState() =>
      _AvailableRideModeWidgetState();
}

class _AvailableRideModeWidgetState extends State<AvailableRideModeWidget> {
  bool _showContainer = false; // متغير للتحكم في ظهور الـ Container

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: context.isArabic ? "سيدة/" : "Lady/ ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                            color: Colors.red,
                          ),
                          children: [
                            TextSpan(
                              text: context.isArabic ? "ليدي درايف" : "سائقة ",
                              style: TextStyle(
                                color: context.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 25.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "50 ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.sp,
                            color: context.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: context.isArabic ? "جنيهًا مصريًا" : "EGP",
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
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
                            LocaleKeys.booked.localize,
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
                            LocaleKeys.seat.localize,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : AppColors.PRIMARY_COLOR,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              widget.statusDriver ?? "",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
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
                        const Icon(Icons.circle, color: Colors.red, size: 12),
                        Expanded(
                          child: Divider(
                            color: context.isDarkMode
                                ? Colors.white
                                : AppColors.PRIMARY_COLOR,
                            thickness: 2,
                          ),
                        ),
                        const Icon(Icons.circle, color: Colors.red, size: 12),
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
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      SvgPicture.asset(Assets.circleBlue),
                      const SizedBox(width: 4),
                      Text(
                        context.isArabic ? "الجيزة، مصر" : "Giza, Egypt",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  //      const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        context.isArabic ? 'منذ ساعة واحدة' : '1 hour ago',
                        style: TextStyle(
                          fontSize: 28.sp,
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
                          ? ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  AppColors.SECONDARY_COLOR,
                                ),
                              ),
                              onPressed: () {},
                              child: Text(
                                LocaleKeys.cancel.localize,
                                style: const TextStyle(
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
          bottom: 9,
          left: 170,
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
        // الـ Container اللي هيظهر أو يختفي حسب الضغط
        if (_showContainer)
          const Positioned(
            top: 0,
            bottom: 75, // تحديد المكان اللي هيظهر فيه الـ Container
            left: 0,
            right: 0,
            child: AddressWidget(),
          ),
      ],
    );
  }
}
