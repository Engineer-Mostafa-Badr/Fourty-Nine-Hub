import 'package:flutter/material.dart';

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
    return Material(
      color: context.isDarkMode ? Colors.black : Colors.white,
      elevation: overlapsContent ? 4.0 : 0.0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Search Icon
            GestureDetector(
              onTap: onSearchTap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.search,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                  size: 24,
                ),
              ),
            ),

            SizedBox(width: 8),

            // Tab Pills
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTabPill('Available', 0, tabController.index == 0),
                    SizedBox(width: 8),
                    _buildTabPill('Favorite', 1, tabController.index == 1),
                    SizedBox(width: 8),
                    _buildTabPill('History', 2, tabController.index == 2),
                    SizedBox(width: 8),
                    _buildTabPill('My Talent', 3, tabController.index == 3),
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
    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (context.isDarkMode ? Colors.white : Color(0xff0B1035))
              : Color(0xffE0E0E0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (context.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? (context.isDarkMode ? Colors.black : Colors.white)
                : (context.isDarkMode ? Colors.white : Colors.black),
            fontSize: 14,
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
