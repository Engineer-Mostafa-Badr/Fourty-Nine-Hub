// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/widgets/subscribe_button_widget.dart';
// import 'package:fourtyninehub/features/star_feature/presentation/widgets/talent_card_widget.dart';
// import 'package:fourtyninehub/helpers/subscription_method.dart';
// import 'package:go_router/go_router.dart';

// import '../../../../ads/native_ad_card.dart';
// import '../../../../common/widgets/dialogs/please_login_dialog.dart';
// import '../../../../common/widgets/dynamic/sizer.dart';
// import '../../../../common/widgets/stateless/labels/label.dart';
// import '../../../../core/extensions/context_extension.dart';
// import '../../../../core/extensions/string_extension.dart';
// import '../../../../core/localization/locale_keys.g.dart';
// import '../../../../core/utils/custom_show_dialog.dart';
// import '../../../../core/widget/custom_loading_search_widget.dart';
// import '../../../../helpers/manage_vibration.dart';
// import '../../../../res/assets/assets.dart';
// import '../../../../res/style/app_colors.dart';
// import '../../../../res/style/styles.dart';
// import '../../../../routes/routes.dart';
// import '../../../../service_locator/service_locator.dart';
// import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
// import '../../domain/entity/star_entity.dart';
// import '../controller/cubit/star_cubit.dart';
// import '../controller/cubit/star_state.dart';
// import 'all_winner_view.dart';
// import '../widgets/floating_action_button_star.dart';
// import '../widgets/sticky_tab_bar_delegate.dart';

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

//   @override
//   void initState() {
//     super.initState();
//     _cubit = context.read<StarCubit>();
//     _tabController = TabController(length: 4, vsync: this);
//     _tabController.addListener(() {
//       setState(() {
//         _selectedTabIndex = _tabController.index;
//       });
//     });
//     _searchController.addListener(_onSearchChanged);
//     _cubit.loadAllTalentsData();
//     _adsManager.preloadAds();
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(),
//       floatingActionButton: context.read<UserCubit>().isLoggedIn
//           ? AnimatedSlide(
//               duration: const Duration(milliseconds: 300),
//               offset: _showFloatingButton ? Offset.zero : const Offset(0, 2),
//               child: AnimatedOpacity(
//                 duration: const Duration(milliseconds: 300),
//                 opacity: _showFloatingButton ? 1.0 : 0.0,
//                 child: const FloatingActionButtonStar(),
//               ),
//             )
//           : null,
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
//               onNotification: (ScrollNotification scrollInfo) {
//                 if (scrollInfo is UserScrollNotification) {
//                   if (scrollInfo.direction == ScrollDirection.reverse) {
//                     if (_showFloatingButton) {
//                       setState(() {
//                         _showFloatingButton = false;
//                       });
//                     }
//                   } else if (scrollInfo.direction == ScrollDirection.forward) {
//                     if (!_showFloatingButton) {
//                       setState(() {
//                         _showFloatingButton = true;
//                       });
//                     }
//                   }
//                 }
//                 return false;
//               },
//               child: CustomScrollView(
//                 slivers: [
//                   //! Collapsible Header Section
//                   SliverAppBar(
//                     expandedHeight: 475.h,
//                     floating: false,
//                     pinned: false,
//                     automaticallyImplyLeading: false,
//                     backgroundColor: Colors.transparent,
//                     flexibleSpace: FlexibleSpaceBar(
//                       background: _buildHeaderSection(state),
//                     ),
//                   ),

//                   //! Sticky Tabs Section
//                   SliverPersistentHeader(
//                     pinned: true,
//                     delegate: StickyTabBarDelegate(
//                       tabController: _tabController,
//                       context: context,
//                       onSearchTap: () {
//                         setState(() {
//                           _isSearching = !_isSearching;
//                           if (!_isSearching) {
//                             _searchController.clear();
//                             _filteredTalents = _cubit.allTalents;
//                           }
//                         });
//                       },
//                     ),
//                   ),

//                   //! Search Bar (when searching)
//                   if (_isSearching) _buildSearchBar(),

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

//   Widget _buildHeaderSection(StarState state) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       child: Column(
//         children: [
//           // Banner Image
//           Container(
//             width: double.infinity,
//             height: 280.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             child: ImageFromInternet(
//               image: state.banner?.banner ?? '',
//               fit: BoxFit.fitWidth,
//             ),
//           ),
//           const Sizer(),

