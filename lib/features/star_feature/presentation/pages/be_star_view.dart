import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
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
import '../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../helpers/manage_vibration.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entity/star_entity.dart';
import '../controller/cubit/star_cubit.dart';
import '../controller/cubit/star_state.dart';
import 'all_winner_view.dart';
import '../widgets/floating_action_button_star.dart';
import '../widgets/sticky_tab_bar_delegate.dart';

// class BeStarView extends StatefulWidget {
//   const BeStarView({super.key});

//   @override
//   _BeStarViewState createState() => _BeStarViewState();
// }

// class _BeStarViewState extends State<BeStarView> with TickerProviderStateMixin {
//   late StarCubit _cubit;
//   late TabController _tabController;
//   bool _showFloatingButton = true;
//   final AdsManager _adsManager = AdsManager();
//   int _selectedTabIndex = 0;
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();
//   List<StarEntity> _filteredTalents = [];

//   // Video details view state
//   StarEntity? _selectedVideoTalent;
//   String? _selectedVideoUrl;
//   bool _showVideoDetails = false;

//   @override
//   void initState() {
//     super.initState();
//     _cubit = context.read<StarCubit>();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(_onTabChanged);
//     _searchController.addListener(_onSearchChanged);
//     _cubit.loadAllTalentsData();
//     _adsManager.preloadAds();
//   }

//   void _onTabChanged() {
//     setState(() {
//       _selectedTabIndex = _tabController.index;
//       // Reset video details view when switching tabs
//       if (_selectedTabIndex != 3) {
//         _showVideoDetails = false;
//         _selectedVideoTalent = null;
//         _selectedVideoUrl = null;
//       }
//     });
//   }

//   void _onSearchChanged() {
//     setState(() {
//       if (_searchController.text.isEmpty) {
//         _filteredTalents = _cubit.allTalents;
//       } else {
//         _filteredTalents = _cubit.allTalents.where((talent) {
//           return talent.title
//                   .toLowerCase()
//                   .contains(_searchController.text.toLowerCase()) ||
//               talent.user.firstName
//                   .toLowerCase()
//                   .contains(_searchController.text.toLowerCase()) ||
//               talent.user.lastName
//                   .toLowerCase()
//                   .contains(_searchController.text.toLowerCase());
//         }).toList();
//       }
//     });
//   }

//   void _onVideoSelected(StarEntity talent, String mediaUrl) {
//     setState(() {
//       _selectedVideoTalent = talent;
//       _selectedVideoUrl = mediaUrl;
//       _showVideoDetails = true;
//     });
//   }

//   void _onBackFromVideoDetails() {
//     setState(() {
//       _showVideoDetails = false;
//       _selectedVideoTalent = null;
//       _selectedVideoUrl = null;
//     });
//   }

//   void _toggleSearch() {
//     setState(() {
//       _isSearching = !_isSearching;
//       if (!_isSearching) {
//         _searchController.clear();
//         _filteredTalents = _cubit.allTalents;
//       }
//     });
//   }

//   void _onScrollNotification(ScrollNotification scrollInfo) {
//     if (scrollInfo is UserScrollNotification) {
//       if (scrollInfo.direction == ScrollDirection.reverse) {
//         if (_showFloatingButton) {
//           setState(() {
//             _showFloatingButton = false;
//           });
//         }
//       } else if (scrollInfo.direction == ScrollDirection.forward) {
//         if (!_showFloatingButton) {
//           setState(() {
//             _showFloatingButton = true;
//           });
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BeStarAppBar(),
//       floatingActionButton: BeStarFloatingButton(
//         showButton: _showFloatingButton,
//         isLoggedIn: context.read<UserCubit>().isLoggedIn,
//       ),
//       body: BlocBuilder<StarCubit, StarState>(
//         builder: (BuildContext context, state) {
//           if (state.status == StarStates.loading && _cubit.allTalents.isEmpty) {
//             return const CustomLoadingSearchWidget();
//           }

//           return RefreshIndicator(
//             color: AppColors.getTextColor(context),
//             backgroundColor: AppColors.getFindFillColor(context),
//             onRefresh: () async =>
//                 context.read<StarCubit>().getAllTalent(refresh: true),
//             child: NotificationListener<ScrollNotification>(
//               onNotification: (scrollInfo) {
//                 _onScrollNotification(scrollInfo);
//                 return false;
//               },
//               child: CustomScrollView(
//                 slivers: [
//                   //! Collapsible Header Section
//                   SliverAppBar(
//                     expandedHeight: context.isArabic
//                         ? MediaQuery.sizeOf(context).height * 0.3759
//                         : MediaQuery.sizeOf(context).height * 0.375,
//                     floating: false,
//                     pinned: false,
//                     automaticallyImplyLeading: false,
//                     backgroundColor: Colors.transparent,
//                     flexibleSpace: FlexibleSpaceBar(
//                       background: BeStarHeaderSection(state: state),
//                     ),
//                   ),

