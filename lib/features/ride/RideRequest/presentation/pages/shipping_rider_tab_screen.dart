import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/service/cache_service.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/carpool_google_map.dart';
import 'package:fourtyninehub/features/carpool/add_new_route/presentation/widgets/map_and_address_finder_car_pool.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/check_driver_type_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/map_and_address_finder_ride.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_google_map.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/sub_cateogry_ride_widget.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/sub_cateogry_shipping_widget.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/destination_text_field_and_find_button.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/start_text_field_and_find_button.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShippingRiderTabScreen extends StatefulWidget {
  const ShippingRiderTabScreen({super.key});

  @override
  State<ShippingRiderTabScreen> createState() => _ShippingRiderTabScreenState();
}

class _ShippingRiderTabScreenState extends State<ShippingRiderTabScreen> {
  bool isButtonSheet = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    context.read<CheckDriverTypeCubit>().checkDriverType();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!(CacheServiceImpl().isLogin() ?? false)) {
          context.pushReplacement(Routes.LOGIN);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
      mainCategoryId: 1,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<GetCateogryRiderCubit, RiderState>(
                builder: (context, state) {
                  if (state is SuccessGetCateogyRider) {
                    return Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RiderBanner(
                              model: state.model,
                              favoriteName: "Driver",
                            )),
                        // SizedBox(height: 10,),
                        BlocBuilder<CheckDriverTypeCubit, RiderState>(
                          builder: (context, state) {
                            log(state.toString());
                            if (state is SuccesCheckDriverTypeState) {
                              if (state.shipping) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DashboardBanner(
                                    onTap: () =>
                                        context.push(Routes.DASHBOARDDRIVERSCREEN),
                                    title: Labels.driverDashboard,
                                    subTitle:
                                        Labels.driverDashboardBannerDiscription,
                                    route: Routes.DOCTORDASHBOARD,
                                  ),
                                );
                              } else if (state.rider) {
                                return DashboardBanner(
                                  onTap: () =>
                                      context.push(Routes.ALLTRIPRIDER),
                                  title: LocaleKeys.driverDashboard.tr(),
                                  subTitle: LocaleKeys
                                      .newBookingsAreWaitingYouGoToResturantDashboardAndExploreMore
                                      .tr(),
                                  route: Routes.DOCTORDASHBOARD,
                                );
                              } else {
                                return GestureDetector(
                                  // onTap: () => context
                                  //     .push(Routes.SHIPPING_REGISTER),
                                  onTap: () {
                                    if (context.read<UserCubit>().isLoggedIn) {
                                      context.push(Routes.SHIPPING_REGISTER);
                                    } else {
                                      // context.push(Routes.SHIPPING_REGISTER);
                                      context.push(Routes.LOGIN);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      LocaleKeys
                                          .serveClientsByClickRegister
                                          .tr(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    const Sizer(),
                    MapAndAddressFinderRide(),
                  ],
                ),
              ),
              Sizer(),
              SubCateogryRideWidget(),
              SubCateogryShippingWidget(
                  formKey: formKey,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
