import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/delete_driver_ride_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/get_driver_info_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class DriverInfoRideTap extends StatelessWidget {
  const DriverInfoRideTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocListener<DeleteDriverRideCubit, RiderState>(
        listener: (context, state) {
          if (state is SuccessDeleteDriverState) {
            showSuccessMessage(context, LocaleKeys.deleteSuccessfully.tr());
            context.push(Routes.HOME);
          }
        },
        child: BlocBuilder<GetDriverInfoCubit, RiderState>(
          builder: (context, state) {
            log(state.toString(), name: "lksdjflskdjfldkfj");
            if (state is SuccessGetDriverInfoState) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    AppButton(
                      padding: 20,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: LocaleKeys.registrationForm.tr(),
                      onPressed: () {
                        context.push(Routes.updateDriverRide);
                      },
                      backColor: Colors.white,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: context.isArabic
                                  ? "الموعد النهائي للاشتراك المميز"
                                  : "Deadline Subscription Premium",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text:
                                  "${state.model.deadlineSubscriptionPremium}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: LocaleKeys.deadlineSubscription.tr(),
                      onPressed: () {
                        // serviceLocator<SubscriptionController>()
                        //     .showSubscriptionPlans(subCategoryId: "62c8bab18e28a58a3edf580d");
                        // context.push(Routes.)
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              width: double.infinity,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    LocaleKeys.subcategoryName.tr(),
                                    style: Styles.headerText(),
                                  ),
                                  Text(
                                    LocaleKeys.premium.tr(),
                                    style: Styles.headerText(),
                                  ),
                                  Text(
                                    "${state.model.deadlineSubscriptionPremium} Day",
                                    style: Styles.headerText(),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  AppButton(
                                      color: Colors.white,
                                      backColor: AppColors.PRIMARY_COLOR,
                                      label: LocaleKeys.addSubscription.tr(),
                                      onPressed: () {
                                        serviceLocator<SubscriptionController>()
                                            .showSubscriptionPlans(
                                                subCategoryId:
                                                    "62c8bab18e28a58a3edf580d");
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      },
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: LocaleKeys.deadlineId.tr(),
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text: "${state.model.deadlineId}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: LocaleKeys.deadlineSubscription.tr(),
                      onPressed: () {
                        log('message');
                        serviceLocator<SubscriptionController>()
                            .showSubscriptionPlans(subCategoryId: "");
                      },
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: LocaleKeys.deadlineLicense.tr(),
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text: "${state.model.deadlineLicense}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: LocaleKeys.deadlineId.tr(),
                      onPressed: () {},
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: LocaleKeys.deadlineDriverLicense.tr(),
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text: "${state.model.deadlineId}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: LocaleKeys.deadlineDriverLicense.tr(),
                      onPressed: () {},
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: LocaleKeys.yourTrips.tr(),
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text: "${state.model.tripCount}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: "",
                      onPressed: () {},
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: context.isArabic
                                  ? "الموعد النهائي للاشتراك العادي"
                                  : "Deadline Subscription Regular",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text:
                                  "${state.model.deadlineSubscriptionRegular}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: "",
                      onPressed: () {},
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: LocaleKeys.profit.tr(),
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text: "${state.model.profit}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: "",
                      onPressed: () {},
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(
                              text: LocaleKeys.clientsRating.tr(),
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                          Label(
                              text: "${state.model.totalRating}",
                              style: Styles.mediumText(
                                  color: AppColors.PRIMARY_COLOR)),
                        ],
                      ),
                      padding: 20,
                      width: double.infinity,
                      mainAxisAlignment: MainAxisAlignment.start,
                      label: "",
                      onPressed: () {
                        context.push(Routes.MyRating);
                      },
                      backColor: Colors.white,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AppButton(
                      label: LocaleKeys.deleteRegistration.tr(),
                      onPressed: () {
                        context.read<DeleteDriverRideCubit>().delete();
                      },
                      color: Colors.white,
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
