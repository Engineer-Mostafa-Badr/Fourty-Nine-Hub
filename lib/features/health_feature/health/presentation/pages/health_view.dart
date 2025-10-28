import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_types.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/booking_history_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/current_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/most_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/my_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/current_history_booking.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_mode_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/registration_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/pages/health_favorites_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/ads_request_log_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/favourite_ads_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ads_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../service_locator/service_locator.dart';

class HealthView extends StatefulWidget {
  const HealthView({super.key});

  @override
  State<HealthView> createState() => _HealthViewState();
}

class _HealthViewState extends State<HealthView> {
  bool _showMost = false;
  bool _showHistory = false;
  bool _showCurrent = false;
  bool _showMyBookings = false;

  bool _showFavoriteAds = false;
  bool _showHealthFavorites = false;

  bool _showRequestLog = false;
  bool _showMyAds = false;

  // Search functionality
  bool _showSearchField = false;
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearchText = false;

  // Second search functionality (for ads section)
  bool _showAdsSearchField = false;
  final TextEditingController _adsSearchController = TextEditingController();
  bool _hasAdsSearchText = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
    _adsSearchController.addListener(_onAdsSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    _adsSearchController.removeListener(_onAdsSearchTextChanged);
    _adsSearchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    setState(() {
      _hasSearchText = _searchController.text.isNotEmpty;
    });
  }

  void _onAdsSearchTextChanged() {
    setState(() {
      _hasAdsSearchText = _adsSearchController.text.isNotEmpty;
    });
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      // Show message for empty search
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.isArabic
                ? 'يرجى إدخال نص للبحث'
                : 'Please enter search text',
          ),
          backgroundColor: AppColors.SECONDARY_COLOR,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    ManageVibration.vibrate();

    // Here you can implement your search logic
    // For now, we'll just print the search query
    print('Searching for: $query');

    // Navigate to search results page
    context.push(Routes.VISITADOCTORLIST,
        extra: DoctorsListParams(
            fromHome: true,
            subCategoryId: '',
            name: query.trim(),
            fromSearch: true));
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(
    //       context.isArabic
    //           ? 'البحث عن: $query'
    //           : 'Searching for: $query',
    //     ),
    //     backgroundColor: AppColors.SECONDARY_COLOR,
    //     duration: const Duration(seconds: 2),
    //   ),
    // );
    // context.read<HealthCubit>().searchBookings(query);
  }

