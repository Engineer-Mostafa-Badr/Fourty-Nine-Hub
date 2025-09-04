import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entity/star_entity.dart';

import '../controller/star_cubit/star_cubit.dart';
import '../utils/enums.dart';
import '../widgets/be_star_floating_button.dart';
import '../widgets/be_star_header_section.dart';
import '../widgets/be_star_search_bar.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/profile_search_results.dart';
import '../widgets/sticky_tab_bar_delegate.dart';
import '../widgets/talent_card/talent_card.dart';
import '../widgets/talent_card/talent_card_builders.dart';
import 'video_details_view.dart';

class BeStarView extends StatefulWidget {
  const BeStarView({super.key});

  @override
  _BeStarViewState createState() => _BeStarViewState();
}

class _BeStarViewState extends State<BeStarView> with TickerProviderStateMixin {
  late StarCubit _cubit;
  late TabController _tabController;
  bool _showFloatingButton = true;
  int _selectedTabIndex = 0;
  bool _isSearching = false;
  bool _isSearchingProfiles = false;
  final TextEditingController _searchController = TextEditingController();

  // Video details view state for My Talent tab
  StarEntity? _selectedVideoTalent;
  String? _selectedVideoUrl;
  bool _showVideoDetails = false;

  // Main scroll controller for the outer CustomScrollView
  final ScrollController _mainScrollController = ScrollController();