//           // Header Row with Title, Hint, and Subscribe Button
//           Row(
//             // mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               // Title
//               Text(
//                 (state.banner?.titleAr ?? state.banner?.titleEn ?? '')
//                     .toArabicNumbers(context),
//                 textAlign: TextAlign.center,
//                 style: Styles.mediumText(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: context.isDarkMode
//                       ? Colors.white
//                       : AppColors.PRIMARY_COLOR,
//                 ),
//               ),
//               Sizer(),
//               // Hint Button
//               InkWell(
//                 onTap: () => _showHintDialog(),
//                 child: SvgPicture.asset(
//                   Assets.idea,
//                   height: 24,
//                   width: 24,
//                 ),
//               ),
//               // const SizedBox(width: 16),
//               Spacer(),
//               // Subscribe Button
//               SubscribeButton(
//                 text: LocaleKeys.subscribe.localize,
//                 icon: Assets.ideaIcon,
//                 isSelected: true,
//                 onTap: () => _handleSubscribe(),
//                 onShowHint: () => _showSubscribeHint(),
//               ),
//             ],
//           ),
//           const Sizer(),

//           // Subtitle
//           Label(
//             text: (state.banner?.subTitleAr ?? state.banner?.subTitleEn ?? '')
//                 .toArabicNumbers(context),
//             textAlign: TextAlign.center,
//             style: Styles.mediumText(
//               fontSize: 25,
//               fontWeight: FontWeight.w500,
//               color:
//                   context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return SliverToBoxAdapter(
//       child: Container(
//         color: context.isDarkMode ? Colors.black : Colors.white,
//         padding: EdgeInsets.all(16),
//         child: TextField(
//           controller: _searchController,
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: 'Search talents...',
//             prefixIcon: Icon(Icons.search),
//             suffixIcon: IconButton(
//               icon: Icon(Icons.clear),
//               onPressed: () {
//                 _searchController.clear();
//               },
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(color: Colors.grey),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(25),
//               borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
//             ),
//           ),
//         ),
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
//       case 1:
//         return TalentCard.buildFavoriteContentSliver();
//       case 2:
//         return TalentCard.buildHistoryContentSliver(
//           context: context,
//           cubit: _cubit,
//         );
//       case 3:
//         return TalentCard.buildMyTalentContentSliver(
//           context: context,
//           cubit: _cubit,
//         );
//       default:
//         return TalentCard.buildAvailableContentSliver(
//           context: context,
//           cubit: _cubit,
//           isSearching: _isSearching,
//           filteredTalents: _filteredTalents,
//         );
//     }
//   }

