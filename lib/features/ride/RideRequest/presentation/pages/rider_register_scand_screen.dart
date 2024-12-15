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
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/image_validation.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class RiderRegisterScandScreen extends StatefulWidget {
  const RiderRegisterScandScreen({super.key, required this.formKey});
  final GlobalKey<FormState> formKey;
  @override
  State<RiderRegisterScandScreen> createState() =>
      _RiderRegisterScandScreenState();
}

class _RiderRegisterScandScreenState extends State<RiderRegisterScandScreen> {
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
  FocusNode carModelFocusNode = FocusNode();
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
  TextEditingController carModelController = TextEditingController();
  bool smoker = false;

  @override
  Widget build(BuildContext context) {
    final registerRider = context.read<RegisterRiderCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: BlocConsumer<RegisterRiderCubit, RiderState>(
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Flexible(
                      child: DefaultTextFormField(
                        isAuthentcation: true,
                        currentFocusNode: phoneFocusNode,
                        // nextFocusNode: carModelFocusNode,
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
                  ],
                ),
                const SizedBox(
                  height: 10,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ImageValidation(
                                        isAuthentcation: true,
                                        validator: (value) {
                                          return registerRider.validation(
                                              message: LocaleKeys
                                                  .thisFieldIsRequired
                                                  .tr(),
                                              condition: registerRider
                                                      .model.carImage ==
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  condition: registerRider.model
                                                          .idImageInFront ==
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
                                            validator: (value) {
                                              return registerRider.validation(
                                                  message: LocaleKeys
                                                      .thisFieldIsRequired
                                                      .tr(),
                                                  condition: registerRider.model
                                                          .idImageInBehind ==
                                                      null);
                                            },
                                            onTap: (image) {
                                              registerRider
                                                  .pickIdBehindImage(image);
                                            },
                                            noTextError: true,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                Row(
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
                                      isAuthentcation: true,
                                      validator: (value) {
                                        return registerRider.validation(
                                            message: LocaleKeys
                                                .thisFieldIsRequired
                                                .tr(),
                                            condition: registerRider.model
                                                    .drivingImageInFront ==
                                                null);
                                      },
                                      onTap: (image) {
                                        registerRider
                                            .pickDrivingInFrontImage(image);
                                      },
                                      noTextError: true,
                                      width: 95,
                                      hint: Labels.inFront,
                                    ),
                                    ImageValidation(
                                      isAuthentcation: true,
                                      validator: (value) {
                                        return registerRider.validation(
                                            message: LocaleKeys
                                                .thisFieldIsRequired
                                                .tr(),
                                            condition: registerRider
                                                    .model.drivingImageBehind ==
                                                null);
                                      },
                                      onTap: (image) {
                                        registerRider
                                            .pickDrivingBehindImage(image);
                                      },
                                      noTextError: true,
                                      width: 95,
                                      hint: Labels.behind,
                                    ),
                                  ],
                                ),
                                if (field.hasError)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        field.errorText ?? "",
                                        style: Styles.mediumText(
                                            color: Colors.red),
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
                                      isAuthentcation: true,
                                      validator: (value) {
                                        return registerRider.validation(
                                            message: LocaleKeys
                                                .thisFieldIsRequired
                                                .tr(),
                                            condition: registerRider.model
                                                    .licenseImageInFront ==
                                                null);
                                      },
                                      onTap: (image) {
                                        registerRider
                                            .pickLicenseInFrontImage(image);
                                      },
                                      noTextError: true,
                                      width: 95,
                                      hint: Labels.inFront,
                                    ),
                                    ImageValidation(
                                      isAuthentcation: true,
                                      validator: (value) {
                                        return registerRider.validation(
                                            message: LocaleKeys
                                                .thisFieldIsRequired
                                                .tr(),
                                            condition: registerRider
                                                    .model.licenseImgeBehind ==
                                                null);
                                      },
                                      onTap: (image) {
                                        registerRider
                                            .pickLicenseBehindImage(image);
                                      },
                                      width: 95,
                                      noTextError: true,
                                      hint: Labels.behind,
                                    ),
                                  ],
                                ),
                                if (field.hasError)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        field.errorText ?? "",
                                        style: Styles.mediumText(
                                            color: Colors.red),
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
                        isAuthentcation: true,
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
                          isAuthentcation: true,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return LocaleKeys.thisFieldIsRequired.tr();
                            }
                            return null;
                          },
                          currentController: plateNumberController,
                          currentFocusNode: plateNumberFocusNode,
                          hint: LocaleKeys.plateInformation.tr()),
                    ),
                  ],
                ),
                // const Gap(20),
                const SizedBox(
                  height: 10,
                ),
                CreateDoctorIDExpiryDatePicker(
                  isAuthentcation: true,
                  validator: (value) {
                    if (registerRider.model.idExpiryDate == null) {
                      return LocaleKeys.thisFieldIsRequired.tr();
                    }
                    return null;
                  },
                  onDateSelected: (date) {
                    if (date != null) {
                      registerRider.pickIdExpiryDate(date);
                    }
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
                  isAuthentcation: true,
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
                  isAuthentcation: true,
                  validator: (value) {
                    if (registerRider.model.licenseExpiryDate == null) {
                      return LocaleKeys.thisFieldIsRequired.tr();
                    }
                    return null;
                  },
                  onDateSelected: (date) {
                    if (date != null) {
                      registerRider.pickLicenseExpiryDate(date);
                    }
                  },
                  borderWidth: 1,
                  title: LocaleKeys.licenseExpiryDate.tr(),
                  textStyle: const TextStyle(
                      fontSize: 17,
                      color: AppColors.PRIMARY_COLOR,
                      fontWeight: FontWeight.w600),
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
                const Sizer(),
                DefaultTextFormField(
                  isAuthentcation: true,
                  currentFocusNode: carModelFocusNode,
                  hint: Labels.model,
                  hintColor: AppColors.PRIMARY_COLOR,
                  currentController: phoneController,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return LocaleKeys.phoneIsRequired.tr();
                    }
                    return null;
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
                      log("message");
                      if (context.isUserLoggedIn) {
                        // if (widget.formKey.currentState!.validate()) {
                        log(firstNameController.text);
                        registerRider.model.driverFirstName =
                            firstNameController.text;
                        registerRider.model.driverLastName =
                            lastNameController.text;
                        registerRider.model.phone = phoneController.text;
                        registerRider.model.idNumber = idNumberController.text;
                        registerRider.model.carModel = carModelController.text;
                        registerRider.model.plateInfo =
                            plateNumberController.text;
                        registerRider.registerTow(context);
                        // }
                      } else {
                        context.push(Routes.LOGIN);
                      }
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
      ),
    );
  }
}
