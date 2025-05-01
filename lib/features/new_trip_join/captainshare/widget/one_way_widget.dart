import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../core/localization/locale_keys.g.dart';

import 'package:expandable/expandable.dart';

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
  late ExpandableController _expandableController;

  @override
  void initState() {
    super.initState();
    _expandableController = ExpandableController(initialExpanded: false);
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocaleKeys.normal.localize,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.red,
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
                            text: context.isArabic ? "  ج.م" : "EGP",
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
                Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _expandableController.toggle();
                      });
                    },
                    child: SvgPicture.asset(
                      Assets.redFrame,
                      width: 50,
                    ),
                  ),
                ),
                ExpandablePanel(
                  controller: _expandableController,
                  theme: const ExpandableThemeData(
                    hasIcon: false,
                    tapBodyToCollapse: false,
                    tapHeaderToExpand: false,
                  ),
                  header: const SizedBox(),
                  collapsed: const SizedBox(),
                  expanded: const AddressWidget(),
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
        color: context.isDarkMode ? AppColors.PRIMARY_COLOR : Color(0xffE8E8E8),
        borderRadius: BorderRadius.circular(20),
      ),
      // margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
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
      ),
    );
  }
}

class TextAddressWidget extends StatelessWidget {
  final String? address;
  final String? icon;
  final Color? color;
  const TextAddressWidget({
    super.key,
    this.address,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          icon ?? "",
          // ignore: deprecated_member_use
          color: color,
        ),
        SizedBox(width: 9.w),
        Text(
          context.isArabic ? address ?? "" : address ?? "",
          style: TextStyle(
            fontSize: 22.sp,
            color: context.isDarkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
