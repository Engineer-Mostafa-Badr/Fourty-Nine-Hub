import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../core/extensions/context_extension.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final BuildContext context;
  final VoidCallback onSearchTap;

  StickyTabBarDelegate({
    required this.tabController,
    required this.context,
    required this.onSearchTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var size = MediaQuery.sizeOf(context);
    return Material(
      color: context.isDarkMode ? Colors.black : Colors.white,
      elevation: overlapsContent ? 4.0 : 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04, vertical: size.height * 0.01),
        child: Row(
          textDirection: context.textDirection,
          children: [
            // Search Icon
            GestureDetector(
              onTap: onSearchTap,
              child: Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(size.width * 0.05),
                ),
                child: Icon(
                  Icons.search,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  size: size.width * 0.06,
                ),
              ),
            ),

            SizedBox(width: size.width * 0.02),

            // Tab Pills
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  textDirection: context.textDirection,
                  children: [
                    _buildTabPill(context.isArabic ? 'متاح' : 'Available', 0,
                        tabController.index == 0),
                    SizedBox(width: size.width * 0.02),
                    _buildTabPill(context.isArabic ? 'مفضلة' : 'Favorite', 1,
                        tabController.index == 1),
                    SizedBox(width: size.width * 0.02),
                    _buildTabPill(context.isArabic ? 'سجل' : 'History', 2,
                        tabController.index == 2),
                    SizedBox(width: size.width * 0.02),
                    _buildTabPill(context.isArabic ? 'موهبتي' : 'My Talent', 3,
                        tabController.index == 3),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabPill(String text, int index, bool isSelected) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.056, vertical: size.height * 0.01),
        decoration: BoxDecoration(
          color: isSelected
              ? (context.isDarkMode ? Colors.white : Color(0xff0B1035))
              : Color(0xffE0E0E0),
          borderRadius: BorderRadius.circular(size.width * 0.025),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (context.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
        ),
        child: Label(
          text: text,
          style: TextStyle(
            color: isSelected
                ? (context.isDarkMode ? Colors.black : Colors.white)
                : (context.isDarkMode ? Colors.white : Colors.black),
            fontSize: context.isArabic ? size.width * 0.03 : size.width * 0.025,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 56.0;

  @override
  double get minExtent => 56.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Changed to true to rebuild when tab changes
  }
}
