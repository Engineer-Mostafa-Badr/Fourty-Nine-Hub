import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/extensions/context_extension.dart';

class StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final BuildContext context;
  final VoidCallback onSearchTap;
  final bool showSearchField; // إضافة جديدة
  final TextEditingController? searchController; // إضافة جديدة
  final Function(String)? onSearchChanged; // إضافة جديدة
  late final ScrollController _scrollController;

  StickyTabBarDelegate({
    required this.tabController,
    required this.context,
    required this.onSearchTap,
    this.showSearchField = false, // إضافة جديدة
    this.searchController, // إضافة جديدة
    this.onSearchChanged, // إضافة جديدة
  }) {
    _scrollController = ScrollController();
  }

  void _scrollToSelectedTab(int index) {
    if (!_scrollController.hasClients) return;

    double tabWidth = 120.w;
    double spacing = MediaQuery.sizeOf(context).width * 0.02;
    double targetScrollPosition = index * (tabWidth + spacing);

    _scrollController.animateTo(
      targetScrollPosition,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var size = MediaQuery.sizeOf(context);

    return AnimatedBuilder(
      animation: tabController,
      builder: (context, child) {
        return Material(
          color: context.isDarkMode ? Colors.black : Colors.white,
          elevation: overlapsContent ? 4.0 : 0.0,
          surfaceTintColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: maxExtent,
            padding: EdgeInsets.only(
              left: size.width * 0.04,
              right: size.width * 0.04,
              top: 0,
              bottom: size.height * 0.01,
            ),
            child: Column(
              children: [
                // Tab Bar Row
                Row(
                  textDirection: context.textDirection,
                  children: [
                    // Search Icon
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        onSearchTap.call();
                      },
                      child: Container(
                        width: size.width * 0.1,
                        height: size.width * 0.1,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius:
                              BorderRadius.circular(size.width * 0.05),
                        ),
                        child: Icon(
                          showSearchField ? Icons.close : Icons.search,
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                          size: size.width * 0.06,
                        ),
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),

                    // Tab Pills
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          textDirection: context.textDirection,
                          children: [
                            _buildTabPill(
                                context.isArabic ? 'متاح' : 'Available',
                                0,
                                tabController.index == 0),
                            SizedBox(width: size.width * 0.02),
                            _buildTabPill(
                                context.isArabic ? 'مفضلة' : 'Favorite',
                                1,
                                tabController.index == 1),
                            SizedBox(width: size.width * 0.02),
                            _buildTabPill(context.isArabic ? 'سجل' : 'History',
                                2, tabController.index == 2),
                            SizedBox(width: size.width * 0.02),
                            _buildTabPill(
                                context.isArabic ? 'موهبتي' : 'My Talent',
                                3,
                                tabController.index == 3),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Search Field (يظهر لما showSearchField = true)
                if (showSearchField) ...[
                  SizedBox(height: size.height * 0.01),
                  _buildSearchField(size),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabPill(String text, int index, bool isSelected) {
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        ManageVibration.vibrate();
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
            fontSize:
                context.isArabic ? size.width * 0.03 : size.width * 0.025,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(Size size) {
    return Container(
      height: size.height * 0.05,
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[800] : Colors.grey[100],
        borderRadius: BorderRadius.circular(size.width * 0.025),
        border: Border.all(
          color: context.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        style: TextStyle(
          color: context.isDarkMode ? Colors.white : Colors.black,
          fontSize: size.width * 0.035,
        ),
        decoration: InputDecoration(
          hintText:
              context.isArabic ? 'ابحث عن الفيديوهات...' : 'Search videos...',
          hintStyle: TextStyle(
            color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontSize: size.width * 0.035,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: context.isDarkMode ? Colors.grey[400] : Colors.grey[600],
            size: size.width * 0.05,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
            vertical: size.height * 0.01,
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
  double get maxExtent =>
      showSearchField ? 120.0 : 70.0; // زيادة الارتفاع لما search field موجود

  @override
  double get minExtent => showSearchField ? 120.0 : 70.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
