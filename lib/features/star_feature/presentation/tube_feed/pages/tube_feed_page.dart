import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/arabic_pluralization.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../presentation_exports.dart';

class TubeFeedView extends StatefulWidget {
  const TubeFeedView({super.key});

  @override
  _TubeFeedViewState createState() => _TubeFeedViewState();
}

class _TubeFeedViewState extends State<TubeFeedView>
    with
        TickerProviderStateMixin,
        ScrollSyncMixin,
        SearchMixin,
        TabManagementMixin {
  late StarCubit _cubit;
  bool _showFloatingButton = true;
  bool _isManualRefreshing = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();

    // Initialize mixins
    initializeTabController(tabCount: 4);
    initializeScrollControllers();
    initializeSearchController();

    // Setup scroll synchronization
    setupScrollSynchronization();

    // Initialize all data
    _cubit.initializeAllData();
    _cubit.getTubeWinnerStatistics();

    // Debug initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("🎯 BeStarView initialized");
      context.read<StarCubit>().debugMyTalentsFlow();
    });
    // ✅ إضافة تعيين Status Bar للأسود
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black, // لون الخلفية
        statusBarIconBrightness:
            Brightness.light, // الأيقونات فاتحة للخلفية الداكنة
        statusBarBrightness: Brightness.dark, // للـ iOS
      ),
    );
  }

  @override
  void onTabChangedCallback() {
    // Reset search when switching tabs
    if (isSearching) {
      searchController.clear();
      _cubit.searchTalents('');
      _cubit.clearProfileSearch();
    }

    // Update scroll sync selected tab index
    updateSelectedTabIndex(selectedTabIndex);

    // Refresh data for the selected tab
    final category = getTabCategory(selectedTabIndex);
    if (category != null) {
      print("🔄 Refreshing data for category: $category");
      _cubit.loadTalents(category, refresh: true);
    }
  }

  @override
  void onSearchQueryChanged(String query) {
    if (query.isNotEmpty && query.length >= 2) {
      _cubit.searchTubeVideos(query);
    } else {
      _cubit.searchTubeVideos('');
    }
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is UserScrollNotification) {
      if (scrollInfo.direction == ScrollDirection.reverse) {
        if (_showFloatingButton) {
          setState(() => _showFloatingButton = false);
        }
      } else if (scrollInfo.direction == ScrollDirection.forward) {
        if (!_showFloatingButton) {
          setState(() => _showFloatingButton = true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StarCubit, StarState>(
        listener: _handleStateListener,
        builder: (context, state) {
          return CustomScaffold(
            enableCustomAppBar: true,
            floatingActionButton: _showFloatingButton
                ? buildFloatingAction(context,
                    title: "${LocaleKeys.addTalent.localize} +", () {
                    ManageVibration.vibrate();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateStar()),
                    );
                  })
                : null,
            appBar: BackAppBar(
              label: context.isArabic ? 'تيوب' : 'Tube',
              enableCustomAppBar: true,
              actions: [_buildWinnerStats(context, state)],
            ),
            body: state.status == StarStates.loading &&
                    state.availableTalents.isEmpty
                ? const StarLoadingIndicator()
                : RefreshIndicator(
                    onRefresh: () => _handleRefresh(),
                    displacement: 40.0,
                    strokeWidth: 2.5,
                    backgroundColor:
                        context.isDarkMode ? Colors.grey[800] : Colors.white,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        _onScrollNotification(scrollInfo);
                        return false;
                      },
                      child: _buildNestedScrollView(state),
                    ),
                  ),
          );
        });
  }

  void _handleStateListener(BuildContext context, StarState state) {
    if (state.status == StarStates.ratingSuccess &&
        state.successMessage != null) {
      final rating = int.tryParse(state.successMessage!) ?? 0;
      final arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥'];

      final message = context.isArabic
          ? 'تم تقييم الفيديو بـ ${arabicNumbers[rating]} ${rating == 1 ? 'نجمة' : 'نجوم'}'
          : 'Video rated with $rating ${rating == 1 ? 'star' : 'stars'}';

      showSuccessDialog(context, message);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(message),
      //     backgroundColor: Theme.of(context).primaryColor,
      //     duration: Duration(seconds: 2),
      //   ),
      // );
    }
  }

  Future<void> _handleRefresh() async {
    print("🔄 RefreshIndicator triggered for tab: $selectedTabIndex");

    if (_isManualRefreshing) {
      print("⚠️ Refresh already in progress, ignoring");
      return;
    }

    setState(() => _isManualRefreshing = true);

    try {
      if (isSearching) {
        if (isSearchingProfiles) {
          print("🔍 Refreshing profile search: ${searchController.text}");
          _cubit.searchProfiles(searchController.text);
        } else {
          print("🔍 Refreshing talent search: ${searchController.text}");
          _cubit.searchTalents(searchController.text);
        }
        await Future.delayed(Duration(milliseconds: 500));
      } else {
        final category = getTabCategory(selectedTabIndex);
        if (category != null) {
          print("📱 Refreshing category: $category");
          await _cubit.loadTalents(category, refresh: true);
          await Future.delayed(Duration(milliseconds: 300));
        } else {
          print("⚠️ No category found for tab index: $selectedTabIndex");
        }
      }
      print("✅ Refresh completed successfully");
    } catch (e) {
      print("❌ Refresh failed: $e");
      rethrow;
    } finally {
      if (mounted) {
        setState(() => _isManualRefreshing = false);
      }
    }
  }

  Widget _buildNestedScrollView(StarState state) {
    return NestedScrollView(
      controller: mainScrollController,
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      headerSliverBuilder: (context, innerBoxIsScrolled) =>
          _buildHeaders(context, state),
      body: _buildBody(state),
    );
  }

  List<Widget> _buildHeaders(BuildContext context, StarState state) {
    return [
      // Header Section
      if (!isSearching)
        SliverToBoxAdapter(child: BeStarHeaderSection(state: state)),

      // Sticky Tabs or Search Bar
      SliverPersistentHeader(
        pinned: true,
        floating: false,
        delegate: StickyTabBarDelegate(
          tabController: tabController,
          context: context,
          onSearchTap: () => toggleSearch(_cubit),
          showSearchField: isSearching,
          searchController: isSearching ? searchController : null,
          onSearchChanged:
              isSearching ? (value) => onSearchQueryChanged(value) : null,
        ),
      ),
    ];
  }

  Widget _buildAppBar(BuildContext context, StarState state) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      snap: false,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor:
          context.isDarkMode ? Colors.black : AppColors.PRIMARY_COLOR,
      toolbarHeight: 50,
      leading: BackButton(
        onPressed: () {
          ManageVibration.vibrate();
          Navigator.pop(context);
        },
        color: context.isDarkMode ? Colors.black : Colors.white,
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Label(
        text: context.isArabic ? 'تيوب' : 'Tube',
        style: TextStyle(
          color: context.isDarkMode ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [_buildWinnerStats(context, state)],
    );
  }

  Widget _buildWinnerStats(BuildContext context, StarState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<StarCubit, StarState>(
        builder: (context, state) {
          int totalWinners = state.tubeWinnerStatistics?.totalWinner ?? 0;
          int totalVideos = state.tubeWinnerStatistics?.totalVideos ?? 0;

          final formatNumbers = FormatNumbers();
          final displayTotalWinners = context.isArabic
              ? formatNumbers.convertToArabicNumerals(totalWinners.toString())
              : totalWinners.toString();
          final displayTotalVideos = context.isArabic
              ? formatNumbers.convertToArabicNumerals(totalVideos.toString())
              : totalVideos.toString();

          final winnerText =
              ArabicPluralization.getWinnerText(totalWinners, context.isArabic);

          return GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                          value: serviceLocator<StarCubit>(),
                          child: AllWinnerView(),
                        )),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  winnerText,
                  style: Styles.headerText(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '($displayTotalWinners/$displayTotalVideos)',
                  style: Styles.smallText(
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 4),
                Image.asset(Assets.cupImage, width: 24, height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(StarState state) {
    if (isSearching && isSearchingProfiles) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          ProfileSearchResults(
            profiles: state.searchProfileResults,
            isLoading: state.isSearchingProfiles,
          ),
        ],
      );
    } else if (isSearching && !isSearchingProfiles) {
      return _buildTalentSearchResults(state);
    } else {
      return _buildTabContent(state);
    }
  }

  Widget _buildTabContent(StarState state) {
    return CustomScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [_getTabContentSliver(state)],
    );
  }

  Widget _getTabContentSliver(StarState state) {
    switch (selectedTabIndex) {
      case 0: // Available
        return AvailableContentBuilder.buildSliver(
          context: context,
          cubit: _cubit,
          isSearching: false,
          scrollController: availableController,
        );
      case 1: // Favorites
        return FavoriteContentBuilder.buildSliver(
          context: context,
          cubit: _cubit,
          scrollController: favoriteController,
        );
      case 2: // History
        return HistoryContentBuilder.buildSliver(
          context: context,
          cubit: _cubit,
          scrollController: historyController,
        );
      case 3: // My Talents
        return _buildMyTalentContent(state);
      // return MyTalentContentBuilder.buildSliver(
      //   context: context,
      //   cubit: _cubit,
      //   scrollController: myTalentController,
      // );
      default:
        return AvailableContentBuilder.buildSliver(
          context: context,
          cubit: _cubit,
          isSearching: false,
          scrollController: availableController,
        );
    }
  }

  Widget _buildMyTalentContent(StarState state) {
    if (showVideoDetails &&
        selectedVideoTalent != null &&
        selectedVideoUrl != null) {
      return SliverToBoxAdapter(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.75,
          child: VideoDetailsView(
            talent: selectedVideoTalent!,
            mediaUrl: selectedVideoUrl!,
            cubit: _cubit,
            onBack: onBackFromVideoDetails,
          ),
        ),
      );
    } else {
      return MyTalentContentBuilder.buildSliver(
        context: context,
        cubit: _cubit,
        onVideoTap: onVideoSelected,
      );
    }
  }

  Widget _buildTalentSearchResults(StarState state) {
    if (state.searchResults.isEmpty && searchController.text.isNotEmpty) {
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

    return CustomScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final talent = state.searchResults[index];
              return TalentCard(talent: talent, cubit: _cubit);
            },
            childCount: state.searchResults.length,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    disposeTabController();
    disposeScrollControllers();
    disposeSearchController();
    // ✅ إعادة Status Bar للإعدادات الافتراضية
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent, // أو اللون الذي تريده للصفحات الأخرى
        statusBarIconBrightness:
            Brightness.dark, // أيقونات داكنة للخلفيات الفاتحة
        statusBarBrightness: Brightness.light, // للـ iOS
      ),
    );
    super.dispose();
  }
}
