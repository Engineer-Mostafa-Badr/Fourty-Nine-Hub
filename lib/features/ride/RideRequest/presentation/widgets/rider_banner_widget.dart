import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_cateogry_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/rider_banner.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RiderBannerWidget extends StatelessWidget {
  const RiderBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCateogryRiderCubit, RiderState>(
      builder: (context, state) {
        if (state is SuccessGetCateogyRider) {
          log((state.model.mainCategory?.isSocketCategory).toString());
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(0),
                  child: RiderBanner(
                    model: state.model,
                    favoriteName: "Driver",
                  )),
              // SizedBox(height: 10,),
              (state.model.mainCategory?.isDriverApproved ?? false)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: DashboardBanner(
                        onTap: () {
                          if (state.model.mainCategory?.isSocketCategory ??
                              false) {
                            log("Socket Screen");
                            context.push(Routes.ALLTRIPRIDER);
                          } else {
                            log("No Socket Screen");
                            context.push(Routes.ALLTRIPNOSOCKETSCREEN);
                          }
                          // (state.model.mainCategory?.isSocketCategory ??
                          //           false)
                          //       ? context.push(Routes.ALLTRIPRIDER)
                          //       : context.push(Routes.ALLTRIPNOSOCKETSCREEN),
                        },
                        title: LocaleKeys.rideDashboard.tr(),
                        subTitle: "",
                        route: Routes.DOCTORDASHBOARD,
                      ),
                    )
                  : ((state.model.mainCategory?.isDriver ?? true) == true &&
                          (state.model.mainCategory?.isDriverApproved ??
                                  false) ==
                              false)
                      ? Container()
                      : GestureDetector(
                          // onTap: () => context
                          //     .push(Routes.SHIPPING_REGISTER),
                          onTap: () {
                            context.push(Routes.RIDERREGISTER);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Text(
                              LocaleKeys.serveClientsByClickRegister.tr(),
                              style: const TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
