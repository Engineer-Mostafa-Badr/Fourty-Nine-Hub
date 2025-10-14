// chance_main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/pages/create_chance_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/core/widget/common/tab_widget.dart';
import 'package:fourtyninehub/features/subcategories/presentation/widgets/floating_add_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../service_locator/service_locator.dart';

import 'chance_winners_view.dart';
import '../controller/cubit/chance_cubit.dart';
import '../controller/cubit/chance_states.dart';
import '../../../../core/utils/arabic_pluralization.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../domain/entity/chance_ad_entity.dart';
import '../../domain/use_case/join_chance_ad_use_case.dart';
import '../../../../common/models/public/pagination_params.dart';

import '../widgets/floating_action_button_widget.dart';
import 'chance_detail_view.dart';
import '../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../core/widget/olx_pagination/banner.dart';

enum ChanceStatus { available, winner, ended }

// Main View
class ChanceMainView extends StatelessWidget {
  const ChanceMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ChanceCubit>()..getAllChanceAds(),
      child: Builder(
        builder: (context) => const _ChanceMainViewBody(),
      ),
    );
  }
}

class _ChanceMainViewBody extends StatefulWidget {
  const _ChanceMainViewBody();

  @override
  State<_ChanceMainViewBody> createState() => _ChanceMainViewState();
}

