import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routed_builder.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_floating_action_button.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';

class CarPoolBody extends StatefulWidget {
  const CarPoolBody({super.key});

  @override
  State<CarPoolBody> createState() => _CarPoolBodyState();
}

class _CarPoolBodyState extends State<CarPoolBody>
    with AutomaticKeepAliveClientMixin {
  bool showAvailableRoutes = true;
  void _printCurrentLocation() async {
    try {
      Position position = await GetCurrentLocationDriver.getCurrentPosition();
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
      GetCurrentLocationDriver.position = position;
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    _printCurrentLocation();
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    BlocProvider.of<GetAllTripsCubit>(context)
        .fetchAllCarpoolTrips(isLoggedIn: context.read<UserCubit>().isLoggedIn);
    // BlocProvider.of<GetAvailableTripsForDriversCubit>(context)
    //     .fetchAllCarpoolTripsForDriver();
    // BlocProvider.of<VerifyCompleteDriverCubit>(context).getAcceptedTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      child: DefaultTabController(
        length: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              context.isArabic
                  ? "طريق واحد - كابتن واحد"
                  : "One Way - One Captain",
              style: Styles.headerText(color: AppColors.PRIMARY_COLOR_DARK),
            ),
            TabBar(
              indicatorPadding: EdgeInsets.zero,
              labelColor: context.isDarkMode
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.PRIMARY_COLOR_LIGHT,
              indicatorColor: AppColors.PRIMARY_COLOR_DARK,
              labelPadding: const EdgeInsets.symmetric(horizontal: 8),
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Container(
                    height: 80.h,
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.availableTrips.localize,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ), // Adjust font size
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 80.h,
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.myBookings.localize,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 80.h,
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.runningTrips.localize,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    height: 80.h,
                    alignment: Alignment.center,
                    child: Text(
                      LocaleKeys.expiredTrips.localize,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                // Tab(
                //   child: Container(
                //     height: 80.h,
                //     alignment: Alignment.center,
                //     child: Text(
                //       "Dash",
                //       textAlign: TextAlign.center,
                //       softWrap: true, // Allow text wrapping
                //       style: TextStyle(fontSize: 22.sp), // Adjust font size
                //     ),
                //   ),
                // ),
                // Tab(
                //   child: Container(
                //     height: 80.h,
                //     alignment: Alignment.center,
                //     child: Text(
                //       "Accepted",
                //       textAlign: TextAlign.center,
                //       softWrap: true, // Allow text wrapping
                //       style: TextStyle(fontSize: 22.sp), // Adjust font size
                //     ),
                //   ),
                // ),
              ],
            ),
            // Expanded to fit the available height
            Expanded(
              child: Stack(
                children: [
                  TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildTabContent(context, "available"),
                      _buildTabContent(context, "myBookings"),
                      _buildTabContent(context, "running"),
                      _buildTabContent(context, "expired"),
                      // BlocBuilder<GetAvailableTripsForDriversCubit,
                      //     GetAvailableTripsForDriversState>(
                      //   builder: (context, state) {
                      //     if (state is GetAvailableTripsForDriversLoading) {
                      //       return const Center(
                      //           child: CustomCircularProgressIndicator(
                      //         color: AppColors.PRIMARY_COLOR,
                      //       ));
                      //     } else if (state
                      //         is GetAvailableTripsForDriversSuccess) {
                      //       return ListView.builder(
                      //         itemCount: state.trips.length,
                      //         itemBuilder: (context, index) {
                      //           final trip = state.trips[index];
                      //           return BlocProvider(
                      //             create: (context) =>
                      //                 AcceptTripForDriverCubit(serviceLocator()),
                      //             child: TestCardDashboard(entity: trip),
                      //           );
                      //         },
                      //       );
                      //     } else if (state
                      //         is GetAvailableTripsForDriversFailure) {
                      //       // Show an error message and retry option on failure
                      //       return Center(
                      //         child: Column(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Text('Error loading trips. Please try again.'),
                      //             SizedBox(height: 16),
                      //             ElevatedButton(
                      //               style: const ButtonStyle(
                      //                   backgroundColor: MaterialStatePropertyAll(
                      //                       AppColors.PRIMARY_COLOR)),
                      //               onPressed: () {
                      //                 context
                      //                     .read<
                      //                         GetAvailableTripsForDriversCubit>()
                      //                     .fetchAllCarpoolTrips();
                      //               },
                      //               child: const Text(
                      //                 'Retry',
                      //                 style: TextStyle(
                      //                     color: AppColors.AUTH_CONTAINER_COLOR),
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     }
                      //     // Initial or unexpected state
                      //     return const Center(child: Text('No data available.'));
                      //   },
                      // ),
                      // BlocProvider(
                      //     create: (context) => VerifyCompleteDriverCubit(
                      //         verifyOtpCompleteSeatDriverRemoteDataSource:
                      //             serviceLocator())
                      //       ..getAcceptedTrips(),
                      //     child: BlocBuilder<VerifyCompleteDriverCubit,
                      //         VerifyCompleteDriverState>(
                      //       builder: (context, state) {
                      //         if (state is GetAcceptedTripLoading) {
                      //           return const Center(
                      //               child: CustomCircularProgressIndicator(
                      //                   color: AppColors.PRIMARY_COLOR));
                      //         } else if (state is GetAcceptedTripSuccess) {
                      //           final tripParam = state.carpoolTripParam;

                      //           // Use ListView or Column to dynamically update the UI
                      //           return ListView.builder(
                      //             itemCount: 1,
                      //             itemBuilder: (context, index) {
                      //               final trip = tripParam;
                      //               return BlocProvider.value(
                      //                 value:
                      //                     context.read<VerifyCompleteDriverCubit>(),
                      //                 child: AcceptedCardForDriver(entity: trip),
                      //               );
                      //             },
                      //           );
                      //         } else if (state is GetAcceptedTripFailure) {
                      //           return Center(
                      //             child: Column(
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 const Text(
                      //                     'No Accepted trips. Please try again.'),
                      //                 const SizedBox(height: 16),
                      //                 ElevatedButton(
                      //                   style: ButtonStyle(
                      //                     backgroundColor:
                      //                         MaterialStateProperty.all(
                      //                             AppColors.PRIMARY_COLOR),
                      //                   ),
                      //                   onPressed: () {
                      //                     context
                      //                         .read<VerifyCompleteDriverCubit>()
                      //                         .getAcceptedTrips();
                      //                   },
                      //                   child: const Text(
                      //                     'Retry',
                      //                     style: TextStyle(
                      //                         color:
                      //                             AppColors.AUTH_CONTAINER_COLOR),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         }
                      //         return const Center(
                      //             child: Text('No accepted trips available.'));
                      //       },
                      //     ))
                    ],
                  ),
                  CarpoolFloatingActionButton(
                    onPressed: () {
                      context.read<UserCubit>().isLoggedIn
                          ? context.pushReplacement(Routes.ADD_NEW_ROUTE)
                          : pleaseLoginDialog(context);

                        // context.push(Routes.LOGIN);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, String type) {
    return Stack(
      children: [
        const SizedBox(width: double.infinity, height: double.infinity),
        if (type == "available")
          Positioned(
            top: 8,
            right: 10,
            left: 10,
            child: Text(
              context.isArabic
                  ? "انضم إلى الرحلات المتوفرة حولك الآن."
                  : "Join available trips near you now.",
              style: Styles.mediumText(
                color: AppColors.PRIMARY_COLOR_DARK,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (type == "myBookings")
          Positioned(
            top: 8,
            right: 10,
            left: 10,
            child: Text(
              context.isArabic
                  ? "كل حجوزاتك في مكان واحد!"
                  : "All your bookings in one place!",
              style: Styles.mediumText(
                color: AppColors.PRIMARY_COLOR_DARK,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (type == "running")
          Positioned(
            top: 8,
            right: 10,
            left: 10,
            child: Text(
              context.isArabic
                  ? "تعرف على الرحلات الجارية في الوقت الحالي."
                  : "Explore trips that are active at the moment.",
              style: Styles.mediumText(
                color: AppColors.PRIMARY_COLOR_DARK,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        if (type == "expired")
          Positioned(
            top: 8,
            right: 10,
            left: 10,
            child: Text(
              context.isArabic
                  ? "الرحلات المنتهية حديثًا."
                  : "Browse recently completed trips.",
              style: Styles.mediumText(
                color: AppColors.PRIMARY_COLOR_DARK,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        BlocBuilder<GetAllTripsCubit, GetAllTripsState>(
          builder: (context, state) {
            return AvailableRoutesBuilder(type: type);
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