//                   //! Sticky Tabs Section
//                   SliverPersistentHeader(
//                     pinned: true,
//                     delegate: StickyTabBarDelegate(
//                       tabController: _tabController,
//                       context: context,
//                       onSearchTap: _toggleSearch,
//                     ),
//                   ),

//                   //! Search Bar (when searching)
//                   if (_isSearching)
//                     BeStarSearchBar(
//                       controller: _searchController,
//                     ),

//                   //! Tab Content - Based on selected tab
//                   _buildSelectedTabContent(),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSelectedTabContent() {
//     switch (_selectedTabIndex) {
//       case 0:
//         return TalentCard.buildAvailableContentSliver(
//           context: context,
//           cubit: _cubit,
//           isSearching: _isSearching,
//           filteredTalents: _filteredTalents,
//         );
//       // return SliverToBoxAdapter(
//       //   child: SizedBox(
//       //     height: MediaQuery.of(context).size.height - 200,
//       //     child: TalentCard.buildAvailableContentSliver(
//       //       context: context,
//       //       cubit: _cubit,
//       //       isSearching: _isSearching,
//       //       filteredTalents: _filteredTalents,
//       //     ),
//       //   ),
//       // );
//       case 1:
//         return TalentCard.buildFavoriteContentSliver(
//           context: context,
//           cubit: _cubit,
//         );
//       case 2:
//         return TalentCard.buildHistoryContentSliver(
//           context: context,
//           cubit: _cubit,
//         );
//       case 3:
//         // Show VideoDetailsView if video is selected, otherwise show list
//         if (_showVideoDetails &&
//             _selectedVideoTalent != null &&
//             _selectedVideoUrl != null) {
//           return SliverToBoxAdapter(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height - 200,
//               child: VideoDetailsView(
//                 talent: _selectedVideoTalent!,
//                 mediaUrl: _selectedVideoUrl!,
//                 onBack: _onBackFromVideoDetails,
//               ),
//             ),
//           );
//         } else {
//           return TalentCard.buildMyTalentContentSliver(
//             context: context,
//             cubit: _cubit,
//             onVideoTap: _onVideoSelected,
//           );
//         }
//       default:
//         return TalentCard.buildAvailableContentSliver(
//           context: context,
//           cubit: _cubit,
//           isSearching: _isSearching,
//           filteredTalents: _filteredTalents,
//         );
//     }
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
// }

//!
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
  final TextEditingController _searchController = TextEditingController();

  // Video details view state for My Talent tab
  StarEntity? _selectedVideoTalent;
  String? _selectedVideoUrl;
  bool _showVideoDetails = false;

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
    });

    // Load data for the selected tab if needed
    final category = _getTabCategory(_selectedTabIndex);
    if (category != null) {
      _cubit.loadTalents(category);
    }
  }

  TalentCategory? _getTabCategory(int tabIndex) {
    switch (tabIndex) {
      case 0: return TalentCategory.available;
      case 1: return TalentCategory.favorites;
      case 2: return TalentCategory.history;
      case 3: return TalentCategory.myTalents;
      default: return null;
    }
  }

  void _onSearchChanged() {
    _cubit.searchTalents(_searchController.text);
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
        _searchController.clear();
        _cubit.searchTalents(''); // Clear search results
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
      appBar: BeStarAppBar(),
      floatingActionButton: BeStarFloatingButton(
        showButton: _showFloatingButton,
        isLoggedIn: context.read<UserCubit>().isLoggedIn,
      ),
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          if (state.status == StarStates.loading && state.availableTalents.isEmpty) {
            return const CustomLoadingSearchWidget();
          }

          return RefreshIndicator(
            color: AppColors.getTextColor(context),
            backgroundColor: AppColors.getFindFillColor(context),
            onRefresh: () async {
              final category = _getTabCategory(_selectedTabIndex);
              if (category != null) {
                await _cubit.loadTalents(category, refresh: true);
              }
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                _onScrollNotification(scrollInfo);
                
                // Load more data when reaching end
                if (scrollInfo is ScrollEndNotification && 
                    scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
                  final category = _getTabCategory(_selectedTabIndex);
                  if (category != null && !_isSearching) {
                    _cubit.loadTalents(category);
                  }
                }
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  // Collapsible Header Section
                  SliverAppBar(
                    expandedHeight: context.isArabic
                        ? MediaQuery.sizeOf(context).height * 0.3759
                        : MediaQuery.sizeOf(context).height * 0.375,
                    floating: false,
                    pinned: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: BeStarHeaderSection(state: state),
                    ),
                  ),

                  // Sticky Tabs Section
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
                    ),

                  // Tab Content - Using new unified content widget
                  BeStarTabContent(
                    selectedTabIndex: _selectedTabIndex,
                    context: context,
                    cubit: _cubit,
                    isSearching: _isSearching,
                    showVideoDetails: _showVideoDetails,
                    selectedVideoTalent: _selectedVideoTalent,
                    selectedVideoUrl: _selectedVideoUrl,
                    onBackFromVideoDetails: _onBackFromVideoDetails,
                    onVideoSelected: _onVideoSelected,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
