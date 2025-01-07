import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/get_driver_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/update_driver_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/image_validation.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class EditDriverScreen extends StatefulWidget {
  const EditDriverScreen({super.key});

  @override
  State<EditDriverScreen> createState() => _EditDriverScreenState();
}

class _EditDriverScreenState extends State<EditDriverScreen> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode idNumberFocusNode = FocusNode();
  FocusNode plateNumberFocusNode = FocusNode();
  FocusNode model = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ShippingCubit>().getBannerData();
  }

  @override
  Widget build(BuildContext context) {
    final shippingcubit = context.read<ShippingCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: BlocListener<UpdateDriverCubit, ShippingState>(
          listener: (context, state) {
            if (state is SuccessUpdateDriverState) {
              context.pushReplacementNamed(Routes.SHIPPING);
              // ! SUPER
              showSuccessMessage(context, LocaleKeys.successUpdateDriver.tr());
            }
          },
          child: BlocConsumer<GetDriverCubit, ShippingState>(
            listener: (context, state) {
              if (state is SuccessRegisterState) {
                showSuccessMessage(context, state.message);
                context.pushReplacementNamed(Routes.SHIPPING);
              }
              if (state is FailureShippingState) {
                showErrorMessage(
                    context, getFailureMessage(state.failure, context));
              }
            },
            builder: (context, mainState) {
              log(mainState.toString(), name: "lskdddddd");
              if (mainState is LoadingShippingState) {
                return const Align(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                );
              }
              if (mainState is SuccessGetDriverDataState) {
                shippingcubit.model.subCategoryId =
                    mainState.model.driverInformation?.categoryId;
                // state.model.driverInformation;
                firstNameController.text =
                    mainState.model.driverInformation?.firstName ?? "";
                lastNameController.text =
                    mainState.model.driverInformation?.lastName ?? "";
                phoneController.text =
                    mainState.model.driverInformation?.phone ?? "";
                idNumberController.text =
                    mainState.model.driverInformation?.driverInfoId?.idNumber ??
                        "";
                plateNumberController.text = mainState.model.driverInformation
                        ?.driverInfoId?.carPlateInformation ??
                    "";
                shippingcubit.model.idExpiryDate = mainState
                    .model.driverInformation?.driverInfoId?.idExpiryDate;
                shippingcubit.model.drivingExpiryDate = mainState.model
                    .driverInformation?.driverInfoId?.drivingLicenseExpiryDate;
                shippingcubit.model.licenseExpiryDate = mainState.model
                    .driverInformation?.driverInfoId?.carLicenseExpiryDate;
                modelController.text =
                    mainState.model.driverInformation?.carModel ?? "";
                return Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocaleKeys.welcomeToShipRegister.tr(),
                          style: Styles.headerText(
                            fontSize: 40,
                            color: AppColors.PRIMARY_COLOR_DARK,
                          ),
                        ),
                        Center(
                          child: BlocBuilder<ShippingCubit, ShippingState>(
                            builder: (context, state) {
                              if (state is SuccessGetBannerState) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Gap(8),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    FormField(
                                      // validator: (value) {
                                      //   log(value.toString());
                                      //   return shippingcubit.validation(
                                      //     message:
                                      //         "Choose your favorite Sub Category!",
                                      //     condition: shippingcubit
                                      //             .model.subCategoryEntity ==
                                      //         null,
                                      //   );
                                      // },
                                      builder: (field) {
                                        // field.dispose();
                                        // field.activate
                                        // log(field.hasError.toString(),
                                        //     name: "field");
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            DropdownMenu<SubCategoryEntity>(
                                              inputDecorationTheme:
                                                  InputDecorationTheme(
                                                hintStyle: const TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        AppColors.PRIMARY_COLOR,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: BorderSide(
                                                    color: field.hasError
                                                        ? Colors.red
                                                        : Colors.grey,
                                                  ),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide: BorderSide(
                                                      color: field.hasError
                                                          ? Colors.red
                                                          : Colors.black,
                                                    )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                          color: field.hasError
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        borderSide: BorderSide(
                                                          color: field.hasError
                                                              ? Colors.red
                                                              : Colors.black,
                                                        )),
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              hintText:
                                                  LocaleKeys.subCategory.tr(),
                                              dropdownMenuEntries: state
                                                  .model.subCategories!
                                                  .map((e) => SubCategoryEntity(
                                                        id: e.subCategoryId!,
                                                        image: e.picture ?? "",
                                                        isFavorite: false,
                                                        nameEn:
                                                            e.subCategoryNameEn ??
                                                                "",
                                                        nameAr:
                                                            e.subCategoryNameAr ??
                                                                "",
                                                      ))
                                                  .map((e) => DropdownMenuEntry<
                                                          SubCategoryEntity>(
                                                      value: e,
                                                      label: context.isArabic
                                                          ? e.nameAr
                                                          : e.nameEn))
                                                  .toList(),
                                              onSelected: (value) {
                                                setState(() {
                                                  if (value != null) {
                                                    shippingcubit
                                                        .selectSubCategory(
                                                            subCategory:
                                                                value.id);
                                                    field.didChange(
                                                        value); // تحديث حالة الفاليديشن
                                                  }
                                                });
                                              },
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            if (field.hasError)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Text(
                                                  field.errorText ?? "",
                                                  style: Styles.mediumText(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              )
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FirstNameTextFormField(
                                // validator: (String? value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "First name is required!";
                                //   }
                                // },
                                hintColor: AppColors.PRIMARY_COLOR,
                                currentFocusNode: firstNameFocusNode,
                                nextFocusNode: lastNameFocusNode,
                                currentController: firstNameController,
                              ),
                            ),
                            const Sizer(),
                            Expanded(
                              child: LastNameTextFormField(
                                // validator: (String? value) {
                                //   if (value == null || value.isEmpty) {
                                //     return "Last name is required!";
                                //   }
                                // },
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
                        DefaultTextFormField(
                          currentFocusNode: phoneFocusNode,
                          nextFocusNode: model,
                          hint: LocaleKeys.phone.tr(),
                          hintColor: AppColors.PRIMARY_COLOR,
                          currentController: phoneController,
                          // validator: (p0) {
                          //   if (p0 == null || p0.isEmpty) {
                          //     return "Phone is required!";
                          //   }
                          // },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormField(
                          // validator: (value) {
                          //   if (shippingcubit.model.carImageInFront == null &&
                          //       shippingcubit.model.idImageBehind == null &&
                          //       shippingcubit.model.idImageInFront == null) {
                          //     return "This field is required!";
                          //   }
                          // },
                          builder: (field) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                width: 95,
                                                noTextError: true,
                                                networkImage: mainState
                                                    .model
                                                    .driverInformation
                                                    ?.driverInfoId
                                                    ?.carPicturesKey,
                                                hint: LocaleKeys.inFront.tr(),
                                                // validator: (value) {
                                                //   return shippingcubit.validation(
                                                //       message:
                                                //           "This field is required.",
                                                //       condition: shippingcubit
                                                //               .model
                                                //               .carImageInFront ==
                                                //           null);
                                                // },
                                                onTap: (image) {
                                                  shippingcubit
                                                      .pickImageCarInFront(
                                                          image: image);
                                                },
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
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  child: Text(
                                                    field.errorText ?? "",
                                                    style: Styles.mediumText(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          // const SizedBox(
                                          //   width: 20,
                                          // ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ImageValidation(
                                                    width: 95,
                                                    noTextError: true,
                                                    networkImage: mainState
                                                        .model
                                                        .driverInformation
                                                        ?.driverInfoId
                                                        ?.idFrontKey,
                                                    hint:
                                                        LocaleKeys.inFront.tr(),
                                                    // validator: (value) {
                                                    //   return shippingcubit.validation(
                                                    //       message:
                                                    //           "This field is required.",
                                                    //       condition: shippingcubit
                                                    //               .model
                                                    //               .idImageInFront ==
                                                    //           null);
                                                    // },
                                                    onTap: (image) {
                                                      shippingcubit
                                                          .pickImageIdInFront(
                                                              image: image);
                                                    },
                                                  ),
                                                  const Sizer(),
                                                  ImageValidation(
                                                    noTextError: true,
                                                    width: 95,
                                                    networkImage: mainState
                                                        .model
                                                        .driverInformation
                                                        ?.driverInfoId
                                                        ?.idBehindKey,
                                                    hint:
                                                        LocaleKeys.behind.tr(),
                                                    // validator: (value) {
                                                    //   return shippingcubit.validation(
                                                    //       message:
                                                    //           "This field is required.",
                                                    //       condition: shippingcubit
                                                    //               .model
                                                    //               .idImageInFront ==
                                                    //           null);
                                                    // },
                                                    onTap: (image) {
                                                      shippingcubit
                                                          .pickImageIdBehind(
                                                              image: image);
                                                    },
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
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2),
                                                      child: Text(
                                                        field.errorText ?? "",
                                                        style:
                                                            Styles.mediumText(
                                                                color:
                                                                    Colors.red),
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
                        // Row(
                        //   children: [

                        //   ],
                        // ),
                        // const Gap(30),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: LocaleKeys.drivingLicense.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Sizer(),
                                FormField(
                                  // validator: (value) {
                                  //   if (shippingcubit.model.drivingImageBehind ==
                                  //           null ||
                                  //       shippingcubit.model.drivingImageInFront ==
                                  //           null) {
                                  //     return "This field is required!";
                                  //   }
                                  // },
                                  builder: (field) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ImageValidation(
                                              noTextError: true,
                                              width: 95,
                                              networkImage: mainState
                                                  .model
                                                  .driverInformation
                                                  ?.driverInfoId
                                                  ?.drivingLicenseFrontKey,
                                              // iconColor: Colors.grey,
                                              hint: LocaleKeys.inFront.tr(),
                                              // validator: (value) {
                                              //   return shippingcubit.validation(
                                              //       message:
                                              //           "This field is required.",
                                              //       condition: shippingcubit.model
                                              //               .idImageInFront ==
                                              //           null);
                                              // },
                                              onTap: (image) {
                                                shippingcubit
                                                    .pickImageDrivingInFront(
                                                        image: image);
                                              },
                                            ),
                                            // const Sizer(),
                                            ImageValidation(
                                              noTextError: true,
                                              width: 95,
                                              networkImage: mainState
                                                  .model
                                                  .driverInformation
                                                  ?.driverInfoId
                                                  ?.drivingLicenseBehindKey,
                                              hint: LocaleKeys.behind.tr(),
                                              // validator: (value) {
                                              //   return shippingcubit.validation(
                                              //       message:
                                              //           "This field is required.",
                                              //       condition: shippingcubit.model
                                              //               .idImageInFront ==
                                              //           null);
                                              // },
                                              onTap: (image) {
                                                shippingcubit
                                                    .pickImageDrivingBehind(
                                                        image: image);
                                              },
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
                            /////
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Label(
                                  text: LocaleKeys.license.tr(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      color: AppColors.PRIMARY_COLOR,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Sizer(),
                                FormField(
                                  // validator: (value) {
                                  //   if (shippingcubit.model.licenseImageBehind ==
                                  //           null ||
                                  //       shippingcubit.model.licenseImageInFront ==
                                  //           null) {
                                  //     return "This field is required!";
                                  //   }
                                  // },
                                  builder: (field) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ImageValidation(
                                              noTextError: true,
                                              width: 95,
                                              networkImage: mainState
                                                  .model
                                                  .driverInformation
                                                  ?.driverInfoId
                                                  ?.carLicenseFrontKey,
                                              hint: LocaleKeys.inFront.tr(),
                                              // validator: (value) {
                                              //   return shippingcubit.validation(
                                              //       message:
                                              //           "This field is required.",
                                              //       condition: shippingcubit.model
                                              //               .idImageInFront ==
                                              //           null);
                                              // },
                                              onTap: (image) {
                                                shippingcubit
                                                    .pickImageLicenseInFront(
                                                        image: image);
                                              },
                                            ),
                                            // const Sizer(),
                                            ImageValidation(
                                              width: 95,
                                              noTextError: true,
                                              networkImage: mainState
                                                  .model
                                                  .driverInformation
                                                  ?.driverInfoId
                                                  ?.carLicenseBehindKey,
                                              hint: LocaleKeys.behind.tr(),
                                              // validator: (value) {
                                              //   return shippingcubit.validation(
                                              //       message:
                                              //           "This field is required.",
                                              //       condition: shippingcubit.model
                                              //               .idImageInFront ==
                                              //           null);
                                              // },
                                              onTap: (image) {
                                                shippingcubit
                                                    .pickImageLicenseBehind(
                                                        image: image);
                                              },
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
                                // validator: (p0) {
                                //   if (p0 == null || p0.isEmpty) {
                                //     return "This field is required!";
                                //   }
                                // },
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
                                // validator: (p0) {
                                //   if (p0 == null || p0.isEmpty) {
                                //     return "This field is required!";
                                //   }
                                // },
                                currentController: plateNumberController,
                                currentFocusNode: plateNumberFocusNode,
                                hint: LocaleKeys.plateInformation.tr(),
                              ),
                            ),
                          ],
                        ),
                        // const Gap(20),
                        const SizedBox(
                          height: 10,
                        ),
                        CreateDoctorIDExpiryDatePicker(
                          textStyle: const TextStyle(
                              fontSize: 17,
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600),
                          borderWidth: 1,
                          borderColor: Colors.black,
                          onDateSelected: (date) {
                            shippingcubit.pickIDExpiryDate(date!);
                          },
                          // validator: (value) {
                          //   return shippingcubit.validation(
                          //       message: "fill your id expiry date!",
                          //       condition:
                          //           shippingcubit.model.idExpiryDate == null);
                          // },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CreateDoctorIDExpiryDatePicker(
                          title: LocaleKeys.drivingLicenseExpiryDate.tr(),
                          textStyle: const TextStyle(
                              fontSize: 17,
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600),
                          borderWidth: 1,
                          onDateSelected: (date) {
                            context
                                .read<ShippingCubit>()
                                .pickDrivingExpiryDate(date!);
                          },
                          // validator: (value) {
                          //   return shippingcubit.validation(
                          //       message: "fill your driving license expiry date!",
                          //       condition:
                          //           shippingcubit.model.drivingExpiryDate ==
                          //               null);
                          // },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CreateDoctorIDExpiryDatePicker(
                          borderWidth: 1,
                          title: LocaleKeys.licenseExpiryDate.tr(),
                          textStyle: const TextStyle(
                              fontSize: 17,
                              color: AppColors.PRIMARY_COLOR,
                              fontWeight: FontWeight.w600),
                          onDateSelected: (date) {
                            shippingcubit.pickLicenseExpiryDate(date!);
                          },
                          // validator: (value) {
                          //   return shippingcubit.validation(
                          //       message: "fill your license expiry date!",
                          //       condition:
                          //           shippingcubit.model.licenseExpiryDate ==
                          //               null);
                          // },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FormField(
                          // validator: (value) {
                          //   if (shippingcubit.model.model == null) {
                          //     return "fill your car model!";
                          //   }
                          // },
                          builder: (field) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 4),
                                  height: 55,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: field.hasError
                                            ? Colors.red
                                            : Colors.black,
                                      )),
                                  child: DefaultTextFormField(
                                      hintColor: AppColors.PRIMARY_COLOR,
                                      currentFocusNode: model,
                                      currentController: modelController,
                                      // hintFontSize: 16,
                                      noBoarder: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 5),
                                      // constraints: const BoxConstraints(
                                      //     maxHeight: 70, minHeight: 70),
                                      // onChanged: (value) {
                                      //   shippingcubit.model.model = value;
                                      // },
                                      hint: LocaleKeys.model.tr()),
                                ),
                                if (field.hasError)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          field.errorText ?? "",
                                          style: Styles.mediumText(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  )
                              ],
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInfoText(
                          text: LocaleKeys
                              .theApplicationDoesNotDeductAnyPercentage
                              .tr(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInfoText(
                          text: LocaleKeys.youWillGetPoundsAnnually.tr(),
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
                            label: LocaleKeys.update.tr(),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                shippingcubit.model.firstName =
                                    firstNameController.text;
                                shippingcubit.model.model =
                                    modelController.text;
                                shippingcubit.model.lastName =
                                    lastNameController.text;
                                shippingcubit.model.phone =
                                    phoneController.text;
                                shippingcubit.model.idNumber =
                                    idNumberController.text;
                                shippingcubit.model.plateInfromation =
                                    plateNumberController.text;
                                context.read<UpdateDriverCubit>().update(
                                    shippingcubit.model,
                                    context.read<ShippingCubit>());
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Align(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.PRIMARY_COLOR,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
