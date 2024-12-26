import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/picture_optional_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/car_info_rider.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/image_validation.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_brands/fetch_car_brands_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_models/fetch_car_models_cubit.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/cubits/fetch_car_year_type/fetch_car_year_type_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RiderRegisterOne extends StatefulWidget {
  const RiderRegisterOne({
    super.key,
    required this.formKey,
  });
  final GlobalKey<FormState> formKey;
  @override
  State<RiderRegisterOne> createState() => _RiderRegisterOneState();
}

class _RiderRegisterOneState extends State<RiderRegisterOne> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode idNumberFocusNode = FocusNode();
  FocusNode plateNumberFocusNode = FocusNode();
  FocusNode vehicleModelFocusNode = FocusNode();
  FocusNode vehicleBrandFocusNode = FocusNode();
  FocusNode vehicleColorFocusNode = FocusNode();
  FocusNode pricingPerKmFocusNode = FocusNode();
  FocusNode vehicleTypeFocusNode = FocusNode();
  FocusNode vehicleYearFocusNode = FocusNode();
  FocusNode yourFavoriteCiryFocusNode = FocusNode();
  FocusNode model = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  TextEditingController vehicleModelController = TextEditingController();
  TextEditingController vehicleBrandController = TextEditingController();
  TextEditingController vehicleColorController = TextEditingController();
  TextEditingController pricingPerKmController = TextEditingController();
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController vehicleYearController = TextEditingController();
  TextEditingController yourFavoriteCiryController = TextEditingController();
  // GlobalKey<FormState> formKey = GlobalKey();
  bool smoker = false;
  late FetchCarBrandsCubit fetchCarBrandsCubit;
  late FetchCarModelsCubit fetchCarModelsCubit;
  late FetchCarYearTypeCubit fetchCarYearTypeCubit;
  late RegisterRiderCubit riderCubit;

  String workingType = 'percentage';
  String vehicleType = 'car';
  // "workingType" : "percentage" //percentage or subscribePackage
  @override
  void initState() {
    fetchCarBrandsCubit = context.read<FetchCarBrandsCubit>();
    fetchCarModelsCubit = context.read<FetchCarModelsCubit>();
    fetchCarYearTypeCubit = context.read<FetchCarYearTypeCubit>();
    riderCubit = context.read<RegisterRiderCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return BlocConsumer<RegisterRiderCubit, RiderState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingShippingState) {
          return const Align(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.PRIMARY_COLOR,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: FirstNameTextFormField(
                      isAuthentcation: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.firstNameIsRequired.tr();
                        }
                        return null;
                      },
                      // style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.w600),
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentFocusNode: firstNameFocusNode,
                      nextFocusNode: lastNameFocusNode,
                      currentController: firstNameController,
                    ),
                  ),
                  const Sizer(),
                  Expanded(
                    child: LastNameTextFormField(
                      isAuthentcation: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return LocaleKeys.lastNameIsRequired.tr();
                        }
                        return null;
                      },
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentController: lastNameController,
                      nextFocusNode: phoneFocusNode,
                      currentFocusNode: lastNameFocusNode,
                    ),
                  ),
                ],
              ),
              // const Gap(30),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: DefaultTextFormField(
                      isAuthentcation: true,
                      currentFocusNode: phoneFocusNode,
                      nextFocusNode: vehicleModelFocusNode,
                      hint: Labels.phone,
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentController: phoneController,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return LocaleKeys.phoneIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: DefaultTextFormField(
                      isAuthentcation: true,
                      currentFocusNode: pricingPerKmFocusNode,
                      nextFocusNode: model,
                      hint: LocaleKeys.pricingPerKm.tr(),
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentController: pricingPerKmController,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return LocaleKeys.pricingPerKmIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const CarInfoRider(),
              const Sizer(),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      icon: Container(),
                      value: workingType,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          workingType = value ?? "";
                          registerRider.model.workingType = workingType;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "percentage",
                          child: Text("Percentage"),
                        ),
                        DropdownMenuItem(
                          value: "subscribePackage",
                          child: Text("Subscribe Package"),
                        ),
                      ],
                      underline: Container(),
                    ),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      icon: Container(),
                      value: vehicleType,
                      dropdownColor: Colors.white,
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        setState(() {
                          vehicleType = value ?? "";
                          registerRider.model.vehicleType = vehicleType;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "car",
                          child: Text("Car"),
                        ),
                        DropdownMenuItem(
                          value: "scooter",
                          child: Text("Scooter"),
                        ),
                      ],
                      underline: Container(),
                    ),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 15,
                    child: Row(
                      children: [
                        Switch(
                          inactiveTrackColor: AppColors.GREY_LIGHT_COLOR,
                          onChanged: (value) {
                            setState(() {
                              if (context.isUserLoggedIn) {
                                registerRider.model.airCondition = value;
                              } else {
                                context.push(Routes.LOGIN);
                              }
                            });
                          },
                          value: registerRider.model.airCondition ?? false,
                        ),
                        Flexible(
                          child: Text(
                            LocaleKeys.airConditionAc.tr(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Switch(
                        inactiveTrackColor: AppColors.GREY_LIGHT_COLOR,
                        onChanged: (value) {
                          setState(() {
                            if (context.isUserLoggedIn) {
                              registerRider.model.smoker = value;
                            } else {
                              context.push(Routes.LOGIN);
                            }
                          });
                        },
                        value: registerRider.model.smoker ?? false,
                      ),
                      Text(
                        LocaleKeys.Smoker.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
              FormField(
                validator: (value) {
                  if (registerRider.model.carImage == null) {
                    return LocaleKeys.thisFieldIsRequired.tr();
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  LocaleKeys.carPicture.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ImageValidation(
                                      isAuthentcation: true,
                                      validator: (value) {
                                        return registerRider.validation(
                                            message: LocaleKeys
                                                .thisFieldIsRequired
                                                .tr(),
                                            condition:
                                                registerRider.model.carImage ==
                                                    null);
                                      },
                                      onTap: (image) {
                                        registerRider.pickImageCar(image);
                                      },
                                      width: 95,
                                      noTextError: true,
                                      hint: Labels.inFront,
                                    ),
                                  ],
                                ),
                                if (field.hasError)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: Text(
                                          field.errorText ?? "",
                                          style: Styles.mediumText(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: LocaleKeys.id.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ImageValidation(
                                          isAuthentcation: true,
                                          validator: (value) {
                                            return registerRider.validation(
                                                message: LocaleKeys
                                                    .thisFieldIsRequired
                                                    .tr(),
                                                condition: registerRider
                                                        .model.idImageInFront ==
                                                    null);
                                          },
                                          onTap: (image) {
                                            registerRider
                                                .pickIdInFrontImage(image);
                                          },
                                          width: 95,
                                          noTextError: true,
                                          hint: Labels.inFront,
                                        ),
                                        const Sizer(),
                                        ImageValidation(
                                          isAuthentcation: true,
                                          onTap: (image) {
                                            registerRider
                                                .pickIdBehindImage(image);
                                          },
                                          validator: (value) {
                                            return registerRider.validation(
                                                message: LocaleKeys
                                                    .thisFieldIsRequired
                                                    .tr(),
                                                condition: registerRider.model
                                                        .idImageInBehind ==
                                                    null);
                                          },
                                          // noTextError: true,
                                          width: 95,
                                          hint: Labels.behind,
                                        ),
                                      ],
                                    ),
                                    if (field.hasError)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            child: Text(
                                              field.errorText ?? "",
                                              style: Styles.mediumText(
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ]);
                },
              ),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label(
                        text: Labels.drivingLicense,
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.w600),
                      ),
                      const Sizer(),
                      FormField(
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ImageValidation(
                                    onTap: (image) {
                                      registerRider
                                          .pickDrivingInFrontImage(image);
                                    },
                                    validator: (value) {
                                      return registerRider.validation(
                                          message: LocaleKeys
                                              .thisFieldIsRequired
                                              .tr(),
                                          condition: registerRider
                                                  .model.drivingImageInFront ==
                                              null);
                                    },
                                    noTextError: true,
                                    width: 95,
                                    hint: Labels.inFront,
                                  ),
                                  ImageValidation(
                                    onTap: (image) {
                                      registerRider
                                          .pickDrivingBehindImage(image);
                                    },
                                    validator: (value) {
                                      return registerRider.validation(
                                          message: LocaleKeys
                                              .thisFieldIsRequired
                                              .tr(),
                                          condition: registerRider
                                                  .model.drivingImageBehind ==
                                              null);
                                    },
                                    noTextError: true,
                                    width: 95,
                                    hint: Labels.behind,
                                  ),
                                ],
                              ),
                              if (field.hasError)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      field.errorText ?? "",
                                      style:
                                          Styles.mediumText(color: Colors.red),
                                    ),
                                  ],
                                )
                            ],
                          );
                        },
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Label(
                        text: Labels.license,
                        style: TextStyle(
                            fontSize: 17,
                            color: AppColors.PRIMARY_COLOR,
                            fontWeight: FontWeight.w600),
                      ),
                      const Sizer(),
                      FormField(
                        builder: (field) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ImageValidation(
                                    onTap: (image) {
                                      registerRider
                                          .pickLicenseInFrontImage(image);
                                    },
                                    validator: (value) {
                                      return registerRider.validation(
                                          message: LocaleKeys
                                              .thisFieldIsRequired
                                              .tr(),
                                          condition: registerRider
                                                  .model.licenseImageInFront ==
                                              null);
                                    },
                                    noTextError: true,
                                    width: 95,
                                    hint: Labels.inFront,
                                  ),
                                  ImageValidation(
                                    onTap: (image) {
                                      registerRider
                                          .pickLicenseBehindImage(image);
                                    },
                                    validator: (value) {
                                      return registerRider.validation(
                                          message: LocaleKeys
                                              .thisFieldIsRequired
                                              .tr(),
                                          condition: registerRider
                                                  .model.licenseImgeBehind ==
                                              null);
                                    },
                                    width: 95,
                                    noTextError: true,
                                    hint: Labels.behind,
                                  ),
                                ],
                              ),
                              if (field.hasError)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      field.errorText ?? "",
                                      style:
                                          Styles.mediumText(color: Colors.red),
                                    ),
                                  ],
                                )
                            ],
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Flexible(
                    child: DefaultTextFormField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return LocaleKeys.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                      currentController: idNumberController,
                      currentFocusNode: idNumberFocusNode,
                      hint: LocaleKeys.idNumber.tr(),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: DefaultTextFormField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return LocaleKeys.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                      currentController: plateNumberController,
                      currentFocusNode: plateNumberFocusNode,
                      hint: LocaleKeys.plateInformation.tr(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CreateDoctorIDExpiryDatePicker(
                onDateSelected: (date) {
                  if (date != null) {
                    registerRider.pickIdExpiryDate(date);
                  }
                },
                validator: (value) {
                  if (registerRider.model.idExpiryDate == null) {
                    return LocaleKeys.thisFieldIsRequired.tr();
                  }
                  return null;
                },
                textStyle: const TextStyle(
                    fontSize: 17,
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600),
                borderWidth: 1,
                borderColor: Colors.black,
              ),
              const SizedBox(
                height: 10,
              ),
              CreateDoctorIDExpiryDatePicker(
                validator: (value) {
                  if (registerRider.model.drvingExpiryDate == null) {
                    return LocaleKeys.thisFieldIsRequired.tr();
                  }
                  return null;
                },
                title: LocaleKeys.drivingLicenseExpiryDate.tr(),
                textStyle: const TextStyle(
                    fontSize: 17,
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600),
                borderWidth: 1,
                onDateSelected: (date) {
                  if (date != null) {
                    registerRider.pickDrivingExpiryDate(date);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              CreateDoctorIDExpiryDatePicker(
                validator: (value) {
                  if (registerRider.model.licenseExpiryDate == null) {
                    return LocaleKeys.thisFieldIsRequired.tr();
                  }
                  return null;
                },
                borderWidth: 1,
                title: LocaleKeys.licenseExpiryDate.tr(),
                textStyle: const TextStyle(
                    fontSize: 17,
                    color: AppColors.PRIMARY_COLOR,
                    fontWeight: FontWeight.w600),
                onDateSelected: (date) {
                  if (date != null) {
                    registerRider.pickLicenseExpiryDate(date);
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FormField(
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (field.hasError)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 8),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                field.errorText ?? "",
                                style: Styles.mediumText(color: Colors.red),
                              ),
                            ),
                          ],
                        )
                    ],
                  );
                },
              ),
              BlocBuilder<PictureOptionalCubit, RiderState>(
                builder: (context, state) {
                  log(state.toString(), name: "lsdjfslkdjflskjfddddkdkdkk");
                  if (state is SuccessGetPictureOptionalState) {
                    if (state.value.dragAnalytics?.open ?? false) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.value.dragAnalytics?.open ?? false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: LocaleKeys.dragAnalysis.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Sizer(),
                                ImageValidation(
                                  onTap: (image) {
                                    registerRider
                                        .pickDrivingInFrontImage(image);
                                  },
                                  validator: (value) {
                                    return registerRider.validation(
                                        message:
                                            LocaleKeys.thisFieldIsRequired.tr(),
                                        condition: registerRider
                                                .model.drivingImageInFront ==
                                            null);
                                  },
                                  noTextError: true,
                                  width: 95,
                                  hint: "",
                                ),
                                const Sizer(),
                                Row(
                                  children: [
                                    Flexible(
                                      child: DefaultTextFormField(
                                        readOnly: true,
                                        currentController:
                                            TextEditingController(
                                                text: state.value.dragAnalytics
                                                    ?.address),
                                        hint:
                                            state.value.dragAnalytics?.address,
                                      ),
                                    ),
                                    const Sizer(),
                                    Flexible(
                                      child: DefaultTextFormField(
                                        readOnly: true,
                                        currentController:
                                            TextEditingController(
                                                text: state.value.dragAnalytics
                                                    ?.phone),
                                        hint: state.value.dragAnalytics?.phone,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          // criminalRecord
                          if (state.value.criminalRecord?.open ?? false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: LocaleKeys.criminalRecord.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Sizer(),
                                ImageValidation(
                                  onTap: (image) {
                                    registerRider
                                        .pickDrivingInFrontImage(image);
                                  },
                                  validator: (value) {
                                    return registerRider.validation(
                                        message:
                                            LocaleKeys.thisFieldIsRequired.tr(),
                                        condition: registerRider
                                                .model.drivingImageInFront ==
                                            null);
                                  },
                                  noTextError: true,
                                  width: 95,
                                  hint: "",
                                ),
                                const Sizer(),
                              ],
                            ),
                          //technicalExamination
                          if (state.value.technicalExamination?.open ?? false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: LocaleKeys.technicalExamination.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Sizer(),
                                ImageValidation(
                                  onTap: (image) {
                                    registerRider
                                        .pickDrivingInFrontImage(image);
                                  },
                                  validator: (value) {
                                    return registerRider.validation(
                                        message:
                                            LocaleKeys.thisFieldIsRequired.tr(),
                                        condition: registerRider
                                                .model.drivingImageInFront ==
                                            null);
                                  },
                                  noTextError: true,
                                  width: 95,
                                  hint: "",
                                ),
                                const Sizer(),
                                Row(
                                  children: [
                                    Flexible(
                                      child: DefaultTextFormField(
                                        readOnly: true,
                                        currentController:
                                            TextEditingController(
                                                text: state
                                                    .value
                                                    .technicalExamination
                                                    ?.address),
                                        hint:
                                            state.value.dragAnalytics?.address,
                                      ),
                                    ),
                                    const Sizer(),
                                    Flexible(
                                      child: DefaultTextFormField(
                                        readOnly: true,
                                        currentController:
                                            TextEditingController(
                                                text: state
                                                    .value
                                                    .technicalExamination
                                                    ?.phone),
                                        hint: state.value.dragAnalytics?.phone,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            )
                        ],
                      );
                    } else {
                      return Container(
                          // width: 150,
                          // height: 150,
                          // color: Colors.red,
                          );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const AppInfoText(
                text: Labels.theApplicationDoesNot,
              ),
              const SizedBox(
                height: 10,
              ),
              const AppInfoText(
                text: Labels.youWillGetPounds,
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.center,
                child: AppButton(
                  backColor: AppColors.PRIMARY_COLOR,
                  textColor: Colors.white,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  label: Labels.submit,
                  onPressed: () {
                    // log(widget.formKey.currentState!.validate().toString(),
                    //     name: "lksdjflksjf");
                    // log("lksjdflksdjflskdjf", name: lastNameController.text);
                    // log(formKey.currentState!.validate().toString(),
                    // name: "laksjdf");
                    // if (widget.formKey.currentState?.validate() ?? false) {
                    registerRider.model.driverFirstName =
                        firstNameController.text;
                    registerRider.model.driverLastName =
                        lastNameController.text;
                    registerRider.model.phone = phoneController.text;
                    registerRider.model.pricingPerKm =
                        double.tryParse(pricingPerKmController.text) ?? 0;
                    // registerRider.model.vehicleModel =
                    //     vehicleModelController.text;
                    // registerRider.model.vehicleBrand =
                    //     vehicleBrandController.text;
                    // registerRider.model.vehicleYear =
                    //     vehicleYearController.text;
                    registerRider.model.yourFavoriteCity =
                        yourFavoriteCiryController.text;
                    registerRider.model.idNumber = idNumberController.text;
                    registerRider.model.plateInfo = plateNumberController.text;
                    registerRider.registerOne();
                    // }
                    // registerRider.register();
                    // log("${registerRider.model.registerOne()}",
                    //       name: "lksjdflskjdflskdjf");
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        );
      },
    );
  }
}
