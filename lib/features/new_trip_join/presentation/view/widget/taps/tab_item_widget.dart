import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabItemWidget extends StatelessWidget {
  final String text;
  final String icon;
  final int index;
  final TabController tabController;

  const TabItemWidget({
    super.key,
    required this.text,
    required this.icon,
    required this.index,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = tabController.index == index;
    return GestureDetector(
      onTap: () => tabController.animateTo(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            //   padding: EdgeInsets.symmetric(horizontal: 30.w),
            width: 150.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: isSelected ? Color(0XFFF88B92) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : const Color(0xff727272)),
            ),
          ),
          Positioned(top: -8, right: -8, child: SvgPicture.asset(icon)),
        ],
      ),
    );
  }
}
