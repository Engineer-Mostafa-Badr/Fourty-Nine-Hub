import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
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
                          text: context.isArabic ? "سيدة/ " : "Lady/ ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                            color: AppColors.getRedColor(context),
                          ),
                          children: [
                            TextSpan(
                              text: context.isArabic ? "ليدي درايف" : "Lady Driver",
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
                              text: context.isArabic ? "ج.م" : "EGP",
                              style: TextStyle(
                                  color: AppColors.getRedColor(context), fontSize: 14),
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
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          radius: 10,
                          child: CircleAvatar(
                              backgroundColor: AppColors.getFillColor(context), radius: 5),
                        ),
                      ),
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
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.transparent,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 10,
                          child: CircleAvatar(
                              backgroundColor: AppColors.getFillColor(context), radius: 5),
                        ),
                      ),
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
                  const SizedBox(height: 8),
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
                      ClickableWidget(
                        onTap: () {},
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
                      widget.cancelButton == true? const SizedBox(width: 5):const SizedBox(),
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
                  const Sizer(),
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
