import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController tabController;
  final bool isCurrentUser;

  const ProfileTabBar({
    super.key,
    required this.tabController,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      Tab(
        height: 48.0, // إضافة height للتاب
        text: context.isArabic ? 'الرئيسية' : 'Home',
      ),
      Tab(
        height: 48.0,
        text: context.isArabic ? 'الفيديوهات' : 'Videos',
      ),
      Tab(
        height: 48.0,
        text: context.isArabic ? 'قوائم التشغيل' : 'Playlists',
      ),
      if (isCurrentUser)
        Tab(
          height: 48.0,
          text: context.isArabic ? 'الشاهد لاحقاً' : 'Watch Later',
        ),
    ];

    print(
        '📊 ProfileTabBar: Creating ${tabs.length} tabs for isCurrentUser: $isCurrentUser');
    print('📊 TabController length: ${tabController.length}');

    return Container(
      height: 56.0, // إضافة height صريح
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.black,
        indicatorWeight: 3,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: _getResponsiveFontSize(context, 16), // تقليل من 18 إلى 16
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: _getResponsiveFontSize(context, 16), // تقليل من 18 إلى 16
          fontWeight: FontWeight.normal,
        ),
        tabs: tabs,
      ),
    );
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }
}
