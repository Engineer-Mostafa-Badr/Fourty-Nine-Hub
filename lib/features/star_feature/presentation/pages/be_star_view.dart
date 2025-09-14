import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/styles.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entity/star_entity.dart';

import '../controller/star_cubit/star_cubit.dart';
import '../utils/enums.dart';
import '../utils/memory_manager.dart';
import '../widgets/be_star_floating_button.dart';
import '../widgets/be_star_header_section.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/talent_card/profile_search_results.dart';
import '../widgets/talent_card/sticky_tab_bar_delegate.dart';
import '../widgets/talent_card/talent_card.dart';
import '../widgets/talent_card/talent_card_builders.dart';
import 'my_video_details_view.dart';

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
  Timer? _searchDebounce;

  // Video details view state for My Talent tab
  StarEntity? _selectedVideoTalent;
  String? _selectedVideoUrl;
  bool _showVideoDetails = false;

  // Individual controllers for each tab content (keep for specific use cases)
  final ScrollController _availableController = ScrollController();
  final ScrollController _favoriteController = ScrollController();
  final ScrollController _historyController = ScrollController();
  final ScrollController _myTalentController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);

    // Initialize memory manager
    MemoryManager().init();

    // Initialize data with delay for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _cubit.initializeAllData();
      }
    });

    // Add debugging
    _debugInitialization();
  }

  void _debugInitialization() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🎯 BeStarView initialized");
      context.read<StarCubit>().debugMyTalentsFlow();
    });
  }

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
    // إلغاء الـ timer السابق
    _searchDebounce?.cancel();

    // إنشاء timer جديد للتأخير مع وقت أطول لتقليل الضغط
    _searchDebounce = Timer(Duration(milliseconds: 800), () {
      if (mounted) {
        // Check if widget is still mounted
        final query = _searchController.text.trim();
        if (query.isNotEmpty && query.length >= 2) {
          // بحث فقط إذا كان النص أكثر من حرفين
          _cubit.searchTubeVideos(query);
        } else {
          _cubit.searchTubeVideos(''); // مسح النتائج
        }
      }
    });
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
      body: BlocConsumer<StarCubit, StarState>(
        listener: (context, state) {
          if (state.status == StarStates.ratingSuccess &&
              state.successMessage != null) {
            final rating = int.tryParse(state.successMessage!) ?? 0;
            final arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥'];

            final message = context.isArabic
                ? 'تم تقييم الفيديو بـ ${arabicNumbers[rating]} ${rating == 1 ? 'نجمة' : 'نجوم'}'
                : 'Video rated with $rating ${rating == 1 ? 'star' : 'stars'}';

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).primaryColor,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
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
                      toolbarHeight: 30,
                      leading: BackButton(
                        onPressed: () {
                          ManageVibration.vibrate();
                          Navigator.pop(context);
                        },
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      centerTitle: false,
                      titleSpacing:
                          0, // Remove default spacing between leading and title
                      title: Label(
                        text: context.isArabic ? 'تيوب' : 'Tube',
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
                                // make it arabic
                                context.isArabic ? '(١٥/٣٧٠٠)' : '(15/3700)',
                                style: Styles.smallText(),
                              ),
                              SizedBox(width: 4),
                              Text(
                                context.isArabic ? 'الفائزون' : 'Winners',
                                style: Styles.headerText(
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 28),
                              ),
                              SizedBox(width: 4),
                              Image.asset(Assets.cupImage,
                                  width: 24, height: 24),
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
                    // Sticky Tabs with Search
                    if (!_isSearching)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyTabBarDelegate(
                          tabController: _tabController,
                          context: context,
                          onSearchTap: _toggleSearch,
                          showSearchField: false, // مش هنظهره هنا
                        ),
                      ),

                    // Search Bar (when searching)
                    if (_isSearching)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: StickyTabBarDelegate(
                          tabController: _tabController,
                          context: context,
                          onSearchTap: _toggleSearch,
                          showSearchField: true, // هنظهره هنا
                          searchController: _searchController,
                          onSearchChanged: (value) {
                            // Real-time search كل ما المستخدم يكتب
                            _onSearchChanged();
                          },
                        ),
                      ),
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // Available Tab
                    _buildTabContent(0, state),
                    // Favorites Tab
                    _buildTabContent(1, state),
                    // History Tab
                    _buildTabContent(2, state),
                    // My Talents Tab
                    _buildTabContent(3, state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(int tabIndex, StarState state) {
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
    }

    switch (tabIndex) {
      case 0: // Available
        return CustomScrollView(
          slivers: [
            TalentCardBuilders.buildAvailableContentSliver(
              context: context,
              cubit: _cubit,
              isSearching: false,
              scrollController: _availableController,
            ),
          ],
        );
      case 1: // Favorites
        return CustomScrollView(
          slivers: [
            TalentCardBuilders.buildFavoriteContentSliver(
              context: context,
              cubit: _cubit,
            ),
          ],
        );
      case 2: // History
        return CustomScrollView(
          slivers: [
            TalentCardBuilders.buildHistoryContentSliver(
              context: context,
              cubit: _cubit,
            ),
          ],
        );
      case 3: // My Talents
        return _buildMyTalentContent(state);
      default:
        return CustomScrollView(
          slivers: [
            TalentCardBuilders.buildAvailableContentSliver(
              context: context,
              cubit: _cubit,
              isSearching: false,
              scrollController: _availableController,
            ),
          ],
        );
    }
  }

  Widget _buildMyTalentContent(StarState state) {
    // Show VideoDetailsView if video is selected, otherwise show list
    if (_showVideoDetails &&
        _selectedVideoTalent != null &&
        _selectedVideoUrl != null) {
      return CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.75,
              child: BlocProvider<StarCubit>.value(
                value: _cubit, // Provide the cubit explicitly
                child: VideoDetailsView(
                  talent: _selectedVideoTalent!,
                  mediaUrl: _selectedVideoUrl!,
                  cubit: _cubit,
                  onBack: _onBackFromVideoDetails,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return CustomScrollView(
        slivers: [
          TalentCardBuilders.buildMyTalentContentSliver(
            context: context,
            cubit: _cubit,
            onVideoTap: _onVideoSelected,
          ),
        ],
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
      // Cancel debounce timer first
      _searchDebounce?.cancel();

      // Remove listeners first with proper checks
      if (_tabController.hasListeners) {
        _tabController.removeListener(_onTabChanged);
      }
      if (_searchController.hasListeners) {
        _searchController.removeListener(_onSearchChanged);
      }
    } catch (e) {
      print('Error during controller disposal: $e');
    }

    // Then dispose controllers safely
    try {
      _tabController.dispose();
      _searchController.dispose();
      _availableController.dispose();
      _favoriteController.dispose();
      _historyController.dispose();
      _myTalentController.dispose();
    } catch (e) {
      debugPrint('Error disposing controllers: $e');
    }

    // Dispose memory manager
    MemoryManager().dispose();

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