//   // Helper methods
//   void _showHintDialog() {
//     ManageVibration.vibrate();
//     showAnimatedDialog(
//       context,
//       AlertDialog(
//         contentPadding: const EdgeInsets.all(0),
//         content: Stack(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               width: double.infinity,
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               child: Image.asset(
//                 Assets.talentGIF,
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             PositionedDirectional(
//               top: 10,
//               start: 10,
//               child: InkWell(
//                 onTap: () {
//                   ManageVibration.vibrate();
//                   context.pop();
//                 },
//                 child: Image.asset(
//                   Assets.close,
//                   height: 24,
//                   width: 24,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleSubscribe() {
//     ManageVibration.vibrate();
//     if (!context.read<UserCubit>().isLoggedIn) {
//       pleaseLoginDialog(context);
//     } else {
//       SubscriptionMethod().subscribe(
//         subscribeId: "67e952dbbb085740a35d4281",
//         title: LocaleKeys.ads.localize,
//       );
//     }
//   }

//   void _showSubscribeHint() {
//     ManageVibration.vibrate();
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Label(
//               text: context.isArabic
//                   ? 'اشترك لإبقاء الصوت في الخلفية'
//                   : 'Subscribe to remain voice in background',
//               style: TextStyle(
//                 color: const Color(0xffFF0808),
//                 fontSize: 25.sp,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       scrolledUnderElevation: 0,
//       titleSpacing: 0,
//       title: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             LocaleKeys.tube.localize,
//             style: TextStyle(
//               color: context.isDarkMode ? Colors.white : Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 32.sp,
//             ),
//           ),
//           // GestureDetector(
//           //   onTap: () {
//           //     ManageVibration.vibrate();
//           //     if (!context.read<UserCubit>().isLoggedIn) {
//           //       pleaseLoginDialog(context);
//           //     } else {
//           //       context.push(Routes.MY_TALENT);
//           //     }
//           //   },
//           //   child: Container(
//           //     margin: EdgeInsets.only(
//           //       right: context.locale.languageCode == 'ar' ? 0 : 40,
//           //       left: context.locale.languageCode == 'ar' ? 40 : 0,
//           //     ),
//           //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
//           //     decoration: BoxDecoration(
//           //       color: AppColors.getButtonPrimaryWhiteColor(context),
//           //       borderRadius: BorderRadius.circular(10),
//           //     ),
//           //     child: Align(
//           //       alignment: Alignment.center,
//           //       child: Text(
//           //         LocaleKeys.myTalent.localize,
//           //         style: TextStyle(
//           //           color: context.isDarkMode
//           //               ? AppColors.PRIMARY_COLOR
//           //               : Colors.white,
//           //           fontWeight: FontWeight.bold,
//           //           fontSize: 28.sp,
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//       actions: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           child: GestureDetector(
//             onTap: () {
//               ManageVibration.vibrate();
//               Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (context) => BlocProvider(
//                     create: (context) => serviceLocator<StarCubit>(),
//                     child: const AllWinnerView(),
//                   ),
//                 ),
//               );
//             },
//             child: Row(
//               children: [
//                 Text(
//                   LocaleKeys.winners.localize,
//                   style: TextStyle(
//                     color: context.isDarkMode ? Colors.white : Colors.black,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 32.sp,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 Image.asset(Assets.winners),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
// }

//!

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
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
  List<StarEntity> _filteredTalents = [];

  // Add these variables to track video details view state
  StarEntity? _selectedVideoTalent;
  String? _selectedVideoUrl;
  bool _showVideoDetails = false;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<StarCubit>();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
        // Reset video details view when switching tabs
        if (_selectedTabIndex != 3) {
          _showVideoDetails = false;
          _selectedVideoTalent = null;
          _selectedVideoUrl = null;
        }
      });
    });
    _searchController.addListener(_onSearchChanged);
    _cubit.loadAllTalentsData();
    _adsManager.preloadAds();
  }

  void _onSearchChanged() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filteredTalents = _cubit.allTalents;
      } else {
        _filteredTalents = _cubit.allTalents.where((talent) {
          return talent.title
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              talent.user.firstName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              talent.user.lastName
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  // Add method to handle video selection
  void _onVideoSelected(StarEntity talent, String mediaUrl) {
    setState(() {
      _selectedVideoTalent = talent;
      _selectedVideoUrl = mediaUrl;
      _showVideoDetails = true;
    });
  }

  // Add method to go back from video details
  void _onBackFromVideoDetails() {
    setState(() {
      _showVideoDetails = false;
      _selectedVideoTalent = null;
      _selectedVideoUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: context.read<UserCubit>().isLoggedIn
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: _showFloatingButton ? Offset.zero : const Offset(0, 2),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showFloatingButton ? 1.0 : 0.0,
                child: const FloatingActionButtonStar(),
              ),
            )
          : null,
      body: BlocBuilder<StarCubit, StarState>(
        builder: (BuildContext context, state) {
          if (state.status == StarStates.loading && _cubit.allTalents.isEmpty) {
            return const CustomLoadingSearchWidget();
          }

          return RefreshIndicator(
            color: AppColors.getTextColor(context),
            backgroundColor: AppColors.getFindFillColor(context),
            onRefresh: () async =>
                context.read<StarCubit>().getAllTalent(refresh: true),
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
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
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  //! Collapsible Header Section
                  SliverAppBar(
                    expandedHeight: 475.h,
                    floating: false,
                    pinned: false,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildHeaderSection(state),
                    ),
                  ),

                  //! Sticky Tabs Section
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: StickyTabBarDelegate(
                      tabController: _tabController,
                      context: context,
                      onSearchTap: () {
                        setState(() {
                          _isSearching = !_isSearching;
                          if (!_isSearching) {
                            _searchController.clear();
                            _filteredTalents = _cubit.allTalents;
                          }
                        });
                      },
                    ),
                  ),

                  //! Search Bar (when searching)
                  if (_isSearching) _buildSearchBar(),

                  //! Tab Content - Based on selected tab
                  _buildSelectedTabContent(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(StarState state) {
    return Container(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Banner Image
          Container(
            width: double.infinity,
            height: 280.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: ImageFromInternet(
              image: state.banner?.banner ?? '',
              fit: BoxFit.fitWidth,
            ),
          ),
          const Sizer(),

          // Header Row with Title, Hint, and Subscribe Button
          Row(
            children: [
              // Title
              Text(
                (state.banner?.titleAr ?? state.banner?.titleEn ?? '')
                    .toArabicNumbers(context),
                textAlign: TextAlign.center,
                style: Styles.mediumText(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR,
                ),
              ),
              Sizer(),
              // Hint Button
              InkWell(
                onTap: () => _showHintDialog(),
                child: SvgPicture.asset(
                  Assets.idea,
                  height: 24,
                  width: 24,
                ),
              ),
              Spacer(),
              // Subscribe Button
              SubscribeButton(
                text: LocaleKeys.subscribe.localize,
                icon: Assets.ideaIcon,
                isSelected: true,
                onTap: () => _handleSubscribe(),
                onShowHint: () => _showSubscribeHint(),
              ),
            ],
          ),
          const Sizer(),

          // Subtitle
          Label(
            text: (state.banner?.subTitleAr ?? state.banner?.subTitleEn ?? '')
                .toArabicNumbers(context),
            textAlign: TextAlign.center,
            style: Styles.mediumText(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Container(
        color: context.isDarkMode ? Colors.black : Colors.white,
        padding: EdgeInsets.all(16),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search talents...',
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: AppColors.PRIMARY_COLOR),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return TalentCard.buildAvailableContentSliver(
          context: context,
          cubit: _cubit,
          isSearching: _isSearching,
          filteredTalents: _filteredTalents,
        );
      case 1:
        return TalentCard.buildFavoriteContentSliver();
      case 2:
        return TalentCard.buildHistoryContentSliver(
          context: context,
          cubit: _cubit,
        );
      case 3:
        // Modified: Show VideoDetailsView if video is selected, otherwise show list
        if (_showVideoDetails &&
            _selectedVideoTalent != null &&
            _selectedVideoUrl != null) {
          return SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  200, // Adjust height as needed
              child: VideoDetailsView(
                talent: _selectedVideoTalent!,
                mediaUrl: _selectedVideoUrl!,
                onBack: _onBackFromVideoDetails, // Pass back callback
              ),
            ),
          );
        } else {
          return TalentCard.buildMyTalentContentSliver(
            context: context,
            cubit: _cubit,
            onVideoTap: _onVideoSelected, // Pass video selection callback
          );
        }
      default:
        return TalentCard.buildAvailableContentSliver(
          context: context,
          cubit: _cubit,
          isSearching: _isSearching,
          filteredTalents: _filteredTalents,
        );
    }
  }

  // Helper methods remain the same...
  void _showHintDialog() {
    ManageVibration.vibrate();
    showAnimatedDialog(
      context,
      AlertDialog(
        contentPadding: const EdgeInsets.all(0),
        content: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(
                Assets.talentGIF,
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.cover,
              ),
            ),
            PositionedDirectional(
              top: 10,
              start: 10,
              child: InkWell(
                onTap: () {
                  ManageVibration.vibrate();
                  context.pop();
                },
                child: Image.asset(
                  Assets.close,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubscribe() {
    ManageVibration.vibrate();
    if (!context.read<UserCubit>().isLoggedIn) {
      pleaseLoginDialog(context);
    } else {
      SubscriptionMethod().subscribe(
        subscribeId: "67e952dbbb085740a35d4281",
        title: LocaleKeys.ads.localize,
      );
    }
  }

  void _showSubscribeHint() {
    ManageVibration.vibrate();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Label(
              text: context.isArabic
                  ? 'اشترك لإبقاء الصوت في الخلفية'
                  : 'Subscribe to remain voice in background',
              style: TextStyle(
                color: const Color(0xffFF0808),
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.tube.localize,
            style: TextStyle(
              color: context.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32.sp,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GestureDetector(
            onTap: () {
              ManageVibration.vibrate();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => serviceLocator<StarCubit>(),
                    child: const AllWinnerView(),
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Text(
                  LocaleKeys.winners.localize,
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32.sp,
                  ),
                ),
                const SizedBox(width: 4),
                Image.asset(Assets.winners),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
