import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/be_star_app_bar.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/be_star_floating_button.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/be_star_header_section.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/be_star_search_bar.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/be_star_tab_content.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/subscribe_button_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/pages/video_details_view.dart';
import 'package:fourtyninehub/helpers/subscription_method.dart';
import 'package:go_router/go_router.dart';

import '../../../../ads/native_ad_card.dart';
import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/custom_show_dialog.dart';
import '../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../core/widget/olx_pagination/banner.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/star_entity.dart';
import '../controller/cubit/star_cubit.dart';
import '../controller/cubit/star_state.dart';
import '../widgets/profile_search_results.dart';
import 'all_winner_view.dart';
import '../widgets/floating_action_button_star.dart';
import '../widgets/sticky_tab_bar_delegate.dart';

class BeStarView extends StatefulWidget {
  const BeStarView({super.key});

  @override
  _BeStarViewState createState() => _BeStarViewState();
}

class _BeStarViewState extends State<BeStarView> with TickerProviderStateMixin {
  late StarCubit _cubit;
  late TabController _tabController;
  bool _showFloatingButton = true;
  final AdsManager _adsManager = AdsManager();
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
    _adsManager.preloadAds();

    // Setup scroll synchronization
    _setupScrollSynchronization();
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

  // void _syncFromMain() {
  //   if (_isSyncing) return;
  //   _isSyncing = true;

  //   final activeController = _getActiveTabController();
  //   if (activeController != null && activeController.hasClients) {
  //     activeController.jumpTo(_mainScrollController.offset.clamp(
  //       activeController.position.minScrollExtent,
  //       activeController.position.maxScrollExtent,
  //     ));
  //   }

  //   _isSyncing = false;
  // }

  // void _syncToMain(ScrollController tabController) {
  //   if (_isSyncing) return;
  //   if (tabController != _getActiveTabController()) return;

  //   _isSyncing = true;

  //   if (_mainScrollController.hasClients) {
  //     _mainScrollController.jumpTo(tabController.offset.clamp(
  //       _mainScrollController.position.minScrollExtent,
  //       _mainScrollController.position.maxScrollExtent,
  //     ));
  //   }

  //   _isSyncing = false;
  // }

  void _syncFromMain() {
    if (_isSyncing || !mounted) return; // Add mounted check
    _isSyncing = true;
    final activeController = _getActiveTabController();
    if (activeController != null &&
        activeController.hasClients &&
        _mainScrollController.hasClients) {
      // Check both controllers
      activeController.jumpTo(_mainScrollController.offset.clamp(
        activeController.position.minScrollExtent,
        activeController.position.maxScrollExtent,
      ));
    }
    _isSyncing = false;
  }

  void _syncToMain(ScrollController tabController) {
    if (_isSyncing || !mounted) return; // Add mounted check
    if (tabController != _getActiveTabController()) return;
    _isSyncing = true;
    if (_mainScrollController.hasClients && tabController.hasClients) {
      _mainScrollController.jumpTo(tabController.offset.clamp(
        _mainScrollController.position.minScrollExtent,
        _mainScrollController.position.maxScrollExtent,
      ));
    }
    _isSyncing = false;
  }

  ScrollController? _getActiveTabController() {
    switch (_selectedTabIndex) {
      case 0:
        return _availableController;
      case 1:
        return _favoriteController;
      case 2:
        return _historyController;
      case 3:
        return _myTalentController;
      default:
        return null;
    }
  }

