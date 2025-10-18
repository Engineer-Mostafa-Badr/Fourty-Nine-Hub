import 'package:flutter/material.dart';

import '../constants/tube_constants.dart';

/// Mixin for synchronizing scroll between main and tab scroll controllers
mixin ScrollSyncMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  // Main scroll controller for the outer CustomScrollView
  late ScrollController mainScrollController;

  // Individual controllers for each tab content
  late ScrollController availableController;
  late ScrollController favoriteController;
  late ScrollController historyController;
  late ScrollController myTalentController;

  bool _isSyncing = false;
  int _selectedTabIndex = 0;

  /// Initialize all scroll controllers
  void initializeScrollControllers() {
    mainScrollController = ScrollController();
    availableController = ScrollController();
    favoriteController = ScrollController();
    historyController = ScrollController();
    myTalentController = ScrollController();
  }

  /// Setup scroll synchronization listeners
  void setupScrollSynchronization() {
    // Sync main controller with active tab controller
    mainScrollController.addListener(_syncFromMain);

    // Sync tab controllers with main controller
    availableController.addListener(() => _syncToMain(availableController));
    favoriteController.addListener(() => _syncToMain(favoriteController));
    historyController.addListener(() => _syncToMain(historyController));
    myTalentController.addListener(() => _syncToMain(myTalentController));
  }

  /// Update the selected tab index
  void updateSelectedTabIndex(int index) {
    _selectedTabIndex = index;
  }

  /// Get the active tab controller based on selected index
  ScrollController? getActiveTabController() {
    try {
      switch (_selectedTabIndex) {
        case 0:
          return availableController.hasClients ? availableController : null;
        case 1:
          return favoriteController.hasClients ? favoriteController : null;
        case 2:
          return historyController.hasClients ? historyController : null;
        case 3:
          return myTalentController.hasClients ? myTalentController : null;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error getting active tab controller: $e');
      return null;
    }
  }

  /// Sync from main controller to active tab controller
  void _syncFromMain() {
    if (_isSyncing || !mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isSyncing) return;

      _isSyncing = true;
      try {
        final activeController = getActiveTabController();
        if (activeController != null &&
            activeController.hasClients &&
            mainScrollController.hasClients) {
          final targetOffset = mainScrollController.offset.clamp(
            activeController.position.minScrollExtent,
            activeController.position.maxScrollExtent,
          );

          if ((activeController.offset - targetOffset).abs() >
              TubeConstants.scrollSyncThreshold) {
            activeController.jumpTo(targetOffset);
          }
        }
      } finally {
        _isSyncing = false;
      }
    });
  }

  /// Sync from tab controller to main controller
  void _syncToMain(ScrollController tabController) {
    if (_isSyncing || !mounted) return;
    if (tabController != getActiveTabController()) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isSyncing) return;

      _isSyncing = true;
      try {
        if (mainScrollController.hasClients && tabController.hasClients) {
          final targetOffset = tabController.offset.clamp(
            mainScrollController.position.minScrollExtent,
            mainScrollController.position.maxScrollExtent,
          );

          if ((mainScrollController.offset - targetOffset).abs() >
              TubeConstants.scrollSyncThreshold) {
            mainScrollController.jumpTo(targetOffset);
          }
        }
      } finally {
        _isSyncing = false;
      }
    });
  }

  /// Dispose all scroll controllers and remove listeners
  void disposeScrollControllers() {
    try {
      // Remove main listener
      mainScrollController.removeListener(_syncFromMain);

      // Note: Lambda listeners can't be removed directly without storing references
      // The controllers will be disposed anyway, so listeners will be cleared
    } catch (e) {
      debugPrint('⚠️ Error during controller disposal: $e');
    }

    // Dispose controllers
    mainScrollController.dispose();
    availableController.dispose();
    favoriteController.dispose();
    historyController.dispose();
    myTalentController.dispose();
  }
}
