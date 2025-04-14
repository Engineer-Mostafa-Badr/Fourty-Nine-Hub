import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_date_picker.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/custom_pickup_container.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/image_text_row.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/pages/widgets/pickup_text_form_field.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/error/failure.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../routes/routes.dart';
import '../../domain/usecases/make_loading_request_trip_usecase.dart';
import '../../domain/usecases/make_non_tracking_request_trip_usecase.dart';
import '../controllers/client_trips_cubit/client_trips_cubit.dart';
import 'widgets/pickup_target_location_widget.dart';

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
  String _selectedTime = LocaleKeys.pickupTime.localize;
  String _selectedDate = LocaleKeys.pickupDate.localize;
  int _numberOfPassengers = 0;
  bool _isExpanded = false;
  String offerPrice = '';
  late ClientTripsCubit cubit;
  TextEditingController phoneController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientTripsCubit, ClientTripsState>(
      listener: (context, state) {
        if (state.isErrorCreateTrip) {
          String errorName = getFailureName(state.failure!, context);
          errorName == 'DebtError'
              ? showDebtDialog(context, '')
              : errorName == 'SubscribeError'
                  ? showSubscribeDialog(context, '')
                  : showErrorMessage(
                      context, getFailureMessage(state.failure!, context));
        }
        if (state.isSuccessCreateTrip) {
          showSuccessMessage(context, LocaleKeys.requestSentSuccess.localize);
          _selectedTime = LocaleKeys.pickupTime.localize;
          _selectedDate = LocaleKeys.pickupDate.localize;
          _numberOfPassengers = 0;
          _isExpanded = false;
          offerPrice = '';
          phoneController.clear();
          if (widget.isTruk) {
            cubit.makeLoadingTripParam = MakeLoadingRequestTripUsecaseParam();
          } else {
            cubit.makeNonTrackingTripParam =
                MakeNonTrackingRequestTripUsecaseParam();
          }
        }
      },
      builder: (context, state) {
        return ListView(
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
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        setState(() {
                          _selectedTime = selectedTime.format(context);
                          final now = DateTime.now();
                          if (widget.isTruk) {
                            cubit.makeLoadingTripParam.date = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          } else {
                            cubit.makeNonTrackingTripParam.date = DateTime(
                              now.year,
                              now.month,
                              now.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                          }
                        });
                      }
                    },
                    child: PickUpContainer(
                      fontWeight: FontWeight.w500,
                      title: _selectedTime,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: CustomDatePickerButton(
                    selectedDate: _selectedDate,
                    onDateSelected: (newDate) {
                      setState(() {
                        _selectedDate = newDate;
                        final parsedDate =
                            DateFormat('dd/MM/yyyy').parse(newDate);
                        if (widget.isTruk) {
                          final currentTime =
                              cubit.makeLoadingTripParam.date ?? DateTime.now();
                          cubit.makeLoadingTripParam.date = DateTime(
                            parsedDate.year,
                            parsedDate.month,
                            parsedDate.day,
                            currentTime.hour,
                            currentTime.minute,
                          );
                        } else {
                          final currentTime =
                              cubit.makeNonTrackingTripParam.date ??
                                  DateTime.now();
                          cubit.makeNonTrackingTripParam.date = DateTime(
                            parsedDate.year,
                            parsedDate.month,
                            parsedDate.day,
                            currentTime.hour,
                            currentTime.minute,
                          );
                          log("Selected date: ${cubit.makeNonTrackingTripParam.date}");
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (widget.isTruk) ...[
              PickUpTextFormField(
                onFieldSubmitted: (value) {
                  cubit.makeLoadingTripParam.description = value;
                  log(cubit.makeLoadingTripParam.description.toString());
                },
                hintText: LocaleKeys.cargoDescription.localize,
                maxLines: 3,
                controller: TextEditingController(),
              ),
              const SizedBox(height: 8)
            ] else ...[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: PickUpContainer(
                  title: _numberOfPassengers == 0
                      ? LocaleKeys.numberOfPassenger.localize
                      : '$_numberOfPassengers',
                ),
              ),
              if (_isExpanded)
                Column(
                  children: List.generate(10, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _numberOfPassengers = index + 1;
                          cubit.makeNonTrackingTripParam.passengers =
                              _numberOfPassengers;
                          _isExpanded = false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        height: 48,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF5F5F5),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    );
                  }),
                ),
            ],
            const SizedBox(height: 8),
            PickUpTextFormField(
              controller: phoneController,
              onChanged: (value) {
                if (widget.isTruk) {
                  cubit.makeLoadingTripParam.phone = value;
                  log(cubit.makeLoadingTripParam.phone.toString());
                } else {
                  cubit.makeNonTrackingTripParam.phone = value;
                  log(cubit.makeNonTrackingTripParam.phone.toString());
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
                                  if (context.isUserLoggedIn) {
                                    if (widget.isTruk) {
                                      cubit.makeLoadingTripParam.isPremium =
                                          true;
                                      cubit.makeLoadingTripParam.price =
                                          double.tryParse(offerPrice) ?? 0.0;
                                      log(cubit.makeLoadingTripParam
                                          .toJson()
                                          .toString());
                                      if (cubit.makeLoadingTripParam.date ==
                                              null ||
                                          cubit.makeLoadingTripParam.phone ==
                                              null ||
                                          cubit.makeLoadingTripParam.phone!
                                              .isEmpty ||
                                          cubit.makeLoadingTripParam.price ==
                                              0.0) {
                                        showErrorMessage(context,
                                            "Please fill all required fields.");
                                      } else {
                                        cubit.makeLoadingRequestTrip(context);
                                      }
                                    } else {
                                      cubit.makeNonTrackingTripParam.isPremium =
                                          true;
                                      cubit.makeNonTrackingTripParam
                                          .subcategoryId = widget.subCategoryId;
                                      cubit.makeNonTrackingTripParam.price =
                                          double.tryParse(offerPrice) ?? 0.0;
                                      log(cubit.makeNonTrackingTripParam
                                          .toJson()
                                          .toString());
                                      if (cubit.makeNonTrackingTripParam.date == null ||
                                          cubit.makeNonTrackingTripParam.phone ==
                                              null ||
                                          cubit.makeNonTrackingTripParam.phone!
                                              .isEmpty ||
                                          cubit.makeNonTrackingTripParam
                                                  .price ==
                                              0.0 ||
                                          (!widget.isTruk &&
                                              (cubit.makeNonTrackingTripParam
                                                          .passengers ==
                                                      null ||
                                                  cubit.makeNonTrackingTripParam
                                                          .passengers ==
                                                      0))) {
                                        showErrorMessage(context,
                                            "Please fill all required fields.");
                                      } else {
                                        cubit.makeNonTrackingRequestTrip(
                                            context);
                                      }
                                    }
                                  } else {
                                    context.push(Routes.LOGIN);
                                  }
                                },
                                backColor: AppColors.SECONDARY_COLOR_DARK2,
                                width: MediaQuery.of(context).size.width)),
                        Expanded(
                            flex: 2,
                            child: AppButton(
                                radius: 15,
                                label: LocaleKeys.request.tr(),
                                onPressed: () async {
                                  if (context.isUserLoggedIn) {
                                    if (widget.isTruk) {
                                      cubit.makeLoadingTripParam.isPremium =
                                          false;
                                      cubit.makeLoadingTripParam.price =
                                          double.tryParse(offerPrice) ?? 0.0;
                                      log(cubit.makeLoadingTripParam
                                          .toJson()
                                          .toString());
                                      if (cubit.makeLoadingTripParam.date ==
                                              null ||
                                          cubit.makeLoadingTripParam.phone ==
                                              null ||
                                          cubit.makeLoadingTripParam.phone!
                                              .isEmpty ||
                                          cubit.makeLoadingTripParam.price ==
                                              0.0) {
                                        showErrorMessage(context,
                                            "Please fill all required fields.");
                                      } else {
                                        cubit.makeLoadingRequestTrip(context);
                                      }
                                    } else {
                                      cubit.makeNonTrackingTripParam.isPremium =
                                          false;
                                      cubit.makeNonTrackingTripParam
                                          .subcategoryId = widget.subCategoryId;
                                      cubit.makeNonTrackingTripParam.price =
                                          double.tryParse(offerPrice) ?? 0.0;
                                      log(cubit.makeNonTrackingTripParam
                                          .toJson()
                                          .toString());
                                      if (cubit.makeNonTrackingTripParam.date == null ||
                                          cubit.makeNonTrackingTripParam.phone ==
                                              null ||
                                          cubit.makeNonTrackingTripParam.phone!
                                              .isEmpty ||
                                          cubit.makeNonTrackingTripParam
                                                  .price ==
                                              0.0 ||
                                          (!widget.isTruk &&
                                              (cubit.makeNonTrackingTripParam
                                                          .passengers ==
                                                      null ||
                                                  cubit.makeNonTrackingTripParam
                                                          .passengers ==
                                                      0))) {
                                        showErrorMessage(context,
                                            "Please fill all required fields.");
                                      } else {
                                        cubit.makeNonTrackingRequestTrip(
                                            context);
                                      }
                                    }
                                  } else {
                                    context.push(Routes.LOGIN);
                                  }
                                },
                                backColor: AppColors.PRIMARY_COLOR,
                                width: MediaQuery.of(context).size.width)),
                      ],
                    ),
                  )
          ],
        );
      },
    );
  }

  void _showOfferFareBottomSheet(BuildContext context) {
    TextEditingController offerPriceController = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 0.75,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Centered Text
                      Align(
                        alignment: Alignment.center,
                        child: Label(
                          text: LocaleKeys.offerYourFare.localize,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: AppColors.cEEEEEEE,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: offerPriceController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "EGP",
                      hintStyle:
                          TextStyle(fontSize: 40, color: AppColors.c96979B),
                      border: UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    onChanged: (value) {
                      offerPrice = value;
                    },
                  ),
                  const SizedBox(height: 50),
                  AppButton(
                    radius: 15,
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        offerPrice = offerPriceController.text;
                      });
                    },
                    label: LocaleKeys.done.localize,
                    style: const TextStyle(
                        color: AppColors.LIGHT_COLOR,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
