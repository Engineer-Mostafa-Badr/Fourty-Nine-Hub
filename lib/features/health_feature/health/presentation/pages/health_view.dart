import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_types.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/booking_history_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/current_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/cards/most_booking_card.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/current_history_booking.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_mode_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/registration_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/ads_request_log_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/favourite_ads_view.dart';
import 'package:fourtyninehub/features/subcategories/presentation/pages/my_ads_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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

  bool _showFavoriteAds = false;

  bool _showRequestLog = false;
  bool _showMyAds = false;
  @override
  Widget build(BuildContext context) {
    bool isWaitingApproval = false;
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocBuilder<HealthCubit, HealthState>(
        builder: (context, state) {
          return ListView(
            // padding: EdgeInsets.all(16.0.w),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: HealthBanner(),
              ),
              Sizer(),
              state.isDoctor == false
                  ? const RegistrationBanner()
                  : DoctorModeBanner(
                      isWaitingApproval: isWaitingApproval,
                    ),
              if (isWaitingApproval) WaitingAprovalText(),
              Sizer(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    Icon(
                      Icons.search,
                      size: 50.sp,
                    ),
                    const Sizer(),

                    /// Favourite Ads
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
                    const Sizer(),

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
                    const Sizer(),

                    /// Current Booking
                    CurrentHistoryBooking(
                      title:
                          context.isArabic ? 'حجوزات حالية' : 'Current Booking',
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
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                ),
              ),
              Sizer(height: 20),

              // Default view when none are selected
              if (!_showMost && !_showHistory && !_showCurrent) ...[
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
                          Icon(
                            Icons.search,
                            size: 50.sp,
                          ),
                          const Sizer(),

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
                          const Sizer(),

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
                          const Sizer(),

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
                          const SizedBox(
                            width: 16,
                          ),
                        ],
                      ),
                    ),
                    const Sizer(height: 8),
                    if (!_showFavoriteAds &&
                        !_showRequestLog &&
                        !_showMyAds) ...[
                      const HealthMedicalServices(),
                      const Sizer(),
                      const HealthBookings(),
                      const Sizer(),
                    ],
                    if (_showFavoriteAds)
                      FavouriteAdsView(
                        id: '62c8b57c9332225799fe3306',
                        isFloatingButtonVisible: (p0) {},
                      ),
                    if (_showRequestLog)
                      AdsRequestLogView(
                        mainCategoryId: '62c8b57c9332225799fe3306',
                        isFloatingButtonVisible: (p0) {},
                      ),
                    if (_showMyAds)
                      MyAdsView(
                        id: '62c8b57c9332225799fe3306',
                        isFloatingButtonVisible: (p0) {},
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
            ],
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
          context
              .read<SubcategoriesCubit>()
              .loadMyFavouriteAds(id: '62c8b57c9332225799fe3306');
        }
      } else if (viewType == 'requestLog') {
        _showRequestLog = !_showRequestLog;
        if (_showRequestLog) {
          _showFavoriteAds = false;
          _showMyAds = false;
          context
              .read<SubcategoriesCubit>()
              .loadRequestsLog(id: '62c8b57c9332225799fe3306');
        }
      } else if (viewType == 'myAds') {
        _showMyAds = !_showMyAds;
        if (_showMyAds) {
          _showFavoriteAds = false;
          _showRequestLog = false;
          context
              .read<SubcategoriesCubit>()
              .loadMyAds(id: '62c8b57c9332225799fe3306');
        }
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
        }
      } else if (viewType == 'history') {
        _showHistory = !_showHistory;
        if (_showHistory) {
          _showMost = false;
          _showCurrent = false;
          cubit.switchBookingType('history');
        }
      } else if (viewType == 'current') {
        _showCurrent = !_showCurrent;
        if (_showCurrent) {
          _showMost = false;
          _showHistory = false;
          cubit.switchBookingType('current');
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
