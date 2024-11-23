import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/shipping_banner.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ShippingBannerWidget extends StatefulWidget {
  const ShippingBannerWidget({super.key});

  @override
  State<ShippingBannerWidget> createState() => _ShippingBannerWidgetState();
}

class _ShippingBannerWidgetState extends State<ShippingBannerWidget> {
  bool isButtonSheet = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShippingCubit, ShippingState>(
      builder: (context, state) {
        if (state is LoadingShippingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.PRIMARY_COLOR,
            ),
          );
        }
        if (state is SuccessGetBannerState) {
          return Column(
            children: [
              ShippingBanner(
                model: state.model,
                favoriteName: "Driver".tr(),
              ),
              const Sizer(
                height: 9,
              ),
              // لو هو مسجل
              // if (isDriver(state.model))
              if ((state.model.mainCategory?.isDriver ?? false) &&
                  (state.model.mainCategory?.isDriverApproved ?? false))
                // if(!(state.model.mainCategory?.haveTrip??false))
                Column(
                  children: [
                    DashboardBanner(
                      onTap: () => context.push(Routes.DASHBOARDDRIVERSCREEN),
                      title: Labels.loadingDashboard,
                      subTitle: "",
                      route: Routes.DOCTORDASHBOARD,
                    ),
                  ],
                ),
              // لو هو مش مسجل
              // if ((state.model.mainCategory?.isDriver ??
              //             false) !=
              //         true &&
              //     ((state.model.mainCategory?.isDriver ??
              //             false)) !=
              //         true)
              if ((state.model.mainCategory?.isDriver ?? false) != true &&
                  (state.model.mainCategory?.isDriverApproved ?? false) != true)
                GestureDetector(
                  // onTap: () => context
                  //     .push(Routes.SHIPPING_REGISTER),
                  onTap: () {
                    context.push(Routes.SHIPPING_REGISTER);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
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
          return Container();
        }
      },
    );
  }
}
