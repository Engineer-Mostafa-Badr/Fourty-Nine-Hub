import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RideBannerWidget extends StatelessWidget {
  const RideBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCateogryRiderCubit, RiderState>(
      builder: (context, state) {
        if (state is SuccessGetCateogyRider) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RiderBanner(
                  model: state.model,
                  favoriteName: "Driver",
                ),
              ),
              BlocBuilder<ShippingCubit, ShippingState>(
                builder: (context, state) {
                  log(state.toString(), name: "lskdfjlskdjflskdjflskdjf");
                  if (state is LoadingShippingState) {
                    return const CustomCircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    );
                  }
                  if (state is SuccessGetBannerState) {
                    return (state.model.mainCategory?.isDriverApproved ?? false)
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: DashboardBanner(
                              onTap: () {
                                ManageVibration.vibrate();
                                if (state
                                        .model.mainCategory?.isSocketCategory ??
                                    false) {
                                  log("Socket Screen");
                                  context.pushNamed(Routes.ALLTRIPRIDER);
                                } else {
                                  log("No Socket Screen");
                                  context
                                      .pushNamed(Routes.ALLTRIPNOSOCKETSCREEN);
                                }
                              },
                              title: LocaleKeys.rideDashboard.tr(),
                              subTitle: "",
                              route: Routes.DOCTORDASHBOARD,
                            ),
                          )
                        : Container();
                  } else {
                    return Container();
                  }
                },
              ),
              const Sizer(),
              (state.model.mainCategory?.isDriverApproved ?? false)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: DashboardBanner(
                        onTap: () {
                          ManageVibration.vibrate();
                          if (state.model.mainCategory?.isSocketCategory ??
                              false) {
                            log("Socket Screen");
                            context.pushNamed(Routes.ALLTRIPRIDER);
                          } else {
                            log("No Socket Screen");
                            context.pushNamed(Routes.ALLTRIPNOSOCKETSCREEN);
                          }
                          // (state.model.mainCategory?.isSocketCategory ??
                          //           false)
                          //       ? context.pushNamed(Routes.ALLTRIPRIDER)
                          //       : context.pushNamed(Routes.ALLTRIPNOSOCKETSCREEN),
                        },
                        title: LocaleKeys.rideDashboard.tr(),
                        subTitle: "",
                        route: Routes.DOCTORDASHBOARD,
                      ),
                    )
                  : Container(),
              const Sizer(),
              BlocBuilder<ShippingCubit, ShippingState>(
                builder: (context, state) {
                  return Container();
                },
              )
            ],
          );
        } else {
          return const CustomCircularProgressIndicator();
        }
      },
    );
  }
}
