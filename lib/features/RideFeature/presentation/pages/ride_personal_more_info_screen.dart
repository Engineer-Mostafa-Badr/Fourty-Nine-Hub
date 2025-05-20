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
                ? showDebtDialog(context,widget.subCategoryId)
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
                  child: GestureDetector(
                    onTap: () async {
                      // First check if date is selected
                      if (_selectedDate.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(LocaleKeys.pleaseSelectDateFirst
                                  .localize)), // Please select date first
                        );
                        return;
                      }
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        final now = DateTime.now();
                        final selectedDateParsed =
                        DateFormat('dd/MM/yyyy').parse(_selectedDate);
                        final selectedDateTime = DateTime(
                            selectedDateParsed.year,
                            selectedDateParsed.month,
                            selectedDateParsed.day,
                            selectedTime.hour,
                            selectedTime.minute);

                        // Check if selected date is today
                        final isToday = selectedDateParsed.year == now.year &&
                            selectedDateParsed.month == now.month &&
                            selectedDateParsed.day == now.day;

                        // If today is selected, validate that time is not in the past
                        final minTime = now.add(Duration(minutes: 15));
                        if (isToday && selectedDateTime.isBefore(minTime)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(LocaleKeys.youCantChoosePastTime.tr()),
                            ),
                          );
                          return;
                        }

                        // Valid time selected - update state
                        setState(() {
                          _selectedTime = selectedTime.format(context);

                          if (widget.isTruk) {
                            cubit.makeLoadingTripParam.date = selectedDateTime;
                          } else {
                            cubit.makeNonTrackingTripParam.date =
                                selectedDateTime;
                          }
                        });
                      }
                    },

                    // onTap: () async {
                    //   // First check if date is selected
                    //   if (_selectedDate.isEmpty) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //           content: Text(LocaleKeys.pleaseSelectDateFirst
                    //               .localize)), // Please select date first
                    //     );
                    //     return;
                    //   }
                    //   final TimeOfDay? selectedTime = await showTimePicker(
                    //     context: context,
                    //     initialTime: TimeOfDay.now(),
                    //   );
                    //
                    //   if (selectedTime != null) {
                    //     final now = DateTime.now();
                    //     final selectedDateParsed =
                    //         DateFormat('dd/MM/yyyy').parse(_selectedDate);
                    //     final selectedDateTime = DateTime(
                    //         selectedDateParsed.year,
                    //         selectedDateParsed.month,
                    //         selectedDateParsed.day,
                    //         selectedTime.hour,
                    //         selectedTime.minute);
                    //
                    //     // Check if selected date is today
                    //     final isToday = selectedDateParsed.year == now.year &&
                    //         selectedDateParsed.month == now.month &&
                    //         selectedDateParsed.day == now.day;
                    //
                    //     // If today is selected, validate that time is not in the past
                    //     if (isToday && selectedDateTime.isBefore(now)) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //         SnackBar(
                    //             content: Text(
                    //                 LocaleKeys.youCantChoosePastTime.tr())),
                    //       );
                    //       return;
                    //     }
                    //
                    //     // Valid time selected - update state
                    //     setState(() {
                    //       _selectedTime = selectedTime.format(context);
                    //
                    //       if (widget.isTruk) {
                    //         cubit.makeLoadingTripParam.date = selectedDateTime;
                    //       } else {
                    //         cubit.makeNonTrackingTripParam.date =
                    //             selectedDateTime;
                    //       }
                    //     });
                    //   }
                    // },
                    child: PickUpContainer(
                      fontWeight: FontWeight.w400,
                      title: _selectedTime.isEmpty
                          ? LocaleKeys.chooseTheTime.localize
                          : _selectedTime, // <-- show the actual selected time
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: CustomDatePickerButton(
                    selectedDate: _selectedDate.isEmpty
                        ? LocaleKeys.chooseTheDate.tr()
                        : _selectedDate,
                    onDateSelected: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        _selectedTime = ""; // Reset time when date changes

                        final parsedDate =
                            DateFormat('dd/MM/yyyy').parse(newDate);
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
              ],
            ),
            const SizedBox(height: 8),

            PickUpTextFormField(
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
              }, hintText: LocaleKeys.numberOfPassenger.localize,
            ),
            const SizedBox(height: 8),
            PickUpTextFormField(
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
                if (widget.isTruk) {
                  cubit.makeLoadingTripParam.phone = value;
                } else {
                  cubit.makeNonTrackingTripParam.phone = value;
                }
              },
              maxLines: 1,
              hintText: cubit.makeNonTrackingTripParam.phone == null ||
                      cubit.makeNonTrackingTripParam.phone!.isEmpty
                  ? LocaleKeys.phone.localize
                  : cubit.makeNonTrackingTripParam.phone!,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showOfferFareBottomSheet(context),
              child: PickUpContainer(
                title: offerPrice.isEmpty
                    ? LocaleKeys.offerPrice.localize
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
                ? const Center(child: CircularProgressIndicator())
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

                              final p = cubit.makeNonTrackingTripParam..passengers = passengerCount;

                              if (!_validateRequiredFields(p, price)) {
                                showErrorMessage(
                                  context,
                                  LocaleKeys.pleaseFillAllRequiredFields.localize,
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

                              cubit.createNonTrackTrip(params: tripParams, context: context);
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

                                if (!_validateLoadingTripParams(cubit.makeLoadingTripParam)) {
                                  showErrorMessage(
                                    context,
                                    LocaleKeys.pleaseFillAllRequiredFields.localize,
                                  );
                                  return;
                                }

                                // cubit.makeLoadingRequestTrip(context);
                              } else {
                                final p = cubit.makeNonTrackingTripParam..passengers = passengerCount;

                                if (!_validateRequiredFields(p, price)) {
                                  showErrorMessage(
                                    context,
                                    LocaleKeys.pleaseFillAllRequiredFields.localize,
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

                                cubit.createNonTrackTrip(params: tripParams, context: context);
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

                              final price = double.tryParse(offerPrice) ?? 0.0;
                              final passengerText = passengerController.text;
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

                              final price = double.tryParse(offerPrice) ?? 0.0;
                              final passengerText = passengerController.text;
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
                        //                   double.tryParse(offerPrice) ?? 0.0;
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
                        //                   double.tryParse(offerPrice) ?? 0.0;
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
                        //                   double.tryParse(offerPrice) ?? 0.0;
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
                        //                   double.tryParse(offerPrice) ?? 0.0;
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

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      isScrollControlled: true,
      isDismissible: false, // Prevent tap outside to close
      enableDrag: false,    // Prevent swipe down to close
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
                              offerPriceController.clear(); // ✅ Clear input
                              Navigator.pop(context);        // ✅ Then close
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
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: "EGP",
                        hintStyle: TextStyle(
                          fontSize: 40,
                          color: AppColors.c96979B,
                        ),
                        border: UnderlineInputBorder(),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      enableInteractiveSelection: false,
                      contextMenuBuilder: (context, editableTextState) =>
                      const SizedBox.shrink(),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9), // ✅ Max 9 digits
                        NoPasteFormatter(),
                      ],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return context.isArabic ? 'هذا الحقل مطلوب' : 'This field is required';
                        }

                        final numValue = int.tryParse(value);
                        if (numValue == null) {
                          return context.isArabic ? 'الرجاء إدخال رقم صحيح' : 'Please enter a valid number';
                        }

                        if (numValue < 100) {
                          return context.isArabic ? 'الرقم يجب أن لا يقل عن 100' : 'The number must be at least 100';
                        }

                        return null; // Valid
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
                            offerPrice = offerPriceController.text;
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
