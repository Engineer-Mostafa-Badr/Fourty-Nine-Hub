import 'package:flutter/material.dart';

import '../../../domain/entity/star_entity.dart';
import '../../presentation_exports.dart';

/// Mixin for managing tab functionality in tube feed
mixin TabManagementMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late TabController tabController;
  int _selectedTabIndex = 0;

  // Video details view state for My Talent tab
  StarEntity? selectedVideoTalent;
  String? selectedVideoUrl;
  bool showVideoDetails = false;

  int get selectedTabIndex => _selectedTabIndex;

  /// Initialize tab controller
  void initializeTabController({required int tabCount}) {
    tabController = TabController(length: tabCount, vsync: this);
    tabController.addListener(_onTabChanged);
  }

  /// Handle tab change
  void _onTabChanged() {
    print("📱 Tab changed to index: ${tabController.index}");

    setState(() {
      _selectedTabIndex = tabController.index;

      // Reset video details view when switching tabs
      if (_selectedTabIndex != 3) {
        showVideoDetails = false;
        selectedVideoTalent = null;
        selectedVideoUrl = null;
      }
    });

    // Notify subclass of tab change
    onTabChangedCallback();
  }

  /// Override this method to handle additional tab change logic
  void onTabChangedCallback();

  /// Get category for the selected tab
  TalentCategory? getTabCategory(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return TalentCategory.available;
      case 1:
        return TalentCategory.favorites;
      case 2:
        return TalentCategory.history;
      case 3:
        return TalentCategory.myTalents;
      default:
        return null;
    }
  }

  /// Handle video selection in My Talent tab
  void onVideoSelected(StarEntity talent, String mediaUrl) {
    setState(() {
      selectedVideoTalent = talent;
      selectedVideoUrl = mediaUrl;
      showVideoDetails = true;
    });
  }

  /// Handle back from video details
  void onBackFromVideoDetails() {
    setState(() {
      showVideoDetails = false;
      selectedVideoTalent = null;
      selectedVideoUrl = null;
    });
  }

  /// Dispose tab controller
  void disposeTabController() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
  }
}
