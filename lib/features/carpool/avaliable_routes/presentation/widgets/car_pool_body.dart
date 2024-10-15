import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/cubit/get_all_trips_state.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/cubits/get_currency/cubit/get_currency_cubit.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/available_routed_builder.dart';
import 'package:fourtyninehub/features/carpool/avaliable_routes/presentation/widgets/car_pool_floating_action_button.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CarPoolBody extends StatefulWidget {
  const CarPoolBody({super.key});

  @override
  State<CarPoolBody> createState() => _CarPoolBodyState();
}

class _CarPoolBodyState extends State<CarPoolBody> {
  bool showAvailableRoutes = true;
  @override
  void initState() {
    BlocProvider.of<GetCurrencyCubit>(context).getCurrencyData();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Transform(
              transform: Matrix4.translationValues(-40.0, 0.0, 0.0),
              child: TabBar(
                isScrollable: true,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    child: Text(LocaleKeys.availableTrips.localize),
                  ),
                  Tab(
                    child: Text(LocaleKeys.myBookings.localize),
                  ),
                  Tab(
                    child: Text(LocaleKeys.runningTrips.localize),
                  ),
                  Tab(
                    child: Text(LocaleKeys.expiredTrips.localize),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Stack(
                    children: [
                      const SizedBox(
                          width: double.infinity, height: double.infinity),
                      BlocBuilder<GetAllTripsCubit, GetAllTripsState>(
                        builder: (context, state) {
                          return const AvailableRoutesBuilder(
                            type: "available",
                          );
                        },
                      ),
                      CarpoolFloatingActionButton(
                        onPressed: () {
                          context.push(Routes.ADD_NEW_ROUTE);
                        },
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      const SizedBox(
                          width: double.infinity, height: double.infinity),
                      const AvailableRoutesBuilder(
                        type: "myBookings",
                      ),
                      CarpoolFloatingActionButton(
                        onPressed: () {
                          context.push(Routes.ADD_NEW_ROUTE);
                        },
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      const SizedBox(
                          width: double.infinity, height: double.infinity),
                      const AvailableRoutesBuilder(
                        type: "running",
                      ),
                      CarpoolFloatingActionButton(
                        onPressed: () {
                          context.push(Routes.ADD_NEW_ROUTE);
                        },
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      const SizedBox(
                          width: double.infinity, height: double.infinity),
                      const AvailableRoutesBuilder(
                        type: "expired",
                      ),
                      CarpoolFloatingActionButton(
                        onPressed: () {
                          context.push(Routes.ADD_NEW_ROUTE);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
//       child: CustomScrollView(
//         slivers: [
//           const MapAndAddressFinderCarPool(),
//           SliverToBoxAdapter(
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     TextButton(
//                       onPressed: () {
//                         showAvailableRoutes = true;
//                         setState(() {});
//                       },
//                       child: Container(
//                         width: 225.w,
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.only(bottom: 5.w),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: showAvailableRoutes ? AppColors.PRIMARY_COLOR : Colors.grey,
//                               width: showAvailableRoutes ? 2 : 1,
//                             ),
//                           ),
//                         ),
//                         child: Text(
//                           'Avalilable Routes',
//                           style: Styles.mediumText(),
//                         ),
//                       ),
//                     ),
//                     const Spacer(),
//                     TextButton(
//                       onPressed: () {
//                         showAvailableRoutes = false;
//                         setState(() {});
//                       },
//                       child: Container(
//                         width: 225.w,
//                         alignment: Alignment.center,
//                         padding: EdgeInsets.only(bottom: 5.w),
//                         decoration: BoxDecoration(
//                           border: Border(
//                             bottom: BorderSide(
//                               color: !showAvailableRoutes ? AppColors.PRIMARY_COLOR : Colors.grey,
//                               width: !showAvailableRoutes ? 2 : 1,
//                             ),
//                           ),
//                         ),
//                         child: Text(
//                           'Runing Trips',
//                           style: Styles.mediumText(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildBuilderDelegate(
//               childCount: 1,
//               (context, index) {
//                 return Container(
//                     margin: EdgeInsets.only(top: 20.h),
//                     child: showAvailableRoutes
//                         ? const AvailableRoutesBuilder()
//                         : const Center(child: Text('Running Trips')));
//               },
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
