import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/fare_bottom_sheet_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../domain/usecases/dashboards/create_new_offer_dashboard_usecase.dart';
import '../../controllers/cubits/ride_states.dart';
import '../../controllers/dashboards_cubit/dashboards_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class UpdateFareBottomSheetWidget extends StatefulWidget {
  UpdateFareBottomSheetWidget({
    super.key,
    required this.selectedCategoryPrice,
    required this.onChange,
    required this.isArabic,
    required this.selectedCategoryName,
    required this.highCostPerKm,
    required this.lowCostPerKm,
  }) : _controller = ArabicNumberTextController(
    isArabic: isArabic,
    initialText: selectedCategoryPrice > 0
              ? selectedCategoryPrice.toInt().toString()
              : '',
        );
  final num selectedCategoryPrice;
  final Function(num price) onChange;
  final num highCostPerKm;
  final num lowCostPerKm;
  final String selectedCategoryName;
  final bool isArabic;
  final ArabicNumberTextController _controller;

  @override
  State<UpdateFareBottomSheetWidget> createState() => _UpdateFareBottomSheetWidgetState();
}

class _UpdateFareBottomSheetWidgetState extends State<UpdateFareBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();

  String convertArabicToEnglishDigits(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    for (int i = 0; i < arabicDigits.length; i++) {
      input = input.replaceAll(arabicDigits[i], i.toString());
    }
    return input;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RideCubit>(),
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          var cubit = context.read<RideCubit>();
          return Form(
            // Wrap in a Form widget

            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: widget._controller,
                  autofocus: true,
                  cursorColor:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
                  cursorHeight: 50,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                  ],
                  style: TextStyle(
                    color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
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
                    fillColor: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
                    filled: true,
                    border: const UnderlineInputBorder(),
                    focusedBorder: const UnderlineInputBorder(),
                    enabledBorder: const UnderlineInputBorder(),
                    errorBorder: const UnderlineInputBorder(),
                    disabledBorder: const UnderlineInputBorder(),
                    focusedErrorBorder: const UnderlineInputBorder(),
                  ),
                  onChanged: (v){
                    _formKey.currentState!.validate();
                  },
                    validator: (v) {
                      String value = context.isArabic?convertArabicToEnglishDigits(v??''):(v??'');
                      if (value.isEmpty) {
                        return context.isArabic
                            ? 'يرجى إدخال مبلغ'
                            : 'Please enter an amount';
                      }
                      print("value $value (double.tryParse(value) ?? 0) ${(double.tryParse(value) ?? 0)}  widget.lowCostPerKm ${widget.lowCostPerKm} widget.highCostPerKm ${widget.highCostPerKm}");
                      if ((double.tryParse(value) ?? 0) < widget.lowCostPerKm) {
                        return context.isArabic
                            ? 'يجب ان يكون السعر اكبر من او يساوي ${widget.lowCostPerKm}'
                            : 'The price must be greater than or equal to ${widget.lowCostPerKm}';
                      }
                      if ((double.tryParse(value) ?? 0) > widget.highCostPerKm) {
                        return context.isArabic
                            ? 'يجب ان يكون السعر اقل من او يساوي ${widget.highCostPerKm}'
                            : 'The price must be less than or equal to ${widget.highCostPerKm}';
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
                            ? 'يجب أن يكون المبلغ بين ${FormatNumbers().convertNumberToLocalizedString(minFare.toInt().toString(), isArabic: context.isArabic)} و ${FormatNumbers().convertNumberToLocalizedString(maxFare.toInt().toString(), isArabic: context.isArabic)}'
                            : 'Amount must be between ${FormatNumbers().convertNumberToLocalizedString(minFare.toInt().toString(), isArabic: context.isArabic)} and ${FormatNumbers().convertNumberToLocalizedString(maxFare.toInt().toString(), isArabic: context.isArabic)}';
                      }

                      return null;
                    },
                ),

                // TextFormField(
                //   controller: widget._controller,
                //   autofocus: true,
                //   cursorColor: context.isDarkMode
                //       ? Colors.white
                //       : AppColors.PRIMARY_COLOR,
                //   cursorHeight: 50,
                //   keyboardType: TextInputType.number,
                //   inputFormatters: [
                //     FilteringTextInputFormatter.digitsOnly,
                //     TextInputFormatter.withFunction((oldValue, newValue) {
                //       if (newValue.text.isEmpty) return newValue;
                //       if (newValue.text == '0') return newValue;
                //       if (newValue.text.startsWith('0')) {
                //         return oldValue;
                //       }
                //       return newValue;
                //     }),
                //   ],
                //   style: TextStyle(
                //     color: context.isDarkMode
                //         ? Colors.white
                //         : AppColors.PRIMARY_COLOR,
                //     fontWeight: FontWeight.w500,
                //     fontSize: 40,
                //   ),
                //   textAlign: TextAlign.center,
                //   decoration: InputDecoration(
                //     floatingLabelBehavior: FloatingLabelBehavior.never,
                //     hintText: context.isArabic ? 'ج.م' : 'EGP',
                //     hintStyle: const TextStyle(
                //       color: Color(0xff96979B),
                //       fontWeight: FontWeight.w500,
                //       fontSize: 40,
                //     ),
                //     fillColor: context.isDarkMode
                //         ? AppColors.QUANTITY_COLOR
                //         : Colors.white,
                //     filled: true,
                //     border: const UnderlineInputBorder(),
                //     focusedBorder: const UnderlineInputBorder(),
                //     enabledBorder: const UnderlineInputBorder(),
                //     errorBorder: const UnderlineInputBorder(),
                //     disabledBorder: const UnderlineInputBorder(),
                //     focusedErrorBorder: const UnderlineInputBorder(),
                //   ),
                //   onChanged: (v){
                //     _formKey.currentState!.validate();
                //   },
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return context.isArabic
                //           ? 'يرجى إدخال مبلغ'
                //           : 'Please enter an amount';
                //     }
                //     if ((double.tryParse(value) ?? 0) < widget.lowCostPerKm) {
                //       return context.isArabic
                //           ? 'يجب ان يكون السعر اكبر من او يساوي ${widget.lowCostPerKm}'
                //           : 'The price must be greater than or equal to ${widget.lowCostPerKm}';
                //     }
                //     if ((double.tryParse(value) ?? 0) > widget.highCostPerKm) {
                //       return context.isArabic
                //           ? 'يجب ان يكون السعر اقل من او يساوي ${widget.highCostPerKm}'
                //           : 'The price must be less than or equal to ${widget.highCostPerKm}';
                //     }
                //
                //     final double? amount = double.tryParse(value);
                //     final double minFare =
                //         state.rideExpectedPrice?.lowestFare ?? 0;
                //     final double maxFare =
                //         state.rideExpectedPrice?.highestFare ?? double.infinity;
                //
                //     if (amount == null ||
                //         amount < minFare ||
                //         amount > maxFare) {
                //       return context.isArabic
                //           ? 'يجب أن يكون المبلغ بين ${FormatNumbers().convertNumberToLocalizedString(minFare.toInt().toString(), isArabic: context.isArabic)} و ${FormatNumbers().convertNumberToLocalizedString(maxFare.toInt().toString(), isArabic: context.isArabic)}'
                //           : 'Amount must be between ${FormatNumbers().convertNumberToLocalizedString(minFare.toInt().toString(), isArabic: context.isArabic)} and ${FormatNumbers().convertNumberToLocalizedString(maxFare.toInt().toString(), isArabic: context.isArabic)}';
                //     }
                //
                //     return null;
                //   },
                // ),
                const SizedBox(height: 20),
                AppButton(
                  width: double.infinity,
                  label: LocaleKeys.done.tr(),
                  onPressed: () {
      ManageVibration.vibrate();
                    if (_formKey.currentState!.validate()) {
                      if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Captain".toLowerCase()) {
                        state.rideExpectedPrice?.priceForCaptain =
                            double.parse(widget._controller.text);
                      } else if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Scooter".toLowerCase()) {
                        state.rideExpectedPrice?.priceForScooter =
                            double.parse(widget._controller.text);
                      } else if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Taxi".toLowerCase()) {
                        state.rideExpectedPrice?.priceForTaxi =
                            double.parse(widget._controller.text);
                      } else if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Suv".toLowerCase()) {
                        state.rideExpectedPrice?.priceForSUV =
                            double.parse(widget._controller.text);
                      } else if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Lady".toLowerCase()) {
                        state.rideExpectedPrice?.priceForWomen =
                            double.parse(widget._controller.text);
                      } else if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Premium".toLowerCase()) {
                        state.rideExpectedPrice?.priceForPremium =
                            double.parse(widget._controller.text);
                      } else if (widget.selectedCategoryName.trim().toLowerCase() ==
                          "Intercity".toLowerCase()) {
                        state.rideExpectedPrice?.priceForIntercity =
                            double.parse(widget._controller.text);
                      }
                      Navigator.pop(context);
                      widget.onChange(
                          num.tryParse(
                              context.isArabic
                                  ? convertArabicToEnglishDigits(widget._controller.text)
                                  : widget._controller.text
                          ) ?? 0
                      );
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
    // required this.dashboardsCubit,
    required this.id,
    required this.contextScreen,
    required this.subCategoryId,
  }) : _controller = TextEditingController(
          text:
              selectedCategoryPrice > 0 ? selectedCategoryPrice.toString() : '',
        );

  final num selectedCategoryPrice;
  final String id;
  final String subCategoryId;
  final BuildContext contextScreen;
  // final DashboardsCubit dashboardsCubit;
  final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardsCubit, DashboardsState>(
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                // iconWidget: state.isLoadingCreateOffer
                //     ? const CustomCircularProgressIndicator()
                //     : null,
                width: double.infinity,
                label: LocaleKeys.done.tr(),
                onPressed: () {
      ManageVibration.vibrate();
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    BlocProvider.of<DashboardsCubit>(context)
                        .createNewOfferNonSocket(
                            contextScreen,
                            CreateNewOfferDashboardUsecaseParam(
                                priceOffer:
                                    double.parse(_controller.text).toInt(),
                                tripId: id),
                            subCategoryId);
                  }
                },
                backColor: AppColors.PRIMARY_COLOR,
              ),
            ],
          ),
        );
      },
    );
  }
}