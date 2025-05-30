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

  const RidePersonalMoreInfoScreen(
      {super.key, this.isTruk = false, required this.subCategoryId});

  @override
  State<RidePersonalMoreInfoScreen> createState() =>
      _RidePersonalMoreInfoScreenState();
}

class _RidePersonalMoreInfoScreenState
    extends State<RidePersonalMoreInfoScreen> {
  String _selectedTime = '';
  String _selectedDate = '';
  String offerPrice = '';
  late ClientTripsCubit cubit;
  TextEditingController phoneController = TextEditingController();
  TextEditingController passengerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = context.read<ClientTripsCubit>();
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

  // Future<String?> showLocationMethodDialog(BuildContext context) async {
  //   return await showDialog<String>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text("Choose Location"),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.list),
  //               title: Text("List"),
  //               onTap: () => Navigator.pop(context, 'list'),
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.map),
  //               title: Text("Map"),
  //               onTap: () => Navigator.pop(context, 'map'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  String _formatToArabicDigitsIfNeeded(BuildContext context, String input) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    if (!isArabic) return input;

    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    String output = input;
    for (int i = 0; i < english.length; i++) {
      output = output.replaceAll(english[i], arabic[i]);
    }
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientTripsCubit, ClientTripsState>(
      listener: (context, state) {
        if (state.isErrorCreateTrip) {
          String errorName = getFailureName(state.failure!, context);
          errorName == 'DebtError'
              ? showDebtDialog(context, '')
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
                ? showDebtDialog(context, widget.subCategoryId)
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
        return ListView(
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
                  child: CustomDatePickerButtonNonSocket(
                    icon: Icons.date_range,
                    selectedDate: _selectedDate.isEmpty
                        ? LocaleKeys.date.tr()
                        : _formatToArabicDigitsIfNeeded(context, _selectedDate),
                    onDateSelected: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        _selectedTime = ""; // Reset time when date changes

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

                        if (widget.isTruk) {
                          cubit.makeLoadingTripParam.date = initialTime;
                        } else {
                          cubit.makeNonTrackingTripParam.date = initialTime;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (_selectedDate.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  LocaleKeys.pleaseSelectDateFirst.localize)),
                        );
                        return;
                      }

                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        final now = DateTime.now();

                        // Robust date parsing
                        final parts = _selectedDate.split(RegExp(r'[/-]'));
                        if (parts.length != 3) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Invalid date format')),
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

                        // Rest of your existing code...
                        final isToday = selectedDateParsed.year == now.year &&
                            selectedDateParsed.month == now.month &&
                            selectedDateParsed.day == now.day;

                        final minTime = now.add(Duration(minutes: 15));
                        if (isToday && selectedDateTime.isBefore(minTime)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    _formatToArabicDigitsIfNeeded(context, LocaleKeys.time.tr()))),
                          );
                          return;
                        }

                        setState(() {
                          _selectedTime = _formatToArabicDigitsIfNeeded(context, selectedTime.format(context));
                          if (widget.isTruk) {
                            cubit.makeLoadingTripParam.date = selectedDateTime;
                          } else {
                            cubit.makeNonTrackingTripParam.date =
                                selectedDateTime;
                          }
                        });
                      }
                    },
                    child: PickUpContainerNonSocket(
                      icon: Icons.access_time,
                      fontWeight: FontWeight.w400,
                      title: _selectedTime.isEmpty
                          ? LocaleKeys.chooseTheTime.localize
                          : _formatToArabicDigitsIfNeeded(context, _selectedTime),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PickUpTextFormField(
              icon: Icon(Icons.people_alt_outlined),
              fieldType: FieldType.phone,
              controller: passengerController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return LocaleKeys.required.localize;
                }

                if (_phonePattern.hasMatch(value)) {
                  return context.isArabic
                      ? 'غير مسموح بالرقم الهاتف. برجاء حذف الرقم الهاتف الموجود'
                      : 'Phone numbers are not allowed. Please remove any phone number pattern.';
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
              onChanged: (value) {
                // if (widget.isTruk) {
                //   cubit.makeLoadingTripParam. = value;
                // } else {
                //   cubit.makeNonTrackingTripParam.phone = value;
                // }
              },
              hintText: LocaleKeys.numberOfPassenger.localize,
            ),
            const SizedBox(height: 8),
            // PickUpTextFormField(
            //   icon: Icon(Icons.phone),
            //   fieldType: FieldType.phone,
            //   controller: phoneController,
            //   validator: (value) {
            //     if ((value == null || value.isEmpty)) {
            //       return LocaleKeys.required.localize;
            //     }
            //     if (_phonePattern.hasMatch(value)) {
            //       return context.isArabic
            //           ? 'غير مسموح بالرقم الهاتف. برجاء حذف الرقم الهاتف الموجود'
            //           : 'Phone numbers are not allowed. Please remove any phone number pattern.';
            //     }
            //
            //     return null;
            //   },
            //   onChanged: (value) {
            //     if (widget.isTruk) {
            //       cubit.makeLoadingTripParam.phone = value;
            //     } else {
            //       cubit.makeNonTrackingTripParam.phone = value;
            //     }
            //   },
            //   maxLines: 1,
            //   hintText: cubit.makeNonTrackingTripParam.phone == null ||
            //           cubit.makeNonTrackingTripParam.phone!.isEmpty
            //       ? LocaleKeys.phone.localize
            //       : cubit.makeNonTrackingTripParam.phone!,
            // ),
            PickUpTextFormField(

              icon: Icon(Icons.phone),
              fieldType: FieldType.phone,
              controller: phoneController,
              validator: (value) {
                if ((value == null || value.isEmpty)) {
                  return LocaleKeys.required.localize;
                }
                if (_phonePattern.hasMatch(value)) {
                  return context.isArabic
                      ? 'غير مسموح بالرقم الهاتف. برجاء حذف الرقم الهاتف الموجود'
                      : 'Phone numbers are not allowed. Please remove any phone number pattern.';
                }
                return null;
              },
              onChanged: (value) {
                // cubit.updatePhone(value); // value will be in English digits
              },
              hintText: LocaleKeys.phone.localize,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showOfferFareBottomSheet(context),
              child: PickUpContainerNonSocket(
                icon: Icons.local_offer_outlined,
                title: offerPrice.isEmpty
                    ? LocaleKeys.offerPrice.localize
                    : context.isArabic
                    ? _formatToArabicDigitsIfNeeded(context,offerPrice)
                    : offerPrice,
              ),
            ),
            const SizedBox(height: 8),
            ImageTextRow(
                imagePath: Assets.logo, text: LocaleKeys.appNotDeduct.localize),
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
                              final price = double.tryParse(offerPrice) ?? 0.0;
                              final passengerText = passengerController.text;
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
                              );

                              cubit.createNonTrackTrip(
                                  params: tripParams, context: context);
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

                              final price = double.tryParse(offerPrice) ?? 0.0;
                              final passengerText = passengerController.text;
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
                                  ..price = price;

                                if (!_validateLoadingTripParams(
                                    cubit.makeLoadingTripParam)) {
                                  showErrorMessage(
                                    context,
                                    LocaleKeys
                                        .pleaseFillAllRequiredFields.localize,
                                  );
                                  return;
                                }

                                // cubit.makeLoadingRequestTrip(context);
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
                                  description: p.description ?? '',
                                );

                                cubit.createNonTrackTrip(
                                    params: tripParams, context: context);
                              }
                            },
                            backColor: AppColors.PRIMARY_COLOR,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),


                      ],
                    ),
                  )
          ],
        );
      },
    );
  }

  bool _validateLoadingTripParams(dynamic param) {
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
  void _showOfferFareBottomSheet(BuildContext context) {
    final TextEditingController offerPriceController = TextEditingController();
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
      enableDrag: false,
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
                              offerPriceController.clear();
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
                      controller: offerPriceController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: isArabic ? _convertToArabicDigits("EGP") : "EGP",
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
                          final arabicValue = _convertToArabicDigits(englishValue);
                          if (arabicValue != value) {
                            final cursorPos = offerPriceController.selection.base.offset;
                            offerPriceController.value = offerPriceController.value.copyWith(
                              text: arabicValue,
                              selection: TextSelection.collapsed(
                                offset: cursorPos == -1 ? arabicValue.length : cursorPos,
                              ),
                            );
                          }
                        }
                      },
                      validator: (value) {
                        final englishValue = value != null ? _convertToEnglishDigits(value) : null;

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
                            offerPrice = _convertToEnglishDigits(offerPriceController.text);
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


  // void _showOfferFareBottomSheet(BuildContext context) {
  //   final TextEditingController offerPriceController = TextEditingController();
  //   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: AppColors.whiteColor,
  //     isScrollControlled: true,
  //     isDismissible: false,
  //     // Prevent tap outside to close
  //     enableDrag: false,
  //     // Prevent swipe down to close
  //     builder: (context) {
  //       return FractionallySizedBox(
  //         alignment: Alignment.bottomCenter,
  //         heightFactor: 0.75,
  //         child: Padding(
  //           padding: const EdgeInsets.all(16),
  //           child: SingleChildScrollView(
  //             child: Form(
  //               key: formKey,
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Stack(
  //                     alignment: Alignment.center,
  //                     children: [
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Label(
  //                           text: LocaleKeys.offerYourFare.localize,
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w500,
  //                             color: AppColors.PRIMARY_COLOR,
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                       Align(
  //                         alignment: Alignment.centerRight,
  //                         child: GestureDetector(
  //                           onTap: () {
  //                             offerPriceController.clear(); // ✅ Clear input
  //                             Navigator.pop(context); // ✅ Then close
  //                           },
  //                           child: Container(
  //                             width: 40,
  //                             height: 40,
  //                             decoration: const BoxDecoration(
  //                               color: AppColors.cEEEEEEE,
  //                               shape: BoxShape.circle,
  //                             ),
  //                             child: const Icon(
  //                               Icons.close,
  //                               color: AppColors.PRIMARY_COLOR,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 16),
  //                   TextFormField(
  //                     cursorColor: AppColors.PRIMARY_COLOR,
  //                     controller: offerPriceController,
  //                     decoration: const InputDecoration(
  //                       filled: true,
  //                       fillColor: Colors.white,
  //                       hintText: "EGP",
  //                       hintStyle: TextStyle(
  //                         fontSize: 40,
  //                         color: AppColors.c96979B,
  //                       ),
  //                       border: UnderlineInputBorder(),
  //                       focusedBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.blue, width: 2),
  //                       ),
  //                       enabledBorder: UnderlineInputBorder(
  //                         borderSide: BorderSide(color: Colors.grey, width: 1),
  //                       ),
  //                     ),
  //                     keyboardType: TextInputType.number,
  //                     enableInteractiveSelection: false,
  //                     contextMenuBuilder: (context, editableTextState) =>
  //                         const SizedBox.shrink(),
  //                     inputFormatters: [
  //                       FilteringTextInputFormatter.digitsOnly,
  //                       LengthLimitingTextInputFormatter(9), // ✅ Max 9 digits
  //                       NoPasteFormatter(),
  //                     ],
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: AppColors.PRIMARY_COLOR,
  //                     ),
  //                     validator: (value) {
  //                       if (value == null || value.isEmpty) {
  //                         return context.isArabic
  //                             ? 'هذا الحقل مطلوب'
  //                             : 'This field is required';
  //                       }
  //
  //                       final numValue = int.tryParse(value);
  //                       if (numValue == null) {
  //                         return context.isArabic
  //                             ? 'الرجاء إدخال رقم صحيح'
  //                             : 'Please enter a valid number';
  //                       }
  //
  //                       if (numValue < 100) {
  //                         return context.isArabic
  //                             ? 'الرقم يجب أن لا يقل عن 100'
  //                             : 'The number must be at least 100';
  //                       }
  //
  //                       return null; // Valid
  //                     },
  //                   ),
  //                   const SizedBox(height: 50),
  //                   AppButton(
  //                     radius: 15,
  //                     backColor: AppColors.PRIMARY_COLOR,
  //                     onPressed: () {
  //                       if (formKey.currentState!.validate()) {
  //                         Navigator.pop(context);
  //                         setState(() {
  //                           offerPrice = offerPriceController.text;
  //                         });
  //                       }
  //                     },
  //                     label: LocaleKeys.done.localize,
  //                     style: const TextStyle(
  //                       color: AppColors.LIGHT_COLOR,
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 18,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
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
