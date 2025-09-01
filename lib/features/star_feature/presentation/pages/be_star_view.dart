import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/widget/olx_pagination/olx_pagination_widget.dart';
import 'package:fourtyninehub/features/star_feature/presentation/helper/youtube_style_video_player.dart';
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

  void _syncFromMain() {
    if (_isSyncing || !mounted) return;
    _isSyncing = true;

    final activeController = _getActiveTabController();
    if (activeController != null &&
        activeController.hasClients &&
        _mainScrollController.hasClients &&
        mounted) {
      // إضافة mounted check
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
      // إضافة mounted check
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
                      toolbarHeight: 30,
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

                    // Header Section - هيختفي مع الـ scroll
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
                      // Profile search results - wrap in CustomScrollView for sliver
                      return CustomScrollView(
                        slivers: [
                          ProfileSearchResults(
                            profiles: state.searchProfileResults,
                            isLoading: state.isSearchingProfiles,
                          ),
                        ],
                      );
                    } else if (_isSearching && !_isSearchingProfiles) {
                      // Talent search results - regular widget
                      return _buildTalentSearchResults(state);
                    } else {
                      // Regular tab content - regular widgets
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
    switch (_selectedTabIndex) {
      case 0: // Available
        return _buildAvailableContent(state);
      case 1: // Favorites
        return _buildFavoriteContent(state);
      case 2: // History
        return _buildHistoryContent(state);
      case 3: // My Talents
        return _buildMyTalentContent(state);
      default:
        return _buildAvailableContent(state);
    }
  }

  Widget _buildAvailableContent(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.status == StarStates.loading &&
            state.availableTalents.isEmpty) {
          return SizedBox(
            height: 200,
            child: const Center(child: CustomCircularProgressIndicator()),
          );
        }

        final talentsToShow = state.availableTalents;
        if (talentsToShow.isEmpty) {
          return SizedBox(
            height: 200,
            child: CustomEmptyWidget(
              label: LocaleKeys.noResultsFound.localize,
            ),
          );
        }

        return SizedBox(
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
        );
      },
    );
  }

  Widget _buildFavoriteContent(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.favorites)) {
          return SizedBox(
            height: 200,
            child: const Center(child: CustomCircularProgressIndicator()),
          );
        }

        if (state.favoriteTalents.isEmpty) {
          return SizedBox(
            height: 200,
            child: CustomEmptyWidget(
              label: context.isArabic
                  ? 'لا يوجد فيديوات مفضلة بعد'
                  : 'No favorite videos yet',
            ),
          );
        }

        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .6,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _favoriteController,
            itemCount: state.favoriteTalents.length,
            itemBuilder: (context, index) {
              final talent = state.favoriteTalents[index];
              return TalentCard.buildTalentCard(context, talent, _cubit);
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryContent(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        // حالة التحميل الأولي
        if (state.isLoading(TalentCategory.history)) {
          return SizedBox(
            height: 200,
            child: const Center(child: CustomCircularProgressIndicator()),
          );
        }

        // حالة عدم وجود عناصر
        if (state.historyTalents.isEmpty) {
          return SizedBox(
            height: 200,
            child: Center(
              child: Text(
                context.isArabic
                    ? 'لا يوجد فيديوات في التاريخ'
                    : 'No videos in history',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        // العدد مع خانة إضافية إن كان هناك المزيد
        final hasMore = state.hasMore(TalentCategory.history);
        final itemCount = state.historyTalents.length + (hasMore ? 1 : 0);

        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .6,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            controller: _historyController,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              if (index == state.historyTalents.length) {
                return _buildLoadMoreWidgetIfNeeded(context, state);
              }

              final talent = state.historyTalents[index];

              return GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  final mediaUrl = talent.mediaUrl.isNotEmpty
                      ? talent.mediaUrl.first.mediaKey
                      : '';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TalentVideoPlayer(
                        talent: talent,
                        videoUrl: mediaUrl,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: Colors.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail + Overlays (مكافئ لـ _buildThumbnailWithOverlays)
                      Container(
                        width: 140,
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey,
                                image: const DecorationImage(
                                  image: AssetImage(
                                      'assets/images/testforvideo.jpg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '7:54',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // معلومات الفيديو (مكافئ لـ _buildVideoInfoColumn)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              talent.title,
                              style: const TextStyle(
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
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 2),
                            // إن رغبت بإظهار المشاهدات والزمن مثل TalentCard
                            // يمكن استيراد timeago واستخدامه هنا.
                          ],
                        ),
                      ),
                      // زر الخيارات (مكافئ لـ _buildMoreOptionsButton)
                      GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          TalentCard.showHistoryOptions(
                              context, talent, _cubit);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

// مكافئ لويدجت TalentCard._buildLoadMoreWidget ولكن كود محلي في BeStarView
  Widget _buildLoadMoreWidgetIfNeeded(BuildContext context, StarState state) {
    final category = TalentCategory.history;
    if (state.isLoading(category)) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(child: CustomCircularProgressIndicator()),
      );
    }
    if (!state.hasMore(category)) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            context.isArabic ? 'لا يوجد المزيد' : 'No more content',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ElevatedButton(
          onPressed: () => _cubit.loadTalents(category),
          child: Text(context.isArabic ? 'تحميل المزيد' : 'Load More'),
        ),
      ),
    );
  }

  Widget _buildMyTalentContent(StarState state) {
    return BlocBuilder<StarCubit, StarState>(
      builder: (context, state) {
        if (state.isLoading(TalentCategory.myTalents)) {
          return SizedBox(
            height: 200,
            child: const Center(child: CustomCircularProgressIndicator()),
          );
        }

        if (state.myTalents.isEmpty) {
          return SizedBox(
            height: 200,
            child: CustomEmptyWidget(
              label: LocaleKeys.noResultsFound.localize,
            ),
          );
        }

        // Show VideoDetailsView if video is selected
        if (_showVideoDetails &&
            _selectedVideoTalent != null &&
            _selectedVideoUrl != null) {
          return SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.75,
            child: VideoDetailsView(
              talent: _selectedVideoTalent!,
              mediaUrl: _selectedVideoUrl!,
              onBack: _onBackFromVideoDetails,
            ),
          );
        }

        return SizedBox(
          height: MediaQuery.sizeOf(context).height * .6,
          child: ListView.builder(
            padding: EdgeInsets.zero,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        );
      },
    );
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
        return TalentCard.buildTalentCard(context, talent, _cubit);
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
      // Handle any disposal errors silently
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
  double get maxExtent => 150.0; // Adjust based on your search bar height

  @override
  double get minExtent => 150.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
