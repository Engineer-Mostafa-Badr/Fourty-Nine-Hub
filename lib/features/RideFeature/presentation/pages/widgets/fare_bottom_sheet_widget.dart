import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/format_numbers.dart';
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
    required this.isArabic,
  }) : _controller = ArabicNumberTextController(
    isArabic: isArabic,
    initialText: selectedCategoryPrice > 0
        ? selectedCategoryPrice.toInt().toString()
        : '',
  );

  final RideCubit rideCubit;
  final double selectedCategoryPrice;
  final String selectedCategoryName;
  final bool isArabic;
  final ArabicNumberTextController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<RideCubit>(),
      child: BlocBuilder<RideCubit, RideState>(
        builder: (context, state) {
          var cubit = context.read<RideCubit>();
          return Form(
            // Wrap in a Form widget

            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _controller,
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
                  validator: (value) {
                    final input = _controller.englishText;

                    if (input.isEmpty) {
                      return context.isArabic
                          ? 'يرجى إدخال مبلغ'
                          : 'Please enter an amount';
                    }

                    final double? amount = double.tryParse(input);
                    final double minFare =
                        state.rideExpectedPrice?.lowestFare ?? 0;
                    final double maxFare =
                        state.rideExpectedPrice?.highestFare ?? double.infinity;

                    if (amount == null || amount < minFare || amount > maxFare) {
                      return context.isArabic
                          ? 'يجب أن يكون المبلغ بين ${FormatNumbers().convertNumberToLocalizedString(serviceLocator<RideCubit>().getTotalPrice(minFare).toInt().toString(), isArabic: true)} و ${FormatNumbers().convertNumberToLocalizedString(serviceLocator<RideCubit>().getTotalPrice(maxFare).toInt().toString(), isArabic: true)}'
                          : 'Amount must be between ${serviceLocator<RideCubit>().getTotalPrice(minFare).toInt().toString()} and ${serviceLocator<RideCubit>().getTotalPrice(maxFare).toInt().toString()}';
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
                      if (selectedCategoryName.trim().toLowerCase() == "Captain".toLowerCase()) {
                        state.rideExpectedPrice?.priceForCaptain =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName.trim().toLowerCase() == "Scooter".toLowerCase()) {
                        state.rideExpectedPrice?.priceForScooter =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName.trim().toLowerCase() == "Taxi".toLowerCase()) {
                        state.rideExpectedPrice?.priceForTaxi =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName.trim().toLowerCase() == "Suv".toLowerCase()) {
                        state.rideExpectedPrice?.priceForSUV =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName.trim().toLowerCase() == "Lady".toLowerCase()) {
                        state.rideExpectedPrice?.priceForWomen =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName.trim().toLowerCase() == "Premium".toLowerCase()) {
                        state.rideExpectedPrice?.priceForPremium =
                            double.parse(_controller.text);
                      } else if (selectedCategoryName.trim().toLowerCase() == "Intercity".toLowerCase()) {
                        state.rideExpectedPrice?.priceForIntercity =
                            double.parse(_controller.text);
                      }
                      cubit.emitRefreshState();
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
    // required this.dashboardsCubit,
    required this.id,
    required this.isArabic,
    required this.contextScreen,
    required this.subCategoryId,
  })  : _controller = ArabicNumberTextController(
    isArabic: isArabic,
    initialText: selectedCategoryPrice > 0
        ? selectedCategoryPrice.toString()
        : '',
  );

  final num selectedCategoryPrice;
  final String id;
  final String subCategoryId;
  final BuildContext contextScreen;
  final bool isArabic;
  final ArabicNumberTextController _controller;
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                ],
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
                  final input = _controller.englishText;
                  if (input.isEmpty) {
                    return context.isArabic
                        ? 'يرجى إدخال مبلغ'
                        : 'Please enter an amount';
                  }
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
                        if (_formKey.currentState!.validate()) {
                           Navigator.pop(context);
                          BlocProvider.of<DashboardsCubit>(context)
                              .createNewOfferNonSocket(
                                  contextScreen,
                                  CreateNewOfferDashboardUsecaseParam(
                                      priceOffer: double.parse(_controller.text).toInt(),
                                      tripId: id),subCategoryId);
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

class ArabicNumberTextController extends TextEditingController {
  final bool isArabic;

  ArabicNumberTextController({
    required this.isArabic,
    String? initialText,
  }) : super(text: isArabic
      ? _convertToArabic(initialText ?? '')
      : initialText ?? '') {
    addListener(_onTextChanged);
  }

  static final Map<String, String> _enToAr = {
    '0': '٠',
    '1': '١',
    '2': '٢',
    '3': '٣',
    '4': '٤',
    '5': '٥',
    '6': '٦',
    '7': '٧',
    '8': '٨',
    '9': '٩',
  };

  static final Map<String, String> _arToEn = {
    '٠': '0',
    '١': '1',
    '٢': '2',
    '٣': '3',
    '٤': '4',
    '٥': '5',
    '٦': '6',
    '٧': '7',
    '٨': '8',
    '٩': '9',
  };

  static String _convertToArabic(String input) {
    return input.split('').map((c) => _enToAr[c] ?? c).join();
  }

  static String _convertToEnglish(String input) {
    return input.split('').map((c) => _arToEn[c] ?? c).join();
  }

  void _onTextChanged() {
    if (!isArabic) return;

    final english = _convertToEnglish(text);
    final converted = _convertToArabic(english);

    if (text != converted) {
      final oldSelection = selection;
      value = value.copyWith(
        text: converted,
        selection: oldSelection.copyWith(
          baseOffset: converted.length,
          extentOffset: converted.length,
        ),
      );
    }
  }

  String get englishText => _convertToEnglish(text);

  @override
  void dispose() {
    removeListener(_onTextChanged);
    super.dispose();
  }
}