  void _performAdsSearch(String query) {
    if (query.trim().isEmpty) return;

    ManageVibration.vibrate();

    // Here you can implement your ads search logic
    // For now, we'll just print the search query
    print('Searching ads for: $query');

    // You can add ads search functionality here, such as:
    // - Filter favorite ads
    // - Search in request log
    // - Search in my ads
    // - Call API for ads search results

    // Example: Show a snackbar with the search query
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.isArabic
              ? 'البحث في الإعلانات عن: $query'
              : 'Searching ads for: $query',
        ),
        backgroundColor: AppColors.SECONDARY_COLOR,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocBuilder<HealthCubit, HealthState>(
        builder: (context, state) {
          return GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: AppColors.SECONDARY_COLOR,
            child: ListView(
              // padding: EdgeInsets.all(16.0.w),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: HealthBanner(),
                ),
                Sizer(),
                state.isDoctor == false
                    ? const RegistrationBanner()
                    : DoctorModeBanner(
                        isApproval: state.isApproved ?? false,
                      ),
                if (state.isApproved == false) WaitingAprovalText(),
                Sizer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const SizedBox(width: 16),

                      // Search Icon
                      GestureDetector(
                        onTap: () {
                          ManageVibration.vibrate();
                          setState(() {
                            _showSearchField = !_showSearchField;
                            if (!_showSearchField) {
                              _searchController.clear();
                              _hasSearchText = false;
                            }
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: _showSearchField
                                ? AppColors.SECONDARY_COLOR.withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.search,
                            size: 24,
                            color: _showSearchField
                                ? AppColors.SECONDARY_COLOR
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Search Buttons (appear in row when typing)
                      if (_showSearchField && _hasSearchText) ...[
                        // Clear Button
                        GestureDetector(
                          onTap: () {
                            ManageVibration.vibrate();
                            _searchController.clear();
                            _hasSearchText = false;
                            setState(() {});
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.clear,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],

                      /// Most Booking
                      CurrentHistoryBooking(
                        title: LocaleKeys.mostBooking.localize,
                        isSelected: _showMost,
                        onTap: () {
                          ManageVibration.vibrate();
                          if (!context.read<UserCubit>().isLoggedIn) {
                            pleaseLoginDialog(context);
                          } else {
                            _toggleView('most');
                          }
                        },
                      ),
                      const SizedBox(width: 8),

                      /// History
                      CurrentHistoryBooking(
                        title:
                            context.isArabic ? 'سجل حجوزات' : 'Booking History',
                        isSelected: _showHistory,
                        onTap: () {
                          ManageVibration.vibrate();
                          if (!context.read<UserCubit>().isLoggedIn) {
                            return pleaseLoginDialog(context);
                          } else {
                            _toggleView('history');
                          }
                        },
                      ),
                      const SizedBox(width: 8),

                      /// Current Booking
                      CurrentHistoryBooking(
                        title: context.isArabic
                            ? 'حجوزات حالية'
                            : 'Current Booking',
                        isSelected: _showCurrent,
                        onTap: () {
                          ManageVibration.vibrate();
                          if (!context.read<UserCubit>().isLoggedIn) {
                            return pleaseLoginDialog(context);
                          } else {
                            _toggleView('current');
                          }
                        },
                      ),
                      const SizedBox(width: 8),

                      /// My Booking
                      CurrentHistoryBooking(
                        title: context.isArabic ? 'حجوزاتي' : 'My Booking',
                        isSelected: _showMyBookings,
                        onTap: () {
                          ManageVibration.vibrate();
                          if (!context.read<UserCubit>().isLoggedIn) {
                            return pleaseLoginDialog(context);
                          } else {
                            _toggleView('myBookings');
                          }
                        },
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),

                // Search Field
                if (_showSearchField) ...[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 16.h),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.getFillColor(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.SECONDARY_COLOR.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: TextStyle(
                                color: AppColors.getTextColor(context),
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: context.isArabic
                                    ? 'ابحث عن الأطباء أو الخدمات...'
                                    : 'Search doctors or services...',
                                hintStyle: TextStyle(
                                  color: AppColors.getTextColor(context)
                                      .withOpacity(0.6),
                                  fontSize: 16,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.SECONDARY_COLOR,
                                  size: 20,
                                ),
                              ),
                              textInputAction: TextInputAction.search,
                              onChanged: (value) => setState(
                                  () => _hasSearchText = value.isNotEmpty),
                              onSubmitted: (value) {
                                if (value.isNotEmpty) {
                                  _performSearch(value);
                                }
                              },
                            ),
                          ),
                          if (_hasSearchText)
                            Padding(
                              padding: const EdgeInsets.only(right: 8, left: 8),
                              child: GestureDetector(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  _performSearch(_searchController.text);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.SECONDARY_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const Sizer(height: 16),
                ],

                Sizer(height: 20),

                // Default view when none are selected
                if (!_showMost &&
                    !_showHistory &&
                    !_showCurrent &&
                    !_showMyBookings) ...[
                  Column(
                    children: [
                      const HealthBookingTypesWidgt(),
                      const Sizer(),
                      const HealthSubCategories(),
                      const Sizer(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                ManageVibration.vibrate();
                                setState(() {
                                  _showAdsSearchField = !_showAdsSearchField;
                                  if (!_showAdsSearchField) {
                                    _adsSearchController.clear();
                                    _hasAdsSearchText = false;
                                  }
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: _showAdsSearchField
                                      ? AppColors.SECONDARY_COLOR
                                          .withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.search,
                                  size: 24,
                                  color: _showAdsSearchField
                                      ? AppColors.SECONDARY_COLOR
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Ads Search Buttons (appear in row when typing)
                            if (_showAdsSearchField && _hasAdsSearchText) ...[
                              // Clear Button
                              GestureDetector(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  _adsSearchController.clear();
                                  _hasAdsSearchText = false;
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Search Submit Button
                              GestureDetector(
                                onTap: () {
                                  ManageVibration.vibrate();
                                  _performAdsSearch(_adsSearchController.text);
                                },
                                child: Container(
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: AppColors.SECONDARY_COLOR,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.SECONDARY_COLOR
                                            .withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        context.isArabic ? 'بحث' : 'Search',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],

                            /// Favourite Ads
                            CurrentHistoryBooking(
                              title: LocaleKeys.favouriteAds.localize,
                              isSelected: _showFavoriteAds,
                              onTap: () {
                                if (!context.read<UserCubit>().isLoggedIn) {
                                  pleaseLoginDialog(context);
                                } else {
                                  _toggleAdsView('favouriteAds');
                                }
                              },
                            ),
                            const SizedBox(width: 8),

                            /// Health Favorites
                            CurrentHistoryBooking(
                              title: context.isArabic
                                  ? 'المفضلة الصحية'
                                  : 'Health Favorites',
                              isSelected: _showHealthFavorites,
                              onTap: () {
                                ManageVibration.vibrate();
                                if (!context.read<UserCubit>().isLoggedIn) {
                                  return pleaseLoginDialog(context);
                                } else {
                                  _toggleHealthFavorites();
                                }
                              },
                            ),
                            const SizedBox(width: 8),

                            /// Request Log
                            CurrentHistoryBooking(
                              title: LocaleKeys.requestLog.localize,
                              isSelected: _showRequestLog,
                              onTap: () {
                                ManageVibration.vibrate();
                                if (!context.read<UserCubit>().isLoggedIn) {
                                  return pleaseLoginDialog(context);
                                } else {
                                  _toggleAdsView('requestLog');
                                }
                              },
                            ),
                            const SizedBox(width: 8),

                            /// My Ads
                            CurrentHistoryBooking(
                              title: LocaleKeys.myAds.localize,
                              isSelected: _showMyAds,
                              onTap: () {
                                ManageVibration.vibrate();
                                if (!context.read<UserCubit>().isLoggedIn) {
                                  return pleaseLoginDialog(context);
                                } else {
                                  _toggleAdsView('myAds');
                                }
                              },
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),

                      // Ads Search Field
                      if (_showAdsSearchField) ...[
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.getFillColor(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    AppColors.SECONDARY_COLOR.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _adsSearchController,
                                    style: TextStyle(
                                      color: AppColors.getTextColor(context),
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: context.isArabic
                                          ? 'ابحث في الإعلانات...'
                                          : 'Search in ads...',
                                      hintStyle: TextStyle(
                                        color: AppColors.getTextColor(context)
                                            .withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search,
                                        color: AppColors.SECONDARY_COLOR,
                                        size: 20,
                                      ),
                                    ),
                                    textInputAction: TextInputAction.search,
                                    onChanged: (value) => setState(() =>
                                        _hasAdsSearchText = value.isNotEmpty),
                                    onSubmitted: (value) {
                                      if (value.isNotEmpty) {
                                        _performAdsSearch(value);
                                      }
                                    },
                                  ),
                                ),
                                if (_hasAdsSearchText)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        ManageVibration.vibrate();
                                        _performAdsSearch(
                                            _adsSearchController.text);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.SECONDARY_COLOR,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const Sizer(height: 16),
                      ],

                      const Sizer(height: 8),
                      if (!_showFavoriteAds &&
                          !_showRequestLog &&
                          !_showMyAds &&
                          !_showMyBookings &&
                          !_showHealthFavorites) ...[
                        const HealthMedicalServices(),
                        const Sizer(),
                        const HealthBookings(),
                        const Sizer(),
                      ],
                      if (_showFavoriteAds)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: FavouriteAdsView(
                            id: '62c8b57c9332225799fe3306',
                            isFloatingButtonVisible: (p0) {},
                          ),
                        ),
                      if (_showHealthFavorites)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: const HealthFavoritesView(),
                        ),
                      if (_showRequestLog)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: AdsRequestLogView(
                            mainCategoryId: '62c8b57c9332225799fe3306',
                            isFloatingButtonVisible: (p0) {},
                          ),
                        ),
                      if (_showMyAds)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.7,
                          child: MyAdsView(
                            id: '62c8b57c9332225799fe3306',
                            isFloatingButtonVisible: (p0) {},
                          ),
                        ),
                    ],
                  ),
                ],

                // Current Booking view
                if (_showCurrent)
                  BlocProvider(
                    create: (context) => serviceLocator<HealthCubit>(
                        // Pass your dependencies here
                        )
                      ..loadInitialBooking('current'),
                    child: CurrentBookingsScreen(
                      onClose: () => setState(() => _showCurrent = false),
                    ),
                  ),

                // History view
                if (_showHistory)
                  BlocProvider(
                    create: (context) => serviceLocator<HealthCubit>()
                      ..loadInitialBooking('history'),
                    child: BookingHistoryScreen(
                      onClose: () => setState(() => _showHistory = false),
                    ),
                  ),

                // Favourite Ads view
                if (_showMost)
                  BlocProvider(
                    key: const ValueKey('MostBookingScreen'),
                    create: (context) =>
                        serviceLocator<HealthCubit>()..loadInitialMostBooking(),
                    child: MostBookingScreen(
                      onClose: () => setState(() => _showMost = false),
                    ),
                  ),
                if (_showMyBookings)
                  BlocProvider(
                    key: const ValueKey('MyBookingScreen'),
                    create: (context) =>
                        serviceLocator<HealthCubit>()..loadInitialMyBookings(),
                    child: MyBookingScreen(
                      onClose: () => setState(() => _showMyBookings = false),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget WaitingAprovalText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.h, 5.h, 20.h, 0),
      child: Row(
        children: [
          Expanded(child: Container()),
          Text(
            LocaleKeys.waitingApproval.localize,
            style: Styles.headerText(
              color: AppColors.SECONDARY_COLOR,
              fontSize: 30,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  void _toggleAdsView(String viewType) {
    setState(() {
      if (viewType == 'favouriteAds') {
        _showFavoriteAds = !_showFavoriteAds;

        if (_showFavoriteAds) {
          _showRequestLog = false;
          _showMyAds = false;
          _showHealthFavorites = false;
          context
              .read<SubcategoriesCubit>()
              .loadMyFavouriteAds(id: '62c8b57c9332225799fe3306');
        }
      } else if (viewType == 'requestLog') {
        _showRequestLog = !_showRequestLog;
        if (_showRequestLog) {
          _showFavoriteAds = false;
          _showMyAds = false;
          _showHealthFavorites = false;
          context
              .read<SubcategoriesCubit>()
              .loadRequestsLog(id: '62c8b57c9332225799fe3306');
        }
      } else if (viewType == 'myAds') {
        _showMyAds = !_showMyAds;
        if (_showMyAds) {
          _showFavoriteAds = false;
          _showRequestLog = false;
          _showHealthFavorites = false;
          context
              .read<SubcategoriesCubit>()
              .loadMyAds(id: '62c8b57c9332225799fe3306');
        }
      }
    });
  }

  void _toggleHealthFavorites() {
    setState(() {
      _showHealthFavorites = !_showHealthFavorites;
      if (_showHealthFavorites) {
        _showFavoriteAds = false;
        _showRequestLog = false;
        _showMyAds = false;
        _showMost = false;
        _showHistory = false;
        _showCurrent = false;
        _showMyBookings = false;
      }
    });
  }

  // When buttons are clicked:
  void _toggleView(String viewType) {
    final cubit = context.read<HealthCubit>();

    setState(() {
      if (viewType == 'most') {
        _showMost = !_showMost;
        if (_showMost) {
          _showHistory = false;
          _showCurrent = false;
          _showMyBookings = false;
        }
      } else if (viewType == 'history') {
        _showHistory = !_showHistory;
        if (_showHistory) {
          _showMost = false;
          _showCurrent = false;
          _showMyBookings = false;
          cubit.switchBookingType('history');
        }
      } else if (viewType == 'current') {
        _showCurrent = !_showCurrent;
        if (_showCurrent) {
          _showMost = false;
          _showHistory = false;
          _showMyBookings = false;
          cubit.switchBookingType('current');
        }
      } else if (viewType == 'myBookings') {
        _showMyBookings = !_showMyBookings;
        if (_showCurrent) {
          _showMost = false;
          _showHistory = false;
          _showCurrent = false;
          cubit.switchBookingType('myBookings');
        }
      }
    });
  }
}

// class FavoriteAdsHealth extends StatelessWidget {
//   const FavoriteAdsHealth({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SubcategoriesCubit, SubcategoriesState>(
//       builder: (context, state) {
//               final controller = context.read<SubcategoriesCubit>();

//         return MyAdCard(
//           item: controller.myFavouriteAds[index],
//           showSubCategory: true,
//           onFav: (id) async {
//             bool result = await context
//                 .read<AdvertisementCubit>()
//                 .unFavouriteAd(controller.myFavouriteAds[i].id);
//             controller.myFavouriteAds.remove(controller.myFavouriteAds[i]);
//             setState(() {});
//             return result;
//             // bool result = await context
//             //     .read<AdvertisementCubit>()
//             //     .favouriteAd(controller.myFavouriteAds[i].id);
//             // return result;
//           },
//           onRemoveFav: (id) async {
//             bool result = await context
//                 .read<AdvertisementCubit>()
//                 .unFavouriteAd(controller.myFavouriteAds[i].id);
//             return result;
//           },
//         );
//       },
//     );
//   }
// }