class _ChanceMainViewState extends State<_ChanceMainViewBody>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isSearching = false;
  bool _isCategoriesVisible = false;
  final TextEditingController _searchController = TextEditingController();
  // Removed _paginationScrollController since we're using slivers now
  int _selectedTabIndex = 0;
  List<dynamic> _categories = []; // Store fetched categories
  bool _isCategoriesLoading = false;

  // Individual controllers for each tab content
  final ScrollController _availableController = ScrollController();
  final ScrollController _favoriteController = ScrollController();
  final ScrollController _expireController = ScrollController();
  final ScrollController _myChanceController = ScrollController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _searchController.addListener(_onSearchChanged);

    // Load winner statistics
    context.read<ChanceCubit>().getWinnerStatistics();
  }

  // void _onTabChanged() {
  //   // Prevent duplicate calls during animation
  //   // Only load data when the tab is actually changing, not during animation
  //   if (!_tabController.indexIsChanging) return;

  //   setState(() {
  //     _selectedTabIndex = _tabController.index;
  //     // Clear search when switching tabs
  //     _isSearching = false;
  //     _isCategoriesVisible = false;
  //     _searchController.clear();
  //     // Reset pagination when switching tabs
  //     _lastLoadedPage = 1;
  //   });

  //   // Load data based on selected tab
  //   switch (_selectedTabIndex) {
  //     case 1: // Favorite
  //       context.read<ChanceCubit>().getFavoriteChanceAds();
  //       break;
  //     case 2: // Expire
  //       context.read<ChanceCubit>().getExpiredChanceAds();
  //       break;
  //     case 3: // My Talent
  //       context.read<ChanceCubit>().getMyChanceAds();
  //       break;
  //     default:
  //       // Available tab - data already loaded
  //       break;
  //   }
  // }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;

    setState(() {
      _selectedTabIndex = _tabController.index;
      _isSearching = false;
      _isCategoriesVisible = false;
      _searchController.clear();

      // Reset pagination for all tabs
      _lastLoadedPage = 1;
      _lastLoadedFavoritePage = 1;
      _lastLoadedExpiredPage = 1;
      _lastLoadedMyChancePage = 1;
    });

    switch (_selectedTabIndex) {
      case 1: // Favorite
        context.read<ChanceCubit>().getFavoriteChanceAds();
        break;
      case 2: // Expire
        context.read<ChanceCubit>().getExpiredChanceAds();
        break;
      case 3: // My Talent
        context.read<ChanceCubit>().getMyChanceAds();
        break;
      default:
        break;
    }
  }

  void _onSearchChanged() async {
    setState(() {
      _isCategoriesVisible = _searchController.text.isNotEmpty;
      _lastLoadedPage = 1; // Reset pagination when searching
    });

    if (_searchController.text.isNotEmpty) {
      // Fetch categories when search text is not empty
      if (_categories.isEmpty && !_isCategoriesLoading) {
        await _fetchCategories();
      }
      context.read<ChanceCubit>().searchChanceAds(_searchController.text);
    } else {
      context.read<ChanceCubit>().getAllChanceAds();
    }
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isCategoriesLoading = true;
    });

    final categories = await context
        .read<ChanceCubit>()
        .fetchMainCategoryChance(paginationParams: PaginationParams(page: 1));

    setState(() {
      _categories = categories;
      _isCategoriesLoading = false;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _isCategoriesVisible = false;
        _searchController.clear();
      }
    });
  }

  bool _showFloatingButton = true;
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
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        _onScrollNotification(scrollInfo);
        return false;
      },
      child: BlocListener<ChanceCubit, ChanceState>(
        listener: (context, state) {
          if (state.status == ChanceStates.joinSuccess) {
            showSuccessMessage(
                context,
                context.isArabic
                    ? 'تم الانضمام للفرصة بنجاح'
                    : 'Joined chance successfully');
            _refreshChanceAds();
          } else if (state.status == ChanceStates.error) {
            showErrorMessage(
                context, getFailureMessage(state.failure!, context));
          }
        },
        child: BlocBuilder<ChanceCubit, ChanceState>(
          builder: (context, state) {
            return CustomScaffold(
              enableCustomAppBar: true,
              backgroundColor: Colors.grey[50],
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: BackAppBar(
                  labelSize: 32,
                  enableCustomAppBar: true,
                  label: context.isArabic ? 'فرصة' : 'Chance',
                  backColor: context.isDarkMode
                      ? AppColors.Floating_Button_COLOR_DARK
                      : AppColors.PRIMARY_COLOR,
                  actions: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          final chanceCubit = context.read<ChanceCubit>();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: chanceCubit,
                                child: const ChanceWinnersView(),
                              ),
                            ),
                          );
                        },
                        child: BlocBuilder<ChanceCubit, ChanceState>(
                          builder: (context, state) {
                            int totalWinners = 0;
                            int totalAds = 0;

                            if (state.winnerStatistics != null) {
                              totalWinners =
                                  state.winnerStatistics!.totalWinner;
                              totalAds = state.winnerStatistics!.totalAds;
                            }

                            final winnerText =
                                ArabicPluralization.getWinnerText(
                              totalWinners,
                              context.isArabic,
                            );

                            final formatNumbers = FormatNumbers();
                            final displayTotalWinners = context.isArabic
                                ? formatNumbers.convertToArabicNumerals(
                                    totalWinners.toString())
                                : totalWinners.toString();
                            final displayTotalAds = context.isArabic
                                ? formatNumbers.convertToArabicNumerals(
                                    totalAds.toString())
                                : totalAds.toString();

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$winnerText ($displayTotalWinners/$displayTotalAds)',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    color: !context.isDarkMode
                                        ? Colors.white
                                        : AppColors.PRIMARY_COLOR,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Image.asset(
                                  Assets.cupImage,
                                  // width: 22,
                                  // height: 22,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  // Banner
                  if (!_isSearching) _buildBanner(),

                  // Search Bar or Tab Bar
                  Container(
                    color: context.isDarkMode
                        ? AppColors.c0B1035
                        : Colors.grey[50],
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                    child: _isSearching
                        ? SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Tabs
                                SizedBox(
                                  height: 60.h,
                                  child: Row(
                                    children: List.generate(
                                      4,
                                      (index) {
                                        final labels = [
                                          context.isArabic
                                              ? 'متاح'
                                              : 'Available',
                                          context.isArabic
                                              ? 'مفضلة'
                                              : 'Favorite',
                                          context.isArabic
                                              ? 'منتهي'
                                              : 'Expired',
                                          context.isArabic
                                              ? 'فرصي'
                                              : 'My Chance',
                                        ];
                                        return Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 4.w),
                                            child: TabWidget(
                                              title: labels[index],
                                              selected:
                                                  _tabController.index == index,
                                              onTap: () {
                                                _tabController.animateTo(index);
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                // Search Field
                                SizedBox(
                                  height: 60.h,
                                  child: TextFormField(
                                    controller: _searchController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: context.isArabic
                                          ? 'بحث...'
                                          : 'Search...',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          ManageVibration.vibrate();
                                          _toggleSearch();
                                        },
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 12.h,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 70.h,
                            child: Row(
                              children: [
                                // Search Icon

                                GestureDetector(
                                  onTap: () {
                                    ManageVibration.vibrate();
                                    _toggleSearch();
                                  },
                                  child: SvgPicture.asset(
                                    Assets.searchIcon,
                                    color: context.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                // Tabs
                                ...List.generate(
                                  4,
                                  (index) {
                                    final labels = [
                                      context.isArabic ? 'متاح' : 'Available',
                                      context.isArabic ? 'مفضلة' : 'Favorite',
                                      context.isArabic ? 'منتهي' : 'Expired',
                                      context.isArabic ? 'فرصي' : 'My Chance',
                                    ];
                                    return Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.w),
                                        child: TabWidget(
                                          title: labels[index],
                                          selected:
                                              _tabController.index == index,
                                          onTap: () {
                                            _tabController.animateTo(index);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                  ),

                  // Categories Section (if visible during search)
                  if (_isCategoriesVisible && _isSearching)
                    _buildCategoriesSection(),

                  // Content Area
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildAvailableTab(state),
                        _buildFavoriteTab(state),
                        _buildExpireTab(state),
                        _buildMyChanceTab(state),
                      ],
                    ),
                  ),
                ],
              ),
              // floatingActionButton: FloatingActionButtonWidget(),
              floatingActionButton: _showFloatingButton
                  ? buildFloatingAction(context,
                      title:
                          "${context.isArabic ? 'اضافة فرصة' : 'Add Chance'} +",
                      () {
                      ManageVibration.vibrate();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<ChanceCubit>(
                            create: (context) => serviceLocator<ChanceCubit>(),
                            child: const CreateChanceView(),
                          ),
                        ),
                      );
                    })
                  : null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 180.h,
      margin: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Image.network(
          'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=800&h=400&fit=crop',
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[200],
              width: 100.w,
              height: 100.h,
              child: Center(
                child: CustomLoading(
                  searchLoading: true,
                  // value: loadingProgress.expectedTotalBytes != null
                  //     ? loadingProgress.cumulativeBytesLoaded /
                  //         loadingProgress.expectedTotalBytes!
                  //     : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[200],
              child: const Center(
                child: Icon(Icons.image_not_supported, size: 40),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    if (_isCategoriesLoading) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        width: 100.w,
        height: 100.h,
        child: const Center(
          child: CustomLoading(
            searchLoading: true,
          ),
        ),
      );
    }

    if (_categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      constraints: BoxConstraints(
        maxHeight: 300.h, // Limit the maximum height
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics:
            const ClampingScrollPhysics(), // Enable scrolling within constraints
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final categoryName =
              context.isArabic ? category.nameAr : category.nameEn;

          return ListTile(
            title: Text(
              categoryName ?? '',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            onTap: () {
              ManageVibration.vibrate();
              // Search by category ID
              context.read<ChanceCubit>().searchChanceAds(category.id);
              setState(() {
                _isCategoriesVisible = false;
                _isSearching = false;
                _searchController.text = categoryName ?? '';
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildAvailableTab(ChanceState state) {
    if (state.isLoading) {
      return Center(
          child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: CustomLoading(
          searchLoading: true,
        ),
      ));
    }

    final List<ChanceAdEntity> ads =
        _isSearching && _searchController.text.isNotEmpty
            ? (state.searchResults ?? [])
            : (state.chanceAds ?? []);

    if (ads.isEmpty) {
      return Center(
        child: Text(
          context.isArabic ? 'لا توجد إعلانات متاحة' : 'No available ads',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: OlxPaginationWidget(
        items: ads.map((ad) => _buildChanceCardFromEntity(ad)).toList(),
        banners: bannersList,
        loadPage: _loadChanceAdsPage,
        scrollController: _availableController,
        itemsPerPage: 5,
      ),
    );
  }

  // Widget _buildFavoriteTab(ChanceState state) {
  //   if (state.isLoading) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   final List<ChanceAdEntity> favoriteAds = state.favoriteChanceAds ?? [];

  //   if (favoriteAds.isEmpty) {
  //     return const Center(
  //       child: Text(
  //         'لا توجد إعلانات مفضلة',
  //         style: TextStyle(fontSize: 16, color: Colors.grey),
  //       ),
  //     );
  //   }

  //   return GlowingOverscrollIndicator(
  //     axisDirection: AxisDirection.down,
  //     color: AppColors.PRIMARY_COLOR_DARK,
  //     child: ListView.builder(
  //       controller: _favoriteController,
  //       itemCount: favoriteAds.length,
  //       itemBuilder: (context, index) {
  //         final ad = favoriteAds[index];
  //         return _buildChanceCardFromEntity(ad, isFavorite: true);
  //       },
  //     ),
  //   );
  // }
  Widget _buildFavoriteTab(ChanceState state) {
    if (state.isLoading) {
      return Center(
          child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: CustomLoading(
          searchLoading: true,
        ),
      ));
    }

    final List<ChanceAdEntity> favoriteAds = state.favoriteChanceAds ?? [];

    if (favoriteAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات مفضلة',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: OlxPaginationWidget(
        items: favoriteAds
            .map((ad) => _buildChanceCardFromEntity(ad, isFavorite: true))
            .toList(),
        banners: bannersList,
        loadPage: (page) async {
          // مفيش API call - البيانات موجودة كلها
          // الويدجت هتقسمها لوحدها
        },
        scrollController: _favoriteController,
        itemsPerPage: 3,
      ),
    );
  }

  // Widget _buildExpireTab(ChanceState state) {
  //   if (state.isLoading) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   final List<ChanceAdEntity> expiredAds = state.expiredChanceAds ?? [];

  //   if (expiredAds.isEmpty) {
  //     return const Center(
  //       child: Text(
  //         'لا توجد إعلانات منتهية',
  //         style: TextStyle(fontSize: 16, color: Colors.grey),
  //       ),
  //     );
  //   }

  //   return GlowingOverscrollIndicator(
  //     axisDirection: AxisDirection.down,
  //     color: AppColors.PRIMARY_COLOR_DARK,
  //     child: ListView.builder(
  //       controller: _expireController,
  //       itemCount: expiredAds.length,
  //       itemBuilder: (context, index) {
  //         final ad = expiredAds[index];
  //         return _buildExpiredChanceCard(ad);
  //       },
  //     ),
  //   );
  // }

  Widget _buildExpireTab(ChanceState state) {
    if (state.isLoading) {
      return Center(
          child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: CustomLoading(
          searchLoading: true,
        ),
      ));
    }

    final List<ChanceAdEntity> expiredAds = state.expiredChanceAds ?? [];

    if (expiredAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات منتهية',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: OlxPaginationWidget(
        items: expiredAds.map((ad) => _buildExpiredChanceCard(ad)).toList(),
        banners: bannersList,
        // loadPage: _loadExpiredAdsPage,
        loadPage: (page) async {
          // مفيش API call - البيانات موجودة كلها
          // الويدجت هتقسمها لوحدها
        },
        scrollController: _expireController,
        itemsPerPage: 3,
      ),
    );
  }

  // Widget _buildMyChanceTab(ChanceState state) {
  //   if (state.isLoading) {
  //     return const Center(child: CircularProgressIndicator());
  //   }

  //   final List<ChanceAdEntity> myAds = state.myChanceAds ?? [];

  //   if (myAds.isEmpty) {
  //     return const Center(
  //       child: Text(
  //         'لا توجد إعلانات خاصة بك',
  //         style: TextStyle(fontSize: 16, color: Colors.grey),
  //       ),
  //     );
  //   }

  //   return GlowingOverscrollIndicator(
  //     axisDirection: AxisDirection.down,
  //     color: AppColors.PRIMARY_COLOR_DARK,
  //     child: ListView.builder(
  //       controller: _myChanceController,
  //       itemCount: myAds.length,
  //       itemBuilder: (context, index) {
  //         final ad = myAds[index];
  //         return _buildChanceCardFromEntity(ad, isMyChance: true);
  //       },
  //     ),
  //   );
  // }

  Widget _buildMyChanceTab(ChanceState state) {
    if (state.isLoading) {
      return Center(
          child: SizedBox(
        width: 100.w,
        height: 100.h,
        child: CustomLoading(
          searchLoading: true,
        ),
      ));
    }

    final List<ChanceAdEntity> myAds = state.myChanceAds ?? [];

    if (myAds.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد إعلانات خاصة بك',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: AppColors.PRIMARY_COLOR_DARK,
      child: OlxPaginationWidget(
        items: myAds
            .map((ad) => _buildChanceCardFromEntity(ad, isMyChance: true))
            .toList(),
        banners: bannersList,
        loadPage: (page) async {
          // مفيش API call - البيانات موجودة كلها
        },
        scrollController: _myChanceController,
        itemsPerPage: 3,
      ),
    );
  }

  Widget _buildChanceCardFromEntity(
    ChanceAdEntity ad, {
    bool isFavorite = false,
    bool isMyChance = false,
  }) {
    final List<String> imageUrls = ad.images.map((img) => img.photo).toList();
    final double progress = ad.totalContributions / ad.price;
    final ChanceStatus status = ad.isComplete
        ? (ad.winnerId != null ? ChanceStatus.winner : ChanceStatus.ended)
        : ChanceStatus.available;

    return _buildChanceCard(
      title: ad.title,
      price: ad.price.toInt(),
      endDate:
          '${context.isArabic ? 'دورة' : 'Cycle'} ${context.isArabic ? FormatNumbers().convertToArabicNumerals(ad.cycle.toString()) : ad.cycle}',
      progress: progress.clamp(0.0, 1.0),
      participants: ad.contributorsCount ?? ad.contributors,
      views: ad.views,
      images: imageUrls.isNotEmpty
          ? imageUrls
          : ['https://via.placeholder.com/400x300'],
      status: status,
      isFavorite: ad.isFavorite, // Use actual favorite status from entity
      isMyChance: isMyChance,
      description: ad.description,
      adId: ad.id,
      chanceAd: ad,
    );
  }

  Widget _buildExpiredChanceCard(ChanceAdEntity ad) {
    final List<String> imageUrls = ad.images.map((img) => img.photo).toList();
    final double progress = ad.totalContributions / ad.price;
    final ChanceStatus status =
        ad.winnerId != null ? ChanceStatus.winner : ChanceStatus.ended;

    // Extract winner name if winnerId is an object
    String? winnerName;
    if (ad.winnerId != null && ad.winnerId is Map<String, dynamic>) {
      final winnerData = ad.winnerId as Map<String, dynamic>;
      final userData = winnerData['userId'] as Map<String, dynamic>?;
      if (userData != null) {
        winnerName =
            '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                .trim();
      }
    }

    return _buildChanceCard(
      title: ad.title,
      price: ad.price.toInt(),
      endDate:
          '${context.isArabic ? 'دورة' : 'Cycle'} ${context.isArabic ? FormatNumbers().convertToArabicNumerals(ad.cycle.toString()) : ad.cycle}',
      progress: progress.clamp(0.0, 1.0),
      participants: ad.contributors,
      views: ad.views,
      images: imageUrls.isNotEmpty
          ? imageUrls
          : ['https://via.placeholder.com/400x300'],
      status: status,
      isFavorite: ad.isFavorite,
      isMyChance: false,
      adId: ad.id,
      chanceAd: ad,
      description: ad.description,
      winnerName:
          winnerName ?? (ad.winnerId != null ? 'Winner Selected' : null),
    );
  }

  Widget _buildChanceCard({
    required String title,
    required int price,
    required String endDate,
    required double progress,
    required int participants,
    required int views,
    required String description,
    required List<String> images,
    required ChanceStatus status,
    String? winnerName,
    bool isFavorite = false,
    bool isMyChance = false,
    String? adId,
    ChanceAdEntity? chanceAd,
  }) {
    return GestureDetector(
      onTap: () async {
        ManageVibration.vibrate();
        // Navigate to chance ad details
        if (adId != null) {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => serviceLocator<ChanceCubit>(),
                // child: ChanceAdDetailsView(chanceAdId: adId),
                child: ChanceDetailView(
                  title: title,
                  price: price,
                  images: images,
                  progress: progress,
                  participants: participants,
                  views: views,
                  description: description,
                  chanceAd: chanceAd,
                ),
              ),
            ),
          );

          // Refresh data when returning from detail view
          _refreshChanceAds();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 28.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Color(0x40000000),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                Container(
                  height: 250.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(24.r)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(16.r)),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 250.h,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        autoPlay: true,
                      ),
                      items: images.map((image) {
                        return Image.network(
                          image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Favorite Icon
                // Positioned(
                //   top: 20.h,
                //   left: 20.w,
                //   child: BlocBuilder<ChanceCubit, ChanceState>(
                //     builder: (context, state) {
                //       // Get updated favorite status from state
                //       bool currentFavoriteStatus = isFavorite;

                //       // Get the latest favorite status from state
                //       if (adId != null) {
                //         try {
                //           ChanceAdEntity? updatedAd;

                //           // Search in all lists
                //           if (state.chanceAds != null) {
                //             try {
                //               updatedAd = state.chanceAds!
                //                   .firstWhere((ad) => ad.id == adId);
                //             } catch (e) {
                //               // Continue searching in other lists
                //             }
                //           }

                //           if (updatedAd == null &&
                //               state.favoriteChanceAds != null) {
                //             try {
                //               updatedAd = state.favoriteChanceAds!
                //                   .firstWhere((ad) => ad.id == adId);
                //             } catch (e) {
                //               // Continue searching in other lists
                //             }
                //           }

                //           if (updatedAd == null &&
                //               state.expiredChanceAds != null) {
                //             try {
                //               updatedAd = state.expiredChanceAds!
                //                   .firstWhere((ad) => ad.id == adId);
                //             } catch (e) {
                //               // Continue searching in other lists
                //             }
                //           }

                //           if (updatedAd == null && state.myChanceAds != null) {
                //             try {
                //               updatedAd = state.myChanceAds!
                //                   .firstWhere((ad) => ad.id == adId);
                //             } catch (e) {
                //               // Ad not found anywhere
                //             }
                //           }

                //           if (updatedAd != null) {
                //             currentFavoriteStatus = updatedAd.isFavorite;
                //           }
                //         } catch (e) {
                //           // Keep original favorite status
                //           currentFavoriteStatus = isFavorite;
                //         }
                //       }

                //       return GestureDetector(
                //         onTap: () async {
                //           ManageVibration.vibrate();
                //           final cubit = context.read<ChanceCubit>();

                //           if (adId != null && adId.isNotEmpty) {
                //             await cubit.toggleChanceAdFavorite(adId);
                //           } else if (chanceAd != null &&
                //               chanceAd.id.isNotEmpty) {
                //             // Fallback to using chanceAd.id if adId is empty
                //             await cubit.toggleChanceAdFavorite(chanceAd.id);
                //           }

                //           // Refresh favorite list if we're in the favorite tab
                //           if (_selectedTabIndex == 1) {
                //             await cubit.getFavoriteChanceAds();
                //           }
                //         },
                //         child: Container(
                //           padding: EdgeInsets.all(8.w),
                //           decoration: BoxDecoration(
                //             color: Colors.white.withOpacity(0.9),
                //             shape: BoxShape.circle,
                //           ),
                //           child: Icon(
                //             currentFavoriteStatus
                //                 ? Icons.favorite
                //                 : Icons.favorite_border,
                //             color: currentFavoriteStatus
                //                 ? Colors.red
                //                 : Colors.grey,
                //             size: 30.sp,
                //           ),
                //         ),
                //       );
                //     },
                //   ),
                // ),

                // Favorite Icon
                Positioned(
                  top: 20.h,
                  left: 20.w,
                  child: BlocBuilder<ChanceCubit, ChanceState>(
                    buildWhen: (previous, current) {
                      // Only rebuild when favorites actually change
                      return previous.favoriteChanceAds !=
                              current.favoriteChanceAds ||
                          previous.chanceAds != current.chanceAds;
                    },
                    builder: (context, state) {
                      // Get updated favorite status from state
                      bool currentFavoriteStatus = isFavorite;

                      if (adId != null) {
                        try {
                          ChanceAdEntity? updatedAd;

                          // Search in all lists
                          if (state.chanceAds != null) {
                            try {
                              updatedAd = state.chanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Continue searching in other lists
                            }
                          }

                          if (updatedAd == null &&
                              state.favoriteChanceAds != null) {
                            try {
                              updatedAd = state.favoriteChanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Continue searching in other lists
                            }
                          }

                          if (updatedAd == null &&
                              state.expiredChanceAds != null) {
                            try {
                              updatedAd = state.expiredChanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Continue searching in other lists
                            }
                          }

                          if (updatedAd == null && state.myChanceAds != null) {
                            try {
                              updatedAd = state.myChanceAds!
                                  .firstWhere((ad) => ad.id == adId);
                            } catch (e) {
                              // Ad not found anywhere
                            }
                          }

                          if (updatedAd != null) {
                            currentFavoriteStatus = updatedAd.isFavorite;
                          }
                        } catch (e) {
                          // Keep original favorite status
                          currentFavoriteStatus = isFavorite;
                        }
                      }

                      return IconAppButton(
                        icon: currentFavoriteStatus
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onPressed: () async {
                          ManageVibration.vibrate();
                          final cubit = context.read<ChanceCubit>();

                          if (adId != null && adId.isNotEmpty) {
                            await cubit.toggleChanceAdFavorite(adId);
                          } else if (chanceAd != null &&
                              chanceAd.id.isNotEmpty) {
                            await cubit.toggleChanceAdFavorite(chanceAd.id);
                          }

                          // Refresh favorite list if we're in the favorite tab
                          if (_selectedTabIndex == 1) {
                            await cubit.getFavoriteChanceAds();
                          }
                        },
                        color: AppColors.SECONDARY_COLOR,
                        size: 60.sp,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.8),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Carousel Indicators
                // if (images.length > 1)
                //   Positioned(
                //     bottom: 12.h,
                //     left: 0,
                //     right: 0,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: images.map((image) {
                //         int index = images.indexOf(image);
                //         return Container(
                //           width: 6.w,
                //           height: 6.h,
                //           margin: EdgeInsets.symmetric(horizontal: 2.w),
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: index == 0
                //                 ? Colors.white
                //                 : Colors.white.withOpacity(0.5),
                //           ),
                //         );
                //       }).toList(),
                //     ),
                //   ),
              ],
            ),
            // Content Section
            Padding(
              padding: EdgeInsets.all(28.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0D141C),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // // description
                  // Text(
                  //   description,
                  // style: TextStyle(
                  //   fontSize: 24.sp,
                  //   fontWeight: FontWeight.w400,
                  //   color: Color(0xff0B1035),
                  // ),
                  // ),
                  // SizedBox(height: 8.h),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.isArabic
                            ? FormatNumbers()
                                .convertToArabicNumerals(price.toString())
                            : price.toString(),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff0B1035),
                        ),
                      ),
                      Sizer(width: 8.w),
                      Text(
                        context.isArabic ? 'جنيه مصري' : 'EGP',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.red_Color_DARK,
                        ),
                      ),
                      Spacer(),
                      Text(
                        endDate,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w400,
                          // color: status == ChanceStatus.available
                          //     ? Colors.orange
                          //     : Colors.grey[600],
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Progress Bar
                  Text(
                    '${context.isArabic ? FormatNumbers().convertToArabicNumerals((progress * 100).toInt().toString()) : (progress * 100).toInt().toString()}% ${context.isArabic ? 'مكتمل' : 'Completed'}',
                    style: TextStyle(
                      fontSize: 24.sp,
                      color: Color(0xff0D141C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      !chanceAd!.isComplete
                          ? AppColors.c0B1035
                          : Color(0xff1EAA61),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Stats and Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${context.isArabic ? FormatNumbers().convertToArabicNumerals(participants.toString()) : participants.toString()} ${context.isArabic ? 'مشارك' : 'Participant'}',
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.cF33D49,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(
                            Assets.eyeChance,
                            width: 20.w,
                            height: 20.h,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            '${context.isArabic ? FormatNumbers().convertToArabicNumerals(_formatViews(views)) : _formatViews(views)} ${context.isArabic ? 'مشاهدة' : 'Views'}',
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      // Action Button
                      GestureDetector(
                        onTap: chanceAd.isComplete
                            ? null // Disable tap when chance is complete
                            : () {
                                ManageVibration.vibrate();
                                if (status == ChanceStatus.winner) {
                                  _showWinnerDialogFromAd(chanceAd);
                                } else if (adId != null) {
                                  final cubit = context.read<ChanceCubit>();
                                  _showJoinDialog(chanceAd, cubit);
                                }
                              },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: chanceAd.isComplete
                                ? Colors.grey // Grey when disabled
                                : (status == ChanceStatus.winner
                                    ? Colors.orange
                                    : Colors.red),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            chanceAd.isComplete
                                ? context.isArabic
                                    ? 'مكتمل'
                                    : 'Completed'
                                : (status == ChanceStatus.winner
                                    ? context.isArabic
                                        ? 'الفائز'
                                        : 'Winner'
                                    : context.isArabic
                                        ? 'انضم الآن'
                                        : 'Join Now'),
                            style: TextStyle(
                              fontSize: 24.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWinnerDialogFromAd(ChanceAdEntity ad) {
    String winnerName = 'Winner';
    String? profilePicture;
    String amount = '0';

    if (ad.winnerId != null && ad.winnerId is Map<String, dynamic>) {
      final winnerData = ad.winnerId as Map<String, dynamic>;
      final userData = winnerData['userId'] as Map<String, dynamic>?;

      if (userData != null) {
        winnerName =
            '${userData['firstName'] ?? ''} ${userData['lastName'] ?? ''}'
                .trim();

        // Get profile picture
        final userProfile = userData['USER_PROFILE'] as Map<String, dynamic>?;
        if (userProfile != null) {
          final profilePictureKey =
              userProfile['profilePictureKey'] as Map<String, dynamic>?;
          if (profilePictureKey != null) {
            profilePicture = profilePictureKey['mediaKey'] as String?;
          }
        }
      }

      // Get amount
      if (winnerData['amount'] != null) {
        amount = winnerData['amount'].toString();
      }
    }

    _showWinnerDialog(winnerName, profilePicture, amount);
  }

  void _showWinnerDialogWithData(String adId) async {
    // Show loading first
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CustomLoading(
          searchLoading: true,
        ),
      ),
    );

    // Get winner data
    final cubit = context.read<ChanceCubit>();
    final winnerData = await cubit.getWinnerData(adId);

    // Close loading dialog
    Navigator.pop(context);

    if (winnerData != null) {
      _showWinnerDialog(
        winnerData['name'] ?? 'Unknown',
        winnerData['profilePicture'],
        winnerData['amount']?.toString() ?? '0',
      );
    } else {
      _showWinnerDialog('Winner', null, '0');
    }
  }

  void _showWinnerDialog(String winnerName,
      [String? profilePicture, String? amount]) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                color: Colors.white.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x40000000),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Winner avatar with crown
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ImageFromInternet(
                              width: 120.w,
                              height: 120.h,
                              image: profilePicture ??
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
                              isCircle: true,
                              firstChar: winnerName[0].toUpperCase(),
                              charPadding: 3,
                            ),
                            Positioned(
                              top: -25.h,
                              right: -2.w,
                              child: SvgPicture.asset(
                                context.isDarkMode
                                    ? Assets.crownIconDark
                                    : Assets.crownIcon,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20.w),
                        // Winner details
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              winnerName,
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              '21/3/2024',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              '${amount ?? '10000'} EGP',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'iPhone 16',
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Close button positioned at top right
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();

                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 30.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }

  void _refreshChanceAds() {
    // Refresh data based on current tab
    final cubit = context.read<ChanceCubit>();

    // Reset pagination when refreshing
    setState(() {
      _lastLoadedPage = 1;
      _lastLoadedFavoritePage = 1;
      _lastLoadedExpiredPage = 1;
      _lastLoadedMyChancePage = 1;
    });

    switch (_tabController.index) {
      case 0: // All Ads
        cubit.getAllChanceAds();
        break;
      case 1: // Favorites
        cubit.getFavoriteChanceAds();
        break;
      case 2: // Expire
        cubit.getExpiredChanceAds();
        break;
      case 3: // My Ads
        cubit.getMyChanceAds();
        break;
      default:
        cubit.getAllChanceAds();
    }
  }

  int _lastLoadedPage = 1;
  int _lastLoadedFavoritePage = 1;
  int _lastLoadedExpiredPage = 1;
  int _lastLoadedMyChancePage = 1;

  Future<void> _loadChanceAdsPage(int page) async {
    // Prevent loading the same page multiple times
    if (page == _lastLoadedPage) return;

    final cubit = context.read<ChanceCubit>();
    await cubit.getAllChanceAds(page: page, limit: 10);
    _lastLoadedPage = page;
  }

  Future<void> _loadFavoriteAdsPage(int page) async {
    if (page == _lastLoadedFavoritePage) return;

    final cubit = context.read<ChanceCubit>();
    await cubit.getFavoriteChanceAds();

    _lastLoadedFavoritePage = page;
  }

  Future<void> _loadExpiredAdsPage(int page) async {
    if (page == _lastLoadedExpiredPage) return;

    final cubit = context.read<ChanceCubit>();
    await cubit.getExpiredChanceAds();

    _lastLoadedExpiredPage = page;
  }

  Future<void> _loadMyChanceAdsPage(int page) async {
    if (page == _lastLoadedMyChancePage) return;

    final cubit = context.read<ChanceCubit>();
    await cubit.getMyChanceAds();

    _lastLoadedMyChancePage = page;
  }

  void _showJoinDialog(ChanceAdEntity chanceAd, ChanceCubit chanceCubit) {
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Padding(
            padding: EdgeInsets.all(28.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نفس الـ UI
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'انضم للفرصة',
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        Navigator.pop(bottomSheetContext);
                      },
                      child: Icon(Icons.close,
                          size: 36.sp, color: Colors.grey[600]),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  chanceAd.title,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'أدخل المبلغ بالجنيه',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 32.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ManageVibration.vibrate();
                      final inputText = amountController.text.trim();
                      final amount = double.tryParse(inputText);

                      if (inputText.isEmpty) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(content: Text('من فضلك أدخل مبلغ')),
                        );
                      } else if (amount == null) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('من فضلك أدخل رقم صحيح')),
                        );
                      } else if (amount < 1) {
                        ScaffoldMessenger.of(bottomSheetContext).showSnackBar(
                          const SnackBar(
                              content: Text('الحد الأدنى للمساهمة 1 جنيه')),
                        );
                      } else {
                        Navigator.pop(bottomSheetContext);

                        // استخدم الـ cubit مباشرة
                        chanceCubit.joinChanceAd(
                          JoinChanceAdParams(
                            adId: chanceAd.id,
                            amount: amount,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      'تأكيد الانضمام',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _searchController.removeListener(_onSearchChanged);
    _tabController.dispose();
    _searchController.dispose();
    _availableController.dispose();
    _favoriteController.dispose();
    _expireController.dispose();
    _myChanceController.dispose();
    super.dispose();
  }
}
