import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/data/models/banner_model/banner_model.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RideShippingButtonSheet extends StatelessWidget {
  const RideShippingButtonSheet({super.key, required this.model});
  final BannerModel model;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<ShippingCubit, ShippingState>(
            builder: (context, state) {
              if (state is LoadingShippingState) {
                return Center(
                  child: CustomCircularProgressIndicator(
                    color: AppColors.PRIMARY_COLOR,
                  ),
                );
              }
              if (state is SuccessGetBannerState) {
                if (!(state.model.mainCategory?.isDriverApproved ?? false)) {
                  return GestureDetector(
                    onTap: () {
                      ManageVibration.vibrate();
                      if (state.model.mainCategory?.isDriverApproved == false &&
                          state.model.mainCategory?.isDriver == true) {
                        context.pop();
                        showErrorMessage(
                            context,
                            context.isArabic
                                ? "في انتظار الموافقة"
                                : "Waiting for approve");
                      } else {
                        context.push(Routes.SHIPPING_REGISTER);
                      }
                    },
                    child: Stack(
                      children: [
                        // الخلفية (الصورة)
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10), // زوايا دائرية للصورة
                          child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.width - 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    state.model.mainCategory?.banner ?? ""),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // تأثير الزجاج
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // زوايا دائرية لتطابق الصورة
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: (model.mainCategory?.isDriverApproved ??
                                        false)
                                    ? 0
                                    : 5,
                                sigmaY: (model.mainCategory?.isDriverApproved ??
                                        false)
                                    ? 0
                                    : 5), // قوة التمويه
                            child: Container(
                              color: Colors.black
                                  .withOpacity(0.4), // لون شفاف داكن فوق الزجاج
                              height: 55,
                              width: MediaQuery.of(context).size.width - 50,
                              child: Center(
                                child: Text(
                                  LocaleKeys.ship.tr(),
                                  // getDriverState(isDriver: state.model.mainCategory?.isDriver??false, isDriverApproved: state.model.mainCategory?.isDriverApproved??false, title: LocaleKeys.shipping.tr(), context: context),
                                  style: Styles.headerText(
                                      color: AppColors.AUTH_CONTAINER_COLOR),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              } else {
                return Container();
              }
            },
          ),
          const Sizer(),
          if (!(model.mainCategory?.isDriverApproved ?? false))
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                if (model.mainCategory?.isDriverApproved == false &&
                    model.mainCategory?.isDriver == true) {
                  context.pop();
                  showErrorMessage(
                      context,
                      context.isArabic
                          ? "في انتظار الموافقة"
                          : "Waiting for approve");
                } else {
                  context.push(Routes.RIDERREGISTER);
                }
              },
              child: Stack(
                children: [
                  // الخلفية (الصورة)
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // زوايا دائرية للصورة
                    child: Container(
                      height: 55,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(model.mainCategory?.banner ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10), // زوايا دائرية لتطابق الصورة
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX:
                              (model.mainCategory?.isDriverApproved ?? false)
                                  ? 0
                                  : 5,
                          sigmaY:
                              (model.mainCategory?.isDriverApproved ?? false)
                                  ? 0
                                  : 5), // قوة التمويه
                      child: Container(
                        color: (model.mainCategory?.isDriverApproved ?? false)
                            ? null
                            : Colors.black
                                .withOpacity(0.4), // لون شفاف داكن فوق الزجاج
                        height: 55,
                        width: MediaQuery.of(context).size.width - 50,
                        child: Center(
                          child: Text(
                            LocaleKeys.ride.tr(),
                            // getDriverState(isDriver: model.mainCategory?.isDriver??false, isDriverApproved: model.mainCategory?.isDriverApproved??false, title: LocaleKeys.ride, context: context),
                            style: Styles.headerText(
                                color: AppColors.AUTH_CONTAINER_COLOR),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  getDriverState(
      {required bool isDriver,
      required bool isDriverApproved,
      required String title,
      required BuildContext context}) {
    if (!isDriver && !isDriverApproved) {
      return title;
    } else {
      return context.isArabic ? "في انتظار الموافقة" : "Waiting for approve";
    }
  }
}