  void _onTabChanged() {
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

  // void _onScrollNotification(ScrollNotification scrollInfo) {
  //   if (scrollInfo is UserScrollNotification) {
  //     if (scrollInfo.direction == ScrollDirection.reverse) {
  //       if (_showFloatingButton) {
  //         setState(() {
  //           _showFloatingButton = false;
  //         });
  //       }
  //     } else if (scrollInfo.direction == ScrollDirection.forward) {
  //       if (!_showFloatingButton) {
  //         setState(() {
  //           _showFloatingButton = true;
  //         });
  //       }
  //     }
  //   }
  // }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (!mounted) return; // Guard against disposed state

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
      appBar: BeStarAppBar(),
      floatingActionButton: BeStarFloatingButton(
        showButton: _showFloatingButton,
        isLoggedIn: context.read<UserCubit>().isLoggedIn,
      ),
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          if (state.status == StarStates.loading &&
              state.availableTalents.isEmpty) {
            return const CustomLoadingSearchWidget();
          }

          return RefreshIndicator(
            color: AppColors.getTextColor(context),
            backgroundColor: AppColors.getFindFillColor(context),
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
              child: GlowingOverscrollIndicator(
                axisDirection: AxisDirection.down,
                color: AppColors.SECONDARY_COLOR,
                child: CustomScrollView(
                  controller: _mainScrollController,
                  slivers: [
                    // Collapsible Header Section (hide when searching)
                    if (!_isSearching)
                      SliverAppBar(
                        expandedHeight: context.isArabic
                            ? MediaQuery.sizeOf(context).height * 0.32
                            : MediaQuery.of(context).size.height * 0.36,
                        floating: true,
                        pinned: false,
                        snap: true,
                        automaticallyImplyLeading: false,
                        backgroundColor: Colors.transparent,
                        flexibleSpace: FlexibleSpaceBar(
                          background: BeStarHeaderSection(state: state),
                        ),
                      ),

                    // Sticky Tabs Section (hide when searching)
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
                      BeStarSearchBar(
                        controller: _searchController,
                        onTalentSearch: _onTalentSearch,
                        onProfileSearch: _onProfileSearch,
                        showProfileSearch: true,
                      ),

                    // Content based on search state
                    if (_isSearching && _isSearchingProfiles)
                      // Profile search results
                      ProfileSearchResults(
                        profiles: state.searchProfileResults,
                        isLoading: state.isSearchingProfiles,
                      )
                    else if (_isSearching && !_isSearchingProfiles)
                      // Talent search results
                      _buildTalentSearchResults(state)
                    else
                      // Regular tab content with synchronized scrolling
                      _buildSynchronizedTabContent(state),

                    // Back to tabs button when searching
                    if (_isSearching)
                      SliverToBoxAdapter(
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.04),
                          child: ElevatedButton(
                            onPressed: _toggleSearch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.063,
                                ),
                              ),
                            ),
                            child: Text(
                              context.isArabic
                                  ? 'العودة للتبويبات'
                                  : 'Back to Tabs',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSynchronizedTabContent(StarState state) {
    switch (_selectedTabIndex) {
      case 0: // Available
        return _buildAvailableContentWithSync(state);
      case 1: // Favorites
        return _buildFavoriteContentWithSync(state);
      case 2: // History
        return _buildHistoryContentWithSync(state);
      case 3: // My Talents
        return _buildMyTalentContentWithSync(state);
      default:
        return _buildAvailableContentWithSync(state);
    }
  }

  Widget _buildAvailableContentWithSync(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.status == StarStates.loading &&
            state.availableTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        final talentsToShow = state.availableTalents;
        if (talentsToShow.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: LocaleKeys.noResultsFound.localize,
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: OlxPaginationWidget(
              items: List.generate(
                talentsToShow.length,
                (index) => TalentCard.buildTalentCard(
                    context, talentsToShow[index], _cubit),
              ),
              banners: bannersList,
              loadPage: (page) => _cubit.loadTalents(TalentCategory.available),
              scrollController: _availableController,
              itemsPerPage: 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFavoriteContentWithSync(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.favorites)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        if (state.favoriteTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: context.isArabic
                    ? 'لا يوجد فيديوات مفضلة بعد'
                    : 'No favorite videos yet',
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: ListView.builder(
              controller: _favoriteController,
              itemCount: state.favoriteTalents.length,
              itemBuilder: (context, index) {
                final talent = state.favoriteTalents[index];
                return TalentCard.buildTalentCard(context, talent, _cubit);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryContentWithSync(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.history)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        if (state.historyTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: Center(
                child: Text(
                  context.isArabic
                      ? 'لا يوجد فيديوات في التاريخ'
                      : 'No videos in history',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: ListView.builder(
              controller: _historyController,
              itemCount: state.historyTalents.length,
              itemBuilder: (context, index) {
                final talent = state.historyTalents[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video thumbnail with overlays
                      Container(
                        width: 140,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[300],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Video info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              talent.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${talent.user.firstName} ${talent.user.lastName}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMyTalentContentWithSync(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.myTalents)) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: const Center(child: CustomCircularProgressIndicator()),
            ),
          );
        }

        if (state.myTalents.isEmpty) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: CustomEmptyWidget(
                label: LocaleKeys.noResultsFound.localize,
              ),
            ),
          );
        }

        // Show VideoDetailsView if video is selected
        if (_showVideoDetails &&
            _selectedVideoTalent != null &&
            _selectedVideoUrl != null) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.75,
              child: VideoDetailsView(
                talent: _selectedVideoTalent!,
                mediaUrl: _selectedVideoUrl!,
                onBack: _onBackFromVideoDetails,
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * .6,
            child: ListView.builder(
              controller: _myTalentController,
              itemCount: state.myTalents.length,
              itemBuilder: (context, index) {
                final talent = state.myTalents[index];
                final mediaUrl = talent.mediaUrl.isNotEmpty
                    ? talent.mediaUrl.first.mediaKey
                    : '';

                return GestureDetector(
                  onTap: () => _onVideoSelected(talent, mediaUrl),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                talent.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${talent.user.firstName} ${talent.user.lastName}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTalentSearchResults(StarState state) {
    if (state.searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Center(
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
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final talent = state.searchResults[index];
          return TalentCard.buildTalentCard(context, talent, _cubit);
        },
        childCount: state.searchResults.length,
      ),
    );
  }

  @override
  void dispose() {
    // Remove listeners first
    _tabController.removeListener(_onTabChanged);
    _searchController.removeListener(_onSearchChanged);
    _mainScrollController.removeListener(() => _syncFromMain());
    _availableController
        .removeListener(() => _syncToMain(_availableController));
    _favoriteController.removeListener(() => _syncToMain(_favoriteController));
    _historyController.removeListener(() => _syncToMain(_historyController));
    _myTalentController.removeListener(() => _syncToMain(_myTalentController));

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
  double get maxExtent => 80.0; // Adjust based on your search bar height

  @override
  double get minExtent => 80.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
