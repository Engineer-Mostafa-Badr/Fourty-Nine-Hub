import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../core/extensions/context_extension.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final BuildContext context;
  final VoidCallback onSearchTap;
  late final ScrollController _scrollController;

  StickyTabBarDelegate({
    required this.tabController,
    required this.context,
    required this.onSearchTap,
  }) {
    _scrollController = ScrollController();

    // Add listener for tab changes
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        _scrollToSelectedTab(tabController.index);
      }
    });
  }

  void _scrollToSelectedTab(int index) {
    // Calculate the position of each tab pill
    // Assuming each tab has approximate width including padding and spacing
    double tabWidth = 120.w; // Approximate width of each tab pill
    double spacing =
        MediaQuery.sizeOf(context).width * 0.02; // Spacing between tabs

    // Calculate target scroll position
    double targetScrollPosition = index * (tabWidth + spacing);

    // Animate to the calculated position
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        targetScrollPosition,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

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

            // Tab Pills with ScrollController
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController, // Add the scroll controller
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
        // Animate scroll when tab is tapped
        _scrollToSelectedTab(index);
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

  // Add dispose method to clean up the scroll controller
  void dispose() {
    _scrollController.dispose();
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