  // Individual controllers for each tab content
  final ScrollController _availableController = ScrollController();
  final ScrollController _favoriteController = ScrollController();
  final ScrollController _historyController = ScrollController();
  final ScrollController _myTalentController = ScrollController();

  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);

    // Initialize all data
    _cubit.initializeAllData();

    // Setup scroll synchronization
    _setupScrollSynchronization();

    // Add debugging
    _debugInitialization();
  }

  void _debugInitialization() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🎯 BeStarView initialized");
      context.read<StarCubit>().debugMyTalentsFlow();
    });
  }

  void _setupScrollSynchronization() {
    // Sync main controller with active tab controller
    _mainScrollController.addListener(() => _syncFromMain());

    // Sync tab controllers with main controller
    _availableController.addListener(() => _syncToMain(_availableController));
    _favoriteController.addListener(() => _syncToMain(_favoriteController));
    _historyController.addListener(() => _syncToMain(_historyController));
    _myTalentController.addListener(() => _syncToMain(_myTalentController));
  }

  void _syncFromMain() {
    if (_isSyncing || !mounted) return;
    _isSyncing = true;

    final activeController = _getActiveTabController();
    if (activeController != null &&
        activeController.hasClients &&
        _mainScrollController.hasClients &&
        mounted) {
      activeController.jumpTo(_mainScrollController.offset.clamp(
        activeController.position.minScrollExtent,
        activeController.position.maxScrollExtent,
      ));
    }
    _isSyncing = false;
  }

  void _syncToMain(ScrollController tabController) {
    if (_isSyncing || !mounted) return;
    if (tabController != _getActiveTabController()) return;
    _isSyncing = true;

    if (_mainScrollController.hasClients &&
        tabController.hasClients &&
        mounted) {
      _mainScrollController.jumpTo(tabController.offset.clamp(
        _mainScrollController.position.minScrollExtent,
        _mainScrollController.position.maxScrollExtent,
      ));
    }
    _isSyncing = false;
  }

  ScrollController? _getActiveTabController() {
    try {
      switch (_selectedTabIndex) {
        case 0:
          return _availableController.hasClients ? _availableController : null;
        case 1:
          return _favoriteController.hasClients ? _favoriteController : null;
        case 2:
          return _historyController.hasClients ? _historyController : null;
        case 3:
          return _myTalentController.hasClients ? _myTalentController : null;
        default:
          return null;
      }
    } catch (e) {
      debugPrint('Error getting active tab controller: $e');
      return null;
    }
  }

  // Add refresh method for each category
  // Future<void> _onRefresh() async {
  //   final category = _getTabCategory(_selectedTabIndex);
  //   if (category != null) {
  //     print("🔄 Refreshing category: $category");

  //     // Show loading state
  //     setState(() {});

  //     // Call appropriate refresh method based on category
  //     switch (category) {
  //       case TalentCategory.available:
  //         await _cubit.loadTalents(TalentCategory.available, refresh: true);
  //         break;
  //       case TalentCategory.favorites:
  //         await _cubit.loadTalents(TalentCategory.favorites, refresh: true);
  //         break;
  //       case TalentCategory.history:
  //         await _cubit.loadTalents(TalentCategory.history, refresh: true);
  //         break;
  //       case TalentCategory.myTalents:
  //         // await _cubit.forceRefreshMyTalents();
  //         await _cubit.loadTalents(TalentCategory.myTalents, refresh: true);
  //         break;
  //     }

  //     // Small delay for better UX
  //     await Future.delayed(Duration(milliseconds: 500));
  //   }
  // }

  // Future<void> _onRefresh() async {
  //   final category = _getTabCategory(_selectedTabIndex);
  //   if (category != null) {
  //     await _cubit.loadTalents(category, refresh: true);
  //   }
  // }

  // void _onTabChanged() {
  //   setState(() {
  //     _selectedTabIndex = _tabController.index;

  //     // Reset video details view when switching tabs
  //     if (_selectedTabIndex != 3) {
  //       _showVideoDetails = false;
  //       _selectedVideoTalent = null;
  //       _selectedVideoUrl = null;
  //     }

  //     // Clear search when switching tabs
  //     _isSearching = false;
  //     _isSearchingProfiles = false;
  //     _searchController.clear();
  //     _cubit.searchTalents('');
  //     _cubit.clearProfileSearch();
  //   });

  //   // Load data for the selected tab if needed
  //   final category = _getTabCategory(_selectedTabIndex);
  //   if (category != null) {
  //     _cubit.loadTalents(category);
  //   }
  // }

  void _onTabChanged() {
    print("📱 Tab changed to index: ${_tabController.index}");

    setState(() {
      _selectedTabIndex = _tabController.index;

      // Reset video details view when switching tabs
      if (_selectedTabIndex != 3) {
        _showVideoDetails = false;
        _selectedVideoTalent = null;
        _selectedVideoUrl = null;
      }

      // Clear search when switching tabs
      _isSearching = false;
      _isSearchingProfiles = false;
      _searchController.clear();
      _cubit.searchTalents('');
      _cubit.clearProfileSearch();
    });

    // Load data for the selected tab if needed
    final category = _getTabCategory(_selectedTabIndex);
    if (category != null) {
      print("📊 Loading data for category: $category");
      _cubit.loadTalents(category);
    }
  }

  TalentCategory? _getTabCategory(int tabIndex) {
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

  void _onSearchChanged() {
    if (!_isSearchingProfiles) {
      _cubit.searchTalents(_searchController.text);
    }
  }

  void _onTalentSearch(String query) {
    setState(() {
      _isSearchingProfiles = false;
    });
    _cubit.searchTalents(query);
    _cubit.clearProfileSearch();
  }

  void _onProfileSearch(String query) {
    setState(() {
      _isSearchingProfiles = true;
    });
    _cubit.searchProfiles(query);
  }

  void _onVideoSelected(StarEntity talent, String mediaUrl) {
    setState(() {
      _selectedVideoTalent = talent;
      _selectedVideoUrl = mediaUrl;
      _showVideoDetails = true;
    });
  }

  void _onBackFromVideoDetails() {
    setState(() {
      _showVideoDetails = false;
      _selectedVideoTalent = null;
      _selectedVideoUrl = null;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _isSearchingProfiles = false;
        _searchController.clear();
        _cubit.searchTalents('');
        _cubit.clearProfileSearch();
      }
    });
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is UserScrollNotification) {
      if (scrollInfo.direction == ScrollDirection.reverse) {
        if (_showFloatingButton) {
          setState(() {
            _showFloatingButton = false;
          });
        }
      } else if (scrollInfo.direction == ScrollDirection.forward) {
        if (!_showFloatingButton) {
          setState(() {
            _showFloatingButton = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BeStarFloatingButton(
        isLoggedIn: context.watch<UserCubit>().isLoggedIn,
        showButton: _showFloatingButton,
      ),
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          if (state.status == StarStates.loading &&
              state.availableTalents.isEmpty) {
            return const StarLoadingIndicator(message: 'Loading content...');
          }

          return RefreshIndicator(
            onRefresh: () async {
              if (_isSearching) {
                if (_isSearchingProfiles) {
                  _cubit.searchProfiles(_searchController.text);
                } else {
                  _cubit.searchTalents(_searchController.text);
                }
              } else {
                final category = _getTabCategory(_selectedTabIndex);
                if (category != null) {
                  await _cubit.loadTalents(category, refresh: true);
                }
              }
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                _onScrollNotification(scrollInfo);
                return false;
              },
              child: NestedScrollView(
                controller: _mainScrollController,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return [
                    // AppBar
                    SliverAppBar(
                      pinned: true,
                      floating: false,
                      snap: false,
                      elevation: 0,
                      surfaceTintColor: Colors.transparent,
                      backgroundColor:
                          context.isDarkMode ? Colors.black : Colors.white,
                      toolbarHeight: 60,
                      titleSpacing: 16,
                      leading: BackButton(
                          onPressed: () {
                            ManageVibration.vibrate();
                            Navigator.pop(context);
                          },
                          color:
                              context.isDarkMode ? Colors.white : Colors.black),
                      title: Text(
                        'Tube',
                        style: TextStyle(
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      actions: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Winners',
                                style: TextStyle(
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.emoji_events, color: Colors.orange),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Header Section - يختفي مع الـ scroll
                    if (!_isSearching)
                      SliverToBoxAdapter(
                        child: BeStarHeaderSection(state: state),
                      ),

                    // Sticky Tabs
                    if (!_isSearching)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyTabBarDelegate(
                          tabController: _tabController,
                          context: context,
                          onSearchTap: _toggleSearch,
                        ),
                      ),

                    // Search Bar (when searching)
                    if (_isSearching)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SearchBarDelegate(
                          child: BeStarSearchBar(
                            controller: _searchController,
                            onTalentSearch: _onTalentSearch,
                            onProfileSearch: _onProfileSearch,
                            showProfileSearch: true,
                          ),
                        ),
                      ),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    if (_isSearching && _isSearchingProfiles) {
                      return CustomScrollView(
                        slivers: [
                          ProfileSearchResults(
                            profiles: state.searchProfileResults,
                            isLoading: state.isSearchingProfiles,
                          ),
                        ],
                      );
                    } else if (_isSearching && !_isSearchingProfiles) {
                      return _buildTalentSearchResults(state);
                    } else {
                      return _buildSynchronizedTabContent(state);
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSynchronizedTabContent(StarState state) {
    return CustomScrollView(
      slivers: [
        // Your existing tab content as slivers
        _getTabContentSliver(state),
      ],
    );
  }

  Widget _getTabContentSliver(StarState state) {
    switch (_selectedTabIndex) {
      case 0: // Available
        return TalentCardBuilders.buildAvailableContentSliver(
          context: context,
          cubit: _cubit,
          isSearching: false,
          scrollController: _availableController,
        );
      case 1: // Favorites
        return TalentCardBuilders.buildFavoriteContentSliver(
          context: context,
          cubit: _cubit,
        );
      case 2: // History
        return TalentCardBuilders.buildHistoryContentSliver(
          context: context,
          cubit: _cubit,
        );
      case 3: // My Talents
        return _buildMyTalentContent(state);
      default:
        return TalentCardBuilders.buildAvailableContentSliver(
          context: context,
          cubit: _cubit,
          isSearching: false,
          scrollController: _availableController,
        );
    }
  }

  Widget _buildMyTalentContent(StarState state) {
    // Show VideoDetailsView if video is selected, otherwise show list
    if (_showVideoDetails &&
        _selectedVideoTalent != null &&
        _selectedVideoUrl != null) {
      // لازم نحط الـ VideoDetailsView جوا SliverToBoxAdapter
      return SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: VideoDetailsView(
            talent: _selectedVideoTalent!,
            mediaUrl: _selectedVideoUrl!,
            cubit: _cubit,
            onBack: _onBackFromVideoDetails,
          ),
        ),
      );
    } else {
      return TalentCardBuilders.buildMyTalentContentSliver(
        context: context,
        cubit: _cubit,
        onVideoTap: _onVideoSelected,
      );
    }
  }

  Widget _buildTalentSearchResults(StarState state) {
    if (state.searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: MediaQuery.of(context).size.width * 0.15,
                color: Colors.grey,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Text(
                context.isArabic
                    ? 'لا توجد مواهب تطابق بحثك'
                    : 'No talents match your search',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final talent = state.searchResults[index];
        return TalentCard(
          talent: talent,
          cubit: _cubit,
        );
      },
    );
  }

  @override
  void dispose() {
    try {
      // Remove listeners first with proper checks
      _tabController.removeListener(_onTabChanged);
      _searchController.removeListener(_onSearchChanged);

      // Remove scroll listeners with proper checks
      if (_mainScrollController.hasClients &&
          _mainScrollController.hasListeners) {
        _mainScrollController.removeListener(() => _syncFromMain());
      }

      if (_availableController.hasClients &&
          _availableController.hasListeners) {
        _availableController
            .removeListener(() => _syncToMain(_availableController));
      }

      if (_favoriteController.hasClients && _favoriteController.hasListeners) {
        _favoriteController
            .removeListener(() => _syncToMain(_favoriteController));
      }

      if (_historyController.hasClients && _historyController.hasListeners) {
        _historyController
            .removeListener(() => _syncToMain(_historyController));
      }

      if (_myTalentController.hasClients && _myTalentController.hasListeners) {
        _myTalentController
            .removeListener(() => _syncToMain(_myTalentController));
      }
    } catch (e) {
      print('Error during controller disposal: $e');
    }

    // Then dispose controllers
    _tabController.dispose();
    _searchController.dispose();
    _mainScrollController.dispose();
    _availableController.dispose();
    _favoriteController.dispose();
    _historyController.dispose();
    _myTalentController.dispose();

    super.dispose();
  }
}

// Search Bar Delegate
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  SearchBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: context.isDarkMode ? Colors.black : Colors.white,
      child: child,
    );
  }

  @override
  double get maxExtent => 150.0;

  @override
  double get minExtent => 150.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
