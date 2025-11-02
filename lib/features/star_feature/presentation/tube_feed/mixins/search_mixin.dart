import 'dart:async';
import 'package:flutter/material.dart';

import '../../presentation_exports.dart';

/// Mixin for handling search functionality in tube feed
mixin SearchMixin<T extends StatefulWidget> on State<T> {
  late TextEditingController searchController;
  Timer? _searchDebounce;

  bool _isSearching = false;
  bool _isSearchingProfiles = false;

  bool get isSearching => _isSearching;
  bool get isSearchingProfiles => _isSearchingProfiles;

  /// Initialize search controller
  void initializeSearchController() {
    searchController = TextEditingController();
    searchController.addListener(_onSearchChanged);
  }

  /// Handle search text changes with debounce
  void _onSearchChanged() {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(TubeConstants.searchDebounceDuration, () {
      if (mounted) {
        final query = searchController.text.trim();
        if (query.isNotEmpty && query.length >= 2) {
          onSearchQueryChanged(query);
        } else {
          onSearchQueryChanged('');
        }
      }
    });
  }

  /// Override this method to handle search query changes
  void onSearchQueryChanged(String query);

  /// Search for talents
  void onTalentSearch(StarCubit cubit, String query) {
    setState(() {
      _isSearchingProfiles = false;
    });
    cubit.searchTalents(query);
    cubit.clearProfileSearch();
  }

  /// Search for profiles
  void onProfileSearch(StarCubit cubit, String query) {
    setState(() {
      _isSearchingProfiles = true;
    });
    cubit.searchProfiles(query);
  }

  /// Toggle search mode
  void toggleSearch(StarCubit cubit) {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _isSearchingProfiles = false;
        searchController.clear();
        cubit.searchTalents('');
        cubit.clearProfileSearch();
      }
    });
  }

  /// Dispose search controller and cancel debounce
  void disposeSearchController() {
    _searchDebounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
  }
}
