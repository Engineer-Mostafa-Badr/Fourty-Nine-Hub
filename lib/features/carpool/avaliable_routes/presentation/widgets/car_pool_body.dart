import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_available_trips_for_drivers/cubit/get_available_trips_for_drivers_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routed_builder.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_floating_action_button.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/get_current_location_driver.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

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
    BlocProvider.of<GetAllTripsCubit>(context).fetchAllCarpoolTrips();
    BlocProvider.of<GetAvailableTripsForDriversCubit>(context)
        .fetchAllCarpoolTrips();

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
            TabBar(
              indicatorPadding: EdgeInsets.zero,
              labelColor: context.isDarkMode
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.PRIMARY_COLOR_LIGHT,
              indicatorColor: context.isDarkMode
                  ? AppColors.PRIMARY_COLOR_DARK
                  : AppColors.PRIMARY_COLOR_LIGHT,
              labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
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
                      style: TextStyle(fontSize: 22.sp), // Adjust font size
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
                      style: TextStyle(fontSize: 22.sp),
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
                      style: TextStyle(fontSize: 22.sp),
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
                      style: TextStyle(fontSize: 22.sp),
                    ),
                  ),
                ),
                // Tab(
                //   child: Container(
                //     height: 80.h,
                //     alignment: Alignment.center,
                //     child: Text(
                //       "DashBoard",
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
              child: TabBarView(
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
                  //           child: CircularProgressIndicator(
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
                  //                   backgroundColor: WidgetStatePropertyAll(
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
        BlocBuilder<GetAllTripsCubit, GetAllTripsState>(
          builder: (context, state) {
            return AvailableRoutesBuilder(type: type);
          },
        ),
        CarpoolFloatingActionButton(
          onPressed: () {
            context.read<UserCubit>().isLoggedIn
                ? context.pushReplacement(Routes.ADD_NEW_ROUTE)
                : context.push(Routes.LOGIN);
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
