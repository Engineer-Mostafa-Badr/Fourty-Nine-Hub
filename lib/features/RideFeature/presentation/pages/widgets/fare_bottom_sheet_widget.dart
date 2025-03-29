import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../controllers/cubits/ride_states.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';

class FareBottomSheetWidget extends StatelessWidget {
  FareBottomSheetWidget({
    super.key,
    required this.rideCubit,
    required this.selectedCategoryPrice,
    required this.selectedCategoryName,
  }) : _controller = TextEditingController(
          text:
              selectedCategoryPrice > 0 ? selectedCategoryPrice.toString() : '',
        );

  final RideCubit rideCubit;
  final double selectedCategoryPrice;
  final String selectedCategoryName;
  final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: rideCubit,
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          return Form(
            // Wrap in a Form widget
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  autofocus: true,
                  cursorColor: AppColors.PRIMARY_COLOR,
                  cursorHeight: 50,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: context.isArabic ? 'ج.م' : 'EGP',
                    hintStyle: const TextStyle(
                      color: Color(0xff96979B),
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(),
                    enabledBorder: const UnderlineInputBorder(),
                    errorBorder: const UnderlineInputBorder(),
                    disabledBorder: const UnderlineInputBorder(),
                    focusedErrorBorder: const UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.isArabic
                          ? 'يرجى إدخال مبلغ'
                          : 'Please enter an amount';
                    }

                    final double? amount = double.tryParse(value);
                    final double minFare =
                        state.rideExpectedPrice?.lowestFare ?? 0;
                    final double maxFare =
                        state.rideExpectedPrice?.highestFare ?? double.infinity;

                    if (amount == null ||
                        amount < minFare ||
                        amount > maxFare) {
                      return context.isArabic
                          ? 'يجب أن يكون المبلغ بين $minFare و $maxFare'
                          : 'Amount must be between $minFare and $maxFare';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  width: double.infinity,
                  label: LocaleKeys.done.tr(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedCategoryName == "Captain") {
                        state.rideExpectedPrice?.priceForCaptain =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName == "Scooter") {
                        state.rideExpectedPrice?.priceForScooter =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName == "Taxi") {
                        state.rideExpectedPrice?.priceForTaxi =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName == "Suv") {
                        state.rideExpectedPrice?.priceForSUV =
                            double.parse(_controller.text);
                      }
                      rideCubit.emitRefreshState();
                      Navigator.pop(context);
                    }
                  },
                  backColor: AppColors.PRIMARY_COLOR,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FareBottomSheetWidget2 extends StatelessWidget {
  FareBottomSheetWidget2({
    super.key,
    required this.selectedCategoryPrice,
    required this.dashboardsCubit,
    required this.id,
  }) : _controller = TextEditingController(
          text:
              selectedCategoryPrice > 0 ? selectedCategoryPrice.toString() : '',
        );

  final double selectedCategoryPrice;
  final String id;
  final DashboardsCubit dashboardsCubit;
  final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: dashboardsCubit,
      child: BlocBuilder<DashboardsCubit, DashboardsState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
                  autofocus: true,
                  cursorColor: AppColors.PRIMARY_COLOR,
                  cursorHeight: 50,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintText: context.isArabic ? 'ج.م' : 'EGP',
                    hintStyle: const TextStyle(
                      color: Color(0xff96979B),
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(),
                    enabledBorder: const UnderlineInputBorder(),
                    errorBorder: const UnderlineInputBorder(),
                    disabledBorder: const UnderlineInputBorder(),
                    focusedErrorBorder: const UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return context.isArabic
                          ? 'يرجى إدخال مبلغ'
                          : 'Please enter an amount';
                    }
                    // final double? amount = double.tryParse(value);
                    // final double minFare =
                    //     state.rideExpectedPrice?.lowestFare ?? 0;
                    // final double maxFare =
                    //     state.rideExpectedPrice?.highestFare ?? double.infinity;
                    // if (amount == null || amount < minFare || amount > maxFare) {
                    //   return context.isArabic
                    //       ? 'يجب أن يكون المبلغ بين $minFare و $maxFare'
                    //       : 'Amount must be between $minFare and $maxFare';
                    // }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppButton(
                  iconWidget: state.isLoadingCreateOffer
                      ? const CircularProgressIndicator.adaptive()
                      : null,
                  width: double.infinity,
                  label: LocaleKeys.done.tr(),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      dashboardsCubit.createNewOffer(
                          context,
                          CreateNewOfferDashboardUsecaseParam(
                              priceOffer: int.parse(_controller.text),
                              location: CreateOfferLocation(
                                latitude: 0.0,
                                longitude: 0.0,
                              ),
                              tripId: id)).then((value){
                                Navigator.pop(context);
                              });
                    }
                  },
                  backColor: AppColors.PRIMARY_COLOR,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
