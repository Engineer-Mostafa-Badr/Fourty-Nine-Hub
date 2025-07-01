import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/create_loading_trip_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/ride_loading_request_screen.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_date_picker.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_pickup_container.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/image_text_row.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/pickup_text_form_field.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import '../../../../core/error/failure.dart';
import '../../../../helpers/subscription_method.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';
import '../../../food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import '../../domain/usecases/create_non_track_trip_use_case.dart';
import '../../domain/usecases/make_loading_request_trip_usecase.dart';
import '../../domain/usecases/make_non_tracking_request_trip_usecase.dart';
import '../controllers/client_trips_cubit/client_trips_cubit.dart';
import 'widgets/pickup_target_location_widget.dart';

import 'package:flutter/material.dart';
import 'ride_personal_more_info_screen.dart';

class RidePersonalMoreInfoScreen extends StatefulWidget {
  final bool isTruk;
  final String subCategoryId;
  final String type;

  const RidePersonalMoreInfoScreen(
      {super.key,
      this.isTruk = false,
      required this.subCategoryId,
      required this.type});

  @override
  State<RidePersonalMoreInfoScreen> createState() =>
      _RidePersonalMoreInfoScreenState();
}

class _RidePersonalMoreInfoScreenState
    extends State<RidePersonalMoreInfoScreen> {
  late ClientTripsCubit cubit;
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    cubit = context.read<ClientTripsCubit>();
    cubit.initData(widget.subCategoryId);
    if (widget.isTruk) {
      cubit.makeLoadingTripParam = MakeLoadingRequestTripUsecaseParam();
      log(cubit.makeLoadingTripParam.toJson().toString());
    } else {
      cubit.makeNonTrackingTripParam = MakeNonTrackingRequestTripUsecaseParam();
      log(cubit.makeNonTrackingTripParam.toJson().toString());
    }
  }

  final RegExp _phonePattern =
      RegExp(r'(\+\d{1,3}[\s-]?)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}|'
          r'\d{10}|'
          r'\d{3}[\s.-]\d{3}[\s.-]\d{4}|'
          r'\+\d{10,}');

  Future<String?> showLocationMethodDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Choose Location Method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildOptionButton(
                  context,
                  icon: Icons.format_list_bulleted_rounded,
                  title: 'Choose from List',
                  description: 'Use saved or predefined locations',
                  value: 'list',
                ),
                const SizedBox(height: 16),
                _buildOptionButton(
                  context,
                  icon: Icons.map_rounded,
                  title: 'Pick on Map',
                  description: 'Set a location manually on the map',
                  value: 'map',
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required String value,
  }) {
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.blue.withOpacity(0.1),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue.shade50,
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  String toArabicDigits(String input) {
    const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
    return input.replaceAllMapped(
        RegExp(r'[0-9]'), (match) => arabicDigits[int.parse(match.group(0)!)]);
  }

// Alternative: More control over format
  String formatTimeCustom(TimeOfDay time, BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (isArabic) {
      // For Arabic: use 'ar' locale with custom pattern
      final formatter = DateFormat('h:mm a', 'ar');
      return formatter.format(dateTime);
    } else {
      // For English: use 'en' locale
      final formatter = DateFormat('h:mm a', 'en');
      return formatter.format(dateTime);
    }
  }

// If you need 24-hour format
  String formatTime24Hour(TimeOfDay time, BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    final formatter = DateFormat('HH:mm', isArabic ? 'ar' : 'en');
    return formatter.format(dateTime);
  }

// Helper function to convert English numerals to Arabic numerals
  String convertToArabicNumerals(String input) {
    const englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String result = input;
    for (int i = 0; i < englishDigits.length; i++) {
      result = result.replaceAll(englishDigits[i], arabicDigits[i]);
    }
    return result;
  }

// Alternative: If you want to use NumberFormat for more comprehensive formatting
  String formatTimeWithNumberFormat(TimeOfDay time, BuildContext context) {
    final locale = Localizations.localeOf(context);
    final is24Hour = MediaQuery.of(context).alwaysUse24HourFormat;

    int hour = time.hour;
    String period = '';

    if (!is24Hour) {
      period = time.period == DayPeriod.am ? 'AM' : 'PM';
      if (hour == 0) {
        hour = 12;
      } else if (hour > 12) {
        hour = hour - 12;
      }
    }

    // Format numbers according to locale
    final numberFormat = NumberFormat('00', locale.toString());
    final hourStr = numberFormat.format(hour);
    final minuteStr = numberFormat.format(time.minute);

    if (is24Hour) {
      return '$hourStr:$minuteStr';
    } else {
      return '$hourStr:$minuteStr $period';
    }
  }

  String formatDateWithLocale(DateTime date, BuildContext context) {
    final locale = context.locale.languageCode;
    return DateFormat('dd/MM/yyyy', locale).format(date);
  }

  String formatTimeWithLocale(TimeOfDay time, BuildContext context) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final locale = context.locale.languageCode;
    return DateFormat('hh:mm a', locale).format(dateTime);
  }

  String convertDigits(String input, {required bool toArabic}) {
    const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    return input.split('').map((char) {
      final index = toArabic ? western.indexOf(char) : eastern.indexOf(char);
      if (index == -1) return char;
      return toArabic ? eastern[index] : western[index];
    }).join('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientTripsCubit, ClientTripsState>(
      listener: (context, state) {
        if (state.isErrorCreateTrip) {
          String errorName = getFailureName(state.failure!, context);
          errorName == 'DebtError'
              ? showDebtDialog(
                  context,
                  "",
                  context.isArabic
                      ? "من فضلك ادفع الدين"
                      : 'Please pay the Debt for more trips')
              : errorName == 'SubscribeError'
                  ? showSubscribeDialog(context, widget.subCategoryId)
                  : showErrorMessage(
                      context, getFailureMessage(state.failure!, context));
        }
        if (state.status == ClientTripsStates.error) {
          String errorName = getFailureName(state.failure!, context);
          final failure = state.failure;
          if (failure is ServerFailure) {
            // Try to get errors from the errors list first
            if (failure.errors != null && failure.errors!.isNotEmpty) {
              showErrorMessage(context, failure.errors!.first);
              return;
            }
            errorName == 'DebtError'
                ? showDebtDialog(
                    context,
                    widget.subCategoryId,
                    context.isArabic
                        ? "من فضلك ادفع الدين"
                        : 'Please pay the Debt for more trips')
                : errorName == 'SubscribeError'
                    ? showSubscribeDialog(context, widget.subCategoryId)
                    : showErrorMessage(
                        context, getFailureMessage(state.failure!, context));
          }
        }
        if (state.isSuccessCreateTrip) {
          showCustomSnackBar(
            context,
            // "Cart Update Successfully",
            state.createNonTrackTripEntity?.message ??
                LocaleKeys.requestSentSuccess.localize,
            Icon(Icons.done_all_outlined, color: AppColors.CHECK_MARK_COLOR),
          );
        }
      },
      builder: (context, state) {
        return Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              PickUpLocationCard(cubit: cubit, firstColor: AppColors.c19D176),
              const SizedBox(height: 8),
              PickUpLocationCard(
                  cubit: cubit,
                  firstColor: AppColors.c3897F0,
                  isStartLocation: false),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (cubit.selectedDate.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                context.isArabic
                                    ? 'يرجى اختيار التاريخ أولاً'
                                    : LocaleKeys.pleaseSelectDateFirst.localize,
                              ),
                            ),
                          );
                          return;
                        }

                        final TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          // barrierColor: Colors.blue,
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                textSelectionTheme: TextSelectionThemeData(
                                  cursorColor: AppColors.PRIMARY_COLOR, // ✅ correct way
                                ),


                                timePickerTheme: TimePickerThemeData(
                                  // backgroundColor: Colors.blue,

                                  dayPeriodColor:   context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR_DARK,
                                  // dayPeriodTextColor:  context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                  // dialTextColor: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                  hourMinuteColor:  context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                  dialTextStyle: TextStyle(
                                    fontFamily:
                                        context.isArabic ? 'Tajawal' : null,
                                    fontSize: 16,
                                    color: context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR
                                  ),
                                  hourMinuteTextStyle: TextStyle(
                                    fontFamily:
                                        context.isArabic ? 'Tajawal' : null,
                                    fontSize: 24,
                                      color: context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR
                                  ),
                                  entryModeIconColor:
                                  context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.PRIMARY_COLOR,
                                  hourMinuteTextColor:   context.isDarkMode ? AppColors.PRIMARY_COLOR : AppColors.whiteColor,
                                  dialHandColor: Theme.of(context).primaryColor,
                                  // backgroundColor:   context.isDarkMode ? AppColors.PRIMARY_COLOR_DARK : AppColors.PRIMARY_COLOR
                                ),
                              ),
                              child: Localizations.override(
                                context: context,
                                locale: context.isArabic
                                    ? const Locale('ar', 'EG')
                                    : const Locale('en', 'US'),
                                // ✅ force correct number system
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: false),
                                  child: child!,
                                ),
                              ),
                            );
                          },
                        );

                        if (selectedTime != null) {
                          final now = DateTime.now();

                          // Robust date parsing
                          final parts =
                              cubit.selectedDate.split(RegExp(r'[/-]')).map((part) {
                            // Convert Arabic digits to Latin if needed
                            const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
                            const latinDigits = '0123456789';
                            return part.replaceAllMapped(
                                RegExp('[${arabicDigits}]'),
                                (match) => latinDigits[
                                    arabicDigits.indexOf(match.group(0)!)]);
                          }).toList();

                          if (parts.length != 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.isArabic
                                      ? 'تنسيق التاريخ غير صالح'
                                      : 'Invalid date format',
                                ),
                              ),
                            );
                            return;
                          }

                          final selectedDateParsed = DateTime(
                            int.parse(parts[2]), // year
                            int.parse(parts[1]), // month
                            int.parse(parts[0]), // day
                          );

                          final selectedDateTime = DateTime(
                            selectedDateParsed.year,
                            selectedDateParsed.month,
                            selectedDateParsed.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );

                          final isToday = selectedDateParsed.year == now.year &&
                              selectedDateParsed.month == now.month &&
                              selectedDateParsed.day == now.day;

                          final minTime = now.add(const Duration(minutes: 15));
                          if (isToday && selectedDateTime.isBefore(minTime)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.isArabic
                                      ? 'لا يمكنك اختيار وقت مضى'
                                      : LocaleKeys.youCantChoosePastTime.tr(),
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            cubit.selectedTime =
                                formatTimeWithLocale(selectedTime, context);
                            cubit.makeNonTrackingTripParam.date =
                                selectedDateTime;
                          });
                        }
                      },
                      child: PickUpContainer(
                        fontWeight: FontWeight.w400,
                        title: cubit.selectedTime.isEmpty
                            ? (context.isArabic
                                ? 'اختر الوقت'
                                : LocaleKeys.chooseTheTime.localize)
                            : cubit.selectedTime,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: CustomDatePickerButton(
                      selectedDate: cubit.selectedDate.isEmpty
                          ? LocaleKeys.chooseTheDate.tr()
                          : cubit.selectedDate,
                      onDateSelected: (newDate) {
                        setState(() {
                          cubit.selectedDate = newDate;
                          cubit.selectedTime = ""; // Reset time when date changes

                          // Parse the date safely using multiple formats
                          DateTime parsedDate;
                          try {
                            // Format input string to ensure consistent format
                            final parts = newDate.split('/');
                            if (parts.length == 3) {
                              // Make sure month has leading zero if needed
                              final day = parts[0];
                              final month = parts[1].length == 1
                                  ? '0${parts[1]}'
                                  : parts[1];
                              final year = parts[2];

                              // Now parse with consistent format
                              parsedDate = DateFormat('dd/MM/yyyy')
                                  .parse('$day/$month/$year');
                            } else {
                              // Fallback for unexpected format
                              throw FormatException('Invalid date format');
                            }
                          } catch (e) {
                            // Try alternative parsing methods
                            try {
                              parsedDate = DateTime.parse(newDate);
                            } catch (_) {
                              // Last resort: use current date
                              print(
                                  'Failed to parse date: $newDate, using current date');
                              parsedDate = DateTime.now();
                            }
                          }

                          final now = DateTime.now();

                          // Set initial time to current time or start of day for future dates
                          DateTime initialTime;
                          if (parsedDate.year == now.year &&
                              parsedDate.month == now.month &&
                              parsedDate.day == now.day) {
                            // If today, use current time
                            initialTime = now;
                          } else {
                            // If future date, set to start of day
                            initialTime = DateTime(parsedDate.year,
                                parsedDate.month, parsedDate.day);
                          }

                          if (widget.type == 'shipping') {
                            cubit.makeLoadingTripParam.date = initialTime;
                          } else {
                            cubit.makeNonTrackingTripParam.date = initialTime;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (widget.type != 'shipping')
                PickUpTextFormField(
                  fieldType: FieldType.phone,
                  controller: cubit.passengerController,
                  onChanged: (value) {
                    // if (context.isArabic) {
                    //   final formatted = convertDigits(value, toArabic: true);
                    //   final selectionIndex = formatted.length;
                    //
                    //   cubit.passengerController.value = TextEditingValue(
                    //     text: formatted,
                    //     selection:
                    //         TextSelection.collapsed(offset: selectionIndex),
                    //   );
                    //
                    //   final englishValue =
                    //       convertDigits(formatted, toArabic: false);
                    //   cubit.makeNonTrackingTripParam.passengers =
                    //       int.tryParse(englishValue); // ✅ parsed to int
                    // } else {
                    //   cubit.passengerController.text = value;
                    //   cubit.makeNonTrackingTripParam.passengers =
                    //       int.tryParse(value); // ✅ parsed to int
                    // }
                    if (context.isArabic) {
                      final formatted = convertDigits(value, toArabic: true);
                      final selectionIndex = formatted.length;

                      cubit.passengerController.value = TextEditingValue(
                        text: formatted,
                        selection: TextSelection.collapsed(offset: selectionIndex),
                      );

                      final englishValue = convertDigits(formatted, toArabic: false);
                      cubit.makeNonTrackingTripParam.passengers = int.tryParse(englishValue);
                    } else {
                      cubit.passengerController.text = value;
                      cubit.makeNonTrackingTripParam.passengers = int.tryParse(value);
                    }

                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.required.localize;
                    }

                    final parsedNumber = int.tryParse(value);
                    if (parsedNumber == null) {
                      return context.isArabic
                          ? 'الرجاء إدخال رقم صالح'
                          : 'Please enter a valid number.';
                    }

                    if (parsedNumber < 0) {
                      return context.isArabic
                          ? 'لا يمكن أن يكون الرقم سالباً'
                          : 'Number cannot be negative.';
                    }

                    if (parsedNumber > 1000) {
                      return context.isArabic
                          ? 'لا يمكن أن يكون الرقم أكبر من 1000'
                          : 'Number cannot be greater than 1000.';
                    }

                    return null;
                  },
                  hintText: convertDigits(
                    LocaleKeys.numberOfPassenger.localize,
                    toArabic: context.isArabic,
                  ),
                ),
              if (widget.type == 'shipping')
                PickUpTextFormField(
                  fieldType: FieldType.text,
                  controller: cubit.descController,
                  onChanged: (v) => formKey.currentState!.validate(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.required.localize;
                    }
                    return null;
                  },
                  maxLines: 4,
                  hintText: context.isArabic ? 'الوصف' : 'Cargo Description',
                ),
              const SizedBox(height: 8),
              PickUpTextFormField(
                fieldType: FieldType.phone,
                controller: cubit.phoneController,
                // validator: (value) {
                //   if (value == null || value.isEmpty) {
                //     return LocaleKeys.required.localize;
                //   }
                //
                //   if (_phonePattern.hasMatch(value)) {
                //     return context.isArabic
                //         ? 'غير مسموح برقم الهاتف.'
                //         : 'Phone numbers are not allowed.';
                //   }
                //
                //   // Remove any non-digit characters (if needed)
                //   final numericValue = value.replaceAll(RegExp(r'\D'), '');
                //
                //   // Ensure it's exactly 11 digits
                //   if (numericValue.length != 11) {
                //     return context.isArabic
                //         ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                //         : 'Phone number must be exactly 11 digits.';
                //   }
                //
                //   // Check if the number starts with a valid prefix
                //   if (!numericValue.startsWith('010') &&
                //       !numericValue.startsWith('011') &&
                //       !numericValue.startsWith('012') &&
                //       !numericValue.startsWith('015')) {
                //     return context.isArabic
                //         ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                //         : 'Phone number must start with 010, 011, 012, or 015.';
                //   }
                //
                //   return null; // ✅ Valid
                // },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleKeys.required.localize;
                  }

                  final numericValue = convertDigits(value, toArabic: false);

                  if (numericValue.length != 11) {
                    return context.isArabic
                        ? 'يجب أن يحتوي رقم الهاتف على 11 رقمًا'
                        : 'Phone number must be exactly 11 digits.';
                  }

                  if (!numericValue.startsWith('010') &&
                      !numericValue.startsWith('011') &&
                      !numericValue.startsWith('012') &&
                      !numericValue.startsWith('015')) {
                    return context.isArabic
                        ? 'رقم الهاتف يجب أن يبدأ بـ 010 أو 011 أو 012 أو 015'
                        : 'Phone number must start with 010, 011, 012, or 015.';
                  }

                  return null;
                },

                onChanged: (value) {
                  if (widget.type == 'shipping') {
                    cubit.makeNonTrackingTripParam.phone = value;
                  } else {
                    cubit.makeNonTrackingTripParam.phone = value;
                  }
                },
                maxLines: 1,
                hintText:  LocaleKeys.phone.localize,
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _showOfferFareBottomSheet(context),
                child: PickUpContainer(
                  title: cubit.offerPrice.isEmpty
                      ? LocaleKeys.offerPrice.localize
                      : convertDigits(cubit.offerPrice, toArabic: context.isArabic),
                ),
              ),
              const SizedBox(height: 8),
              ImageTextRow(
                  imagePath: Assets.logo,
                  text: LocaleKeys.appNotDeduct.localize),
              const SizedBox(height: 8),
              ImageTextRow(
                  imagePath: Assets.logo,
                  text: LocaleKeys.premiumPackageCashBack.localize),
              const SizedBox(height: 8),
              ImageTextRow(
                  imagePath: Assets.logo,
                  text: LocaleKeys.freeCancellation.localize),
              const SizedBox(height: 15),
              state.isLoadingSubmit
                  ? const Center(child: CustomCircularProgressIndicator())
                  : SizedBox(
                      height: 40,
                      child: Row(
                        spacing: 6,
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppButton(
                              radius: 15,
                              label: LocaleKeys.premiumRequest.tr(),
                              onPressed: () {
                                if (!context.isUserLoggedIn) {
                                  context.push(Routes.LOGIN);
                                  return;
                                }
                                final price =
                                    double.tryParse(cubit.offerPrice) ?? 0.0;
                                final passengerText = cubit.passengerController.text;
                                final passengerCount =
                                    int.tryParse(passengerText) ?? 0;

                                if (widget.type == 'shipping') {
                                  final p = cubit.makeNonTrackingTripParam
                                    ..price = price
                                    ..desc = cubit.descController.text;

                                  if (!_validateRequiredShippingFields(
                                      p, price)) {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys
                                          .pleaseFillAllRequiredFields.localize,
                                    );
                                    return;
                                  }
                                  final tripParams = CreateLoadingTripParams(
                                      subcategoryId: widget.subCategoryId,
                                      fromTitle: p.fromTitle!,
                                      toTitle: p.toTitle!,
                                      price: price,
                                      date: p.date!,
                                      phone: p.phone!,
                                      passengers: passengerCount,
                                      isPremium: true,
                                      description: p.description ?? '',
                                      desc: cubit.descController.text);

                                  cubit.createShippingTrip(
                                      params: tripParams, context: context);
                                } else {
                                  if (passengerCount > 1000) {
                                    showErrorMessage(
                                      context,
                                      context.isArabic
                                          ? 'لا يمكن أن يكون عدد الركاب أكبر من 1000'
                                          : 'Passenger count cannot be greater than 1000',
                                    );
                                    return;
                                  }

                                  final p = cubit.makeNonTrackingTripParam
                                    ..passengers = passengerCount;

                                  if (!_validateRequiredFields(p, price)) {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys
                                          .pleaseFillAllRequiredFields.localize,
                                    );
                                    return;
                                  }

                                  final tripParams = CreateNonTrackTripParams(
                                      subcategoryId: widget.subCategoryId,
                                      fromTitle: p.fromTitle!,
                                      toTitle: p.toTitle!,
                                      price: price,
                                      date: p.date!,
                                      phone: p.phone!,
                                      passengers: passengerCount,
                                      isPremium: true,
                                      description: p.description ?? '',
                                      desc: cubit.descController.text);

                                  cubit.createNonTrackTrip(
                                      params: tripParams, context: context);
                                }
                              },
                              backColor: AppColors.SECONDARY_COLOR_DARK2,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          //Free
                          Expanded(
                            flex: 2,
                            child: AppButton(
                              radius: 15,
                              label: LocaleKeys.request.tr(),
                              onPressed: () {
                                if (!context.isUserLoggedIn) {
                                  context.push(Routes.LOGIN);
                                  return;
                                }

                                final price = double.tryParse(cubit.offerPrice) ?? 0.0;
                                final passengerText = cubit.passengerController.text;
                                final passengerCount =
                                    int.tryParse(passengerText) ?? 0;

                                if (passengerCount > 1000) {
                                  showErrorMessage(
                                    context,
                                    context.isArabic
                                        ? 'لا يمكن أن يكون عدد الركاب أكبر من 1000'
                                        : 'Passenger count cannot be greater than 1000',
                                  );
                                  return;
                                }

                                if (widget.isTruk) {
                                  cubit.makeLoadingTripParam
                                    ..isPremium = false
                                    ..price = price
                                  ..phone=cubit.phoneController.text;
                                  // ..date = cubit.selectedDate;

                                  if (!_validateLoadingTripParams(
                                      cubit.makeLoadingTripParam)) {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys
                                          .pleaseFillAllRequiredFields.localize,
                                    );
                                    return;
                                  }

                                  final tripParams = CreateLoadingTripParams(
                                    subcategoryId: widget.subCategoryId,
                                    fromTitle: cubit.makeLoadingTripParam.fromTitle??'',
                                    toTitle: cubit.makeLoadingTripParam.toTitle??'',
                                    price: price,
                                    date: cubit.makeLoadingTripParam.date!,
                                    phone: cubit.makeLoadingTripParam.phone??'',
                                    passengers: passengerCount,
                                    isPremium: false,
                                    description: cubit.makeLoadingTripParam.description ?? '', desc: cubit.descController.text,
                                  );


                                  cubit.createShippingTrip(params:tripParams,context: context);
                                } else {
                                  final p = cubit.makeNonTrackingTripParam
                                    ..passengers = passengerCount;

                                  if (!_validateRequiredFields(p, price)) {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys
                                          .pleaseFillAllRequiredFields.localize,
                                    );
                                    return;
                                  }

                                  final tripParams = CreateNonTrackTripParams(
                                    subcategoryId: widget.subCategoryId,
                                    fromTitle: p.fromTitle!,
                                    toTitle: p.toTitle!,
                                    price: price,
                                    date: p.date!,
                                    phone: p.phone!,
                                    passengers: passengerCount,
                                    isPremium: false,
                                    description: p.description ?? '', desc: cubit.descController.text,
                                  );

                                  cubit.createNonTrackTrip(
                                      params: tripParams, context: context);
                                }
                              },
                              backColor: AppColors.PRIMARY_COLOR,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),

                          /*
                          Expanded(
                            flex: 2,
                            child: AppButton(
                              radius: 15,
                              label: LocaleKeys.premiumRequest.tr(),
                              onPressed: () {
                                if (!context.isUserLoggedIn) {
                                  context.push(Routes.LOGIN);
                                  return;
                                }

                                final price = double.tryParse(cubit.offerPrice) ?? 0.0;
                                final passengerText = cubit.passengerController.text;
                                final passengerCount = int.tryParse(passengerText) ?? 0;

                                if (passengerCount > 1000) {
                                  showErrorMessage(
                                    context,
                                    context.isArabic
                                        ? 'لا يمكن أن يكون عدد الركاب أكبر من 1000'
                                        : 'Passenger count cannot be greater than 1000',
                                  );
                                  return;
                                }



                                  if (_validateLoadingTripParams(cubit.makeLoadingTripParam)) {
                                    cubit.makeLoadingRequestTrip(context);
                                  } else {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys.pleaseFillAllRequiredFields.localize,
                                    );
                                  }

                                  final p = cubit.makeNonTrackingTripParam
                                    ..passengers = passengerCount;

                                  if (_validateRequiredFields(p, price)) {
                                    final tripParams = CreateNonTrackTripParams(
                                      subcategoryId: widget.subCategoryId,
                                      fromTitle: p.fromTitle!,
                                      toTitle: p.toTitle!,
                                      price: price,
                                      date: p.date!,
                                      phone: p.phone!,
                                      passengers: passengerCount,
                                      isPremium: true,
                                      description: p.description ?? '',
                                    );
                                    cubit.createNonTrackTrip(params: tripParams,context: context);
                                  } else {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys.pleaseFillAllRequiredFields.localize,
                                    );
                                  }

                              },
                              backColor: AppColors.SECONDARY_COLOR_DARK2,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AppButton(
                              radius: 15,
                              label: LocaleKeys.request.tr(),
                              onPressed: () {
                                if (!context.isUserLoggedIn) {
                                  context.push(Routes.LOGIN);
                                  return;
                                }

                                final price = double.tryParse(cubit.offerPrice) ?? 0.0;
                                final passengerText = cubit.passengerController.text;
                                final passengerCount = int.tryParse(passengerText) ?? 0;

                                if (passengerCount > 1000) {
                                  showErrorMessage(
                                    context,
                                    context.isArabic
                                        ? 'لا يمكن أن يكون عدد الركاب أكبر من 1000'
                                        : 'Passenger count cannot be greater than 1000',
                                  );
                                  return;
                                }

                                if (widget.isTruk) {
                                  cubit.makeLoadingTripParam
                                    ..isPremium = false
                                    ..price = price;

                                  if (_validateLoadingTripParams(cubit.makeLoadingTripParam)) {
                                    cubit.makeLoadingRequestTrip(context);
                                  } else {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys.pleaseFillAllRequiredFields.localize,
                                    );
                                  }
                                } else {
                                  final p = cubit.makeNonTrackingTripParam
                                    ..passengers = passengerCount;

                                  if (_validateRequiredFields(p, price)) {
                                    final tripParams = CreateNonTrackTripParams(
                                      subcategoryId: widget.subCategoryId,
                                      fromTitle: p.fromTitle!,
                                      toTitle: p.toTitle!,
                                      price: price,
                                      date: p.date!,
                                      phone: p.phone!,
                                      passengers: passengerCount,
                                      isPremium: false,
                                      description: p.description ?? '',
                                    );
                                    cubit.createNonTrackTrip(params: tripParams, context: context);
                                  } else {
                                    showErrorMessage(
                                      context,
                                      LocaleKeys.pleaseFillAllRequiredFields.localize,
                                    );
                                  }
                                }
                              },
                              backColor: AppColors.PRIMARY_COLOR,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
          */

                          // Expanded(
                          //     flex: 2,
                          //     child: AppButton(
                          //         radius: 15,
                          //         label: LocaleKeys.premiumRequest.tr(),
                          //         onPressed: () {
                          //           if (context.isUserLoggedIn) {
                          //             if (widget.isTruk) {
                          //               cubit.makeLoadingTripParam.isPremium =
                          //                   true;
                          //               cubit.makeLoadingTripParam.price =
                          //                   double.tryParse(cubit.offerPrice) ?? 0.0;
                          //               log(cubit.makeLoadingTripParam
                          //                   .toJson()
                          //                   .toString());
                          //               if (cubit.makeLoadingTripParam.date ==
                          //                       null ||
                          //                   cubit.makeLoadingTripParam.phone ==
                          //                       null ||
                          //                   cubit.makeLoadingTripParam.phone!
                          //                       .isEmpty ||
                          //                   cubit.makeLoadingTripParam.price ==
                          //                       0.0) {
                          //                 showErrorMessage(context,
                          //                     LocaleKeys.pleaseFillAllRequiredFields.localize);
                          //               } else {
                          //                 cubit.makeLoadingRequestTrip(context);
                          //               }
                          //             } else {
                          //               cubit.makeNonTrackingTripParam.isPremium =
                          //                   true;
                          //               cubit.makeNonTrackingTripParam
                          //                   .subcategoryId = widget.subCategoryId;
                          //               cubit.makeNonTrackingTripParam.price =
                          //                   double.tryParse(cubit.offerPrice) ?? 0.0;
                          //               log(cubit.makeNonTrackingTripParam
                          //                   .toJson()
                          //                   .toString());
                          //               if (cubit.makeNonTrackingTripParam.date == null ||
                          //                   cubit.makeNonTrackingTripParam.phone ==
                          //                       null ||
                          //                   cubit.makeNonTrackingTripParam.phone!
                          //                       .isEmpty ||
                          //                   cubit.makeNonTrackingTripParam
                          //                           .price ==
                          //                       0.0 ||
                          //                   (!widget.isTruk &&
                          //                       (cubit.makeNonTrackingTripParam
                          //                                   .passengers ==
                          //                               null ||
                          //                           cubit.makeNonTrackingTripParam
                          //                                   .passengers ==
                          //                               0))) {
                          //                 showErrorMessage(context,
                          //                     LocaleKeys.pleaseFillAllRequiredFields.localize);
                          //               } else {
                          //                 cubit.makeNonTrackingRequestTrip(
                          //                     context);
                          //               }
                          //             }
                          //           } else {
                          //             context.push(Routes.LOGIN);
                          //           }
                          //         },
                          //         backColor: AppColors.SECONDARY_COLOR_DARK2,
                          //         width: MediaQuery.of(context).size.width)),
                          // Expanded(
                          //     flex: 2,
                          //     child: AppButton(
                          //         radius: 15,
                          //         label: LocaleKeys.request.tr(),
                          //         onPressed: () async {
                          //           if (context.isUserLoggedIn) {
                          //             if (widget.isTruk) {
                          //               cubit.makeLoadingTripParam.isPremium =
                          //                   false;
                          //               cubit.makeLoadingTripParam.price =
                          //                   double.tryParse(cubit.offerPrice) ?? 0.0;
                          //               log(cubit.makeLoadingTripParam
                          //                   .toJson()
                          //                   .toString());
                          //               if (cubit.makeLoadingTripParam.date ==
                          //                       null ||
                          //                   cubit.makeLoadingTripParam.phone ==
                          //                       null ||
                          //                   cubit.makeLoadingTripParam.phone!
                          //                       .isEmpty ||
                          //                   cubit.makeLoadingTripParam.price ==
                          //                       0.0) {
                          //                 showErrorMessage(context,
                          //                     LocaleKeys.pleaseFillAllRequiredFields.localize);
                          //               } else {
                          //                 cubit.makeLoadingRequestTrip(context);
                          //               }
                          //             } else {
                          //               cubit.makeNonTrackingTripParam.isPremium =
                          //                   false;
                          //               cubit.makeNonTrackingTripParam
                          //                   .subcategoryId = widget.subCategoryId;
                          //               cubit.makeNonTrackingTripParam.price =
                          //                   double.tryParse(cubit.offerPrice) ?? 0.0;
                          //               log(cubit.makeNonTrackingTripParam
                          //                   .toJson()
                          //                   .toString());
                          //               if (cubit.makeNonTrackingTripParam.date == null ||
                          //                   cubit.makeNonTrackingTripParam.phone ==
                          //                       null ||
                          //                   cubit.makeNonTrackingTripParam.phone!
                          //                       .isEmpty ||
                          //                   cubit.makeNonTrackingTripParam
                          //                           .price ==
                          //                       0.0 ||
                          //                   (!widget.isTruk &&
                          //                       (cubit.makeNonTrackingTripParam
                          //                                   .passengers ==
                          //                               null ||
                          //                           cubit.makeNonTrackingTripParam
                          //                                   .passengers ==
                          //                               0))) {
                          //                 showErrorMessage(context,
                          //                     LocaleKeys.pleaseFillAllRequiredFields.localize);
                          //               } else {
                          //                 cubit.makeNonTrackingRequestTrip(
                          //                     context);
                          //               }
                          //             }
                          //           } else {
                          //             context.push(Routes.LOGIN);
                          //           }
                          //         },
                          //         backColor: AppColors.PRIMARY_COLOR,
                          //         width: MediaQuery.of(context).size.width)),
                        ],
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  bool _validateLoadingTripParams(dynamic param) {
    print("param.date ${param.date}");
    print("param.phone ${param.phone}");
    print("param.price ${param.price}");
    return param.date != null &&
        param.phone != null &&
        param.phone!.isNotEmpty &&
        param.price != null &&
        param.price > 0.0;
  }

  bool _validateRequiredFields(var p, double price) {
    return p.date != null &&
        p.phone != null &&
        p.phone!.isNotEmpty &&
        price > 0.0 &&
        p.passengers != null &&
        p.passengers! > 0 &&
        p.fromTitle != null &&
        p.fromTitle!.isNotEmpty &&
        p.toTitle != null &&
        p.toTitle!.isNotEmpty;
  }

  bool _validateRequiredShippingFields(var p, double price) {
    print('price $price');
    print('p.date ${p.date}');
    print('p.phone ${p.phone}');
    print('p.desc ${p.desc}');
    print('p.fromTitle ${p.fromTitle}');
    print('p.toTitle ${p.toTitle}');
    return p.date != null &&
        p.phone != null &&
        p.phone!.isNotEmpty &&
        p.desc != null &&
        p.desc!.isNotEmpty &&
        price > 0.0 &&
        p.fromTitle != null &&
        p.fromTitle!.isNotEmpty &&
        p.toTitle != null &&
        p.toTitle!.isNotEmpty;
  }

  void _showOfferFareBottomSheet(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    String _convertToArabicDigits(String input) {
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
      const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

      String output = input;
      for (int i = 0; i < english.length; i++) {
        output = output.replaceAll(english[i], arabic[i]);
      }
      return output;
    }

    String _convertToEnglishDigits(String input) {
      const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
      const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

      String output = input;
      for (int i = 0; i < arabic.length; i++) {
        output = output.replaceAll(arabic[i], english[i]);
      }
      return output;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      isScrollControlled: true,
      isDismissible: false,
      // Prevent tap outside to close
      enableDrag: false,
      // Prevent swipe down to close
      builder: (context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Label(
                            text: LocaleKeys.offerYourFare.localize,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              cubit.offerPriceController.clear();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.cEEEEEEE,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: AppColors.PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      cursorColor: AppColors.PRIMARY_COLOR,
                      controller: cubit.offerPriceController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: isArabic ? "جم" : "EGP",
                        hintStyle: const TextStyle(
                          fontSize: 40,
                          color: AppColors.c96979B,
                        ),
                        border: const UnderlineInputBorder(),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      enableInteractiveSelection: false,
                      contextMenuBuilder: (context, editableTextState) =>
                          const SizedBox.shrink(),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9٠-٩]')),
                        LengthLimitingTextInputFormatter(9),
                        NoPasteFormatter(),
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                      onChanged: (value) {
                        if (isArabic) {
                          final englishValue = _convertToEnglishDigits(value);
                          final arabicValue =
                              _convertToArabicDigits(englishValue);
                          if (arabicValue != value) {
                            final cursorPos =
                                cubit.offerPriceController.selection.base.offset;
                            cubit.offerPriceController.value =
                                cubit.offerPriceController.value.copyWith(
                              text: arabicValue,
                              selection: TextSelection.collapsed(
                                offset: cursorPos == -1
                                    ? arabicValue.length
                                    : cursorPos,
                              ),
                            );
                          }
                        }
                      },
                      validator: (value) {
                        final englishValue = value != null
                            ? _convertToEnglishDigits(value)
                            : null;

                        if (englishValue == null || englishValue.isEmpty) {
                          return isArabic
                              ? 'هذا الحقل مطلوب'
                              : 'This field is required';
                        }

                        final numValue = int.tryParse(englishValue);
                        if (numValue == null) {
                          return isArabic
                              ? 'الرجاء إدخال رقم صحيح'
                              : 'Please enter a valid number';
                        }

                        if (numValue < 100) {
                          return isArabic
                              ? 'الرقم يجب أن لا يقل عن 100'
                              : 'The number must be at least 100';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: 50),
                    AppButton(
                      radius: 15,
                      backColor: AppColors.PRIMARY_COLOR,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          setState(() {
                            cubit.offerPrice = _convertToEnglishDigits(
                                cubit.offerPriceController.text);
                          });
                        }
                      },
                      label: LocaleKeys.done.localize,
                      style: const TextStyle(
                        color: AppColors.LIGHT_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class NoPasteFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Prevent pasted text by comparing lengths
    if (newValue.text.length - oldValue.text.length > 1) {
      return oldValue;
    }
    return newValue;
  }
}
