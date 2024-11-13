import 'dart:developer';
import 'dart:io';

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
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/image_validation.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterShippingScreen extends StatefulWidget {
  const RegisterShippingScreen({super.key});

  @override
  State<RegisterShippingScreen> createState() => _RegisterShippingScreenState();
}

class _RegisterShippingScreenState extends State<RegisterShippingScreen> {
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
        child: BlocConsumer<ShippingCubit, ShippingState>(
          listener: (context, state) {
            if (state is SuccessRegisterState) {
              showSuccessMessage(context, state.message);
              context.pushReplacementNamed(Routes.HOME);
            }
            if (state is FailureShippingState) {
              showErrorMessage(
                  context, getFailureMessage(state.failure, context));
            }
          },
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
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // const Gap(30),
                    Text(
                      LocaleKeys.welcomeToShipRegister.tr(),
                      style: Styles.headerText(
                        fontSize: 40,
                        color: AppColors.PRIMARY_COLOR_DARK,
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // const Gap(40),
                    Center(
                      child: BlocBuilder<ShippingCubit, ShippingState>(
                        builder: (context, state) {
                          if (state is SuccessGetBannerState) {
                            log(state.toString(),
                                name: "llllllllllllllllllllll");

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Gap(8),
                                const SizedBox(
                                  height: 8,
                                ),
                                FormField(
                                  validator: (value) {
                                    log(value.toString());
                                    return shippingcubit.validation(
                                      message: LocaleKeys.chooseYourFavoriteSubCategory.tr(),
                                      condition:
                                          shippingcubit.model.subCategoryId ==
                                              null,
                                    );
                                  },
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
                                                color: AppColors.PRIMARY_COLOR,
                                                fontWeight: FontWeight.w600),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                    color: field.hasError
                                                        ? Colors.red
                                                        : Colors.grey)),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: field.hasError
                                                      ? Colors.red
                                                      : Colors.black,
                                                )),
                                            enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color: field.hasError
                                                      ? Colors.red
                                                      : Colors.black,
                                                )),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                          hintText: LocaleKeys.subCategory.tr(),
                                          dropdownMenuEntries: state
                                              .model.subCategories!
                                              .map((e) => SubCategoryEntity(
                                                    id: e.subCategoryId!,
                                                    image: e.picture ?? "",
                                                    isFavorite: false,
                                                    nameAr: e.subCategoryNameAr ??
                                                        "",
                                            nameEn: e.subCategoryNameEn ??
                                                        "",
                                                  ))
                                              .map((e) => DropdownMenuEntry<
                                                      SubCategoryEntity>(
                                                  value: e, label: context.isArabic?e.nameAr:e.nameEn))
                                              .toList(),
                                          onSelected: (value) {
                                            setState(() {
                                              if (value != null) {
                                                shippingcubit.selectSubCategory(
                                                    subCategory: value);
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
                                            padding: const EdgeInsets.symmetric(
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
                    // Gap(35),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FirstNameTextFormField(
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
                    DefaultTextFormField(
                      currentFocusNode: phoneFocusNode,
                      nextFocusNode: model,
                      hint: LocaleKeys.phone.tr(),
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentController: phoneController,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return LocaleKeys.phoneIsRequired.tr();
                        }
                        return null;
                      },
                    ),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // CreateDoctorProfilePhotoPicker(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     ImageValidation(
                    //       textStyle: TextStyle(
                    //           fontSize: 17,
                    //           color: AppColors.PRIMARY_COLOR,
                    //           fontWeight: FontWeight.w600),
                    //       width: 95,
                    //       title: "Photo",
                    //       validator: (value) {
                    //         return shippingcubit.validation(
                    //             message: "Upload your photo!",
                    //             condition: shippingcubit.model.image == null);
                    //       },
                    //       onTap: (image) {
                    //         shippingcubit.pickImageUser(image: image);
                    //       },
                    //     ),
                    // const CreateDoctorPhoneField(),
                    // const Gap(30),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // ImageValidation(
                    //   width: 95,
                    //   textStyle: TextStyle(
                    //       fontSize: 17,
                    //       color: AppColors.PRIMARY_COLOR,
                    //       fontWeight: FontWeight.w600),
                    //   title: "Plate",
                    //   validator: (value) {
                    //     return shippingcubit.validation(
                    //         message: "Upload your car plate!",
                    //         condition: shippingcubit.model.plate == null);
                    //   },
                    //   onTap: (image) {
                    //     shippingcubit.pickImagePlate(image: image);
                    //   },
                    // ),
                    // ],
                    // ),
                    // const CreateDoctorPhoneField(),
                    // const Gap(30),
                    /////////////////////////////////////////////
                    const SizedBox(
                      height: 10,
                    ),
                    // // Row(
                    //   children: [

                    //     SizedBox(width: 20,),

                    //   ],
                    // ),
                    // const Gap(20),

                    FormField(
                      validator: (value) {
                        if (shippingcubit.model.carImageInFront == null &&
                            shippingcubit.model.idImageBehind == null &&
                            shippingcubit.model.idImageInFront == null) {
                          return LocaleKeys.thisFieldIsRequired.tr();
                        }
                        return null;
                      },
                      builder: (field) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                            hint: LocaleKeys.inFront.tr(),
                                            validator: (value) {
                                              return shippingcubit.validation(
                                                  message: LocaleKeys.thisFieldIsRequired.tr(),
                                                  condition: shippingcubit.model
                                                          .carImageInFront ==
                                                      null);
                                            },
                                            onTap: (image) {
                                              shippingcubit.pickImageCarInFront(
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
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ImageValidation(
                                                width: 95,
                                                noTextError: true,
                                                // iconColor: Colors.grey,
                                                hint: LocaleKeys.inFront.tr(),
                                                validator: (value) {
                                                  return shippingcubit.validation(
                                                      message: LocaleKeys.thisFieldIsRequired.tr(),
                                                      condition: shippingcubit
                                                              .model
                                                              .idImageInFront ==
                                                          null);
                                                },
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
                                                // iconColor: Colors.grey,
                                                hint: LocaleKeys.behind.tr(),
                                                validator: (value) {
                                                  return shippingcubit.validation(
                                                      message: LocaleKeys.thisFieldIsRequired.tr(),
                                                      condition: shippingcubit
                                                              .model
                                                              .idImageInFront ==
                                                          null);
                                                },
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
                                                      .symmetric(horizontal: 2),
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
                              validator: (value) {
                                if (shippingcubit.model.drivingImageBehind ==
                                        null ||
                                    shippingcubit.model.drivingImageInFront ==
                                        null) {
                                  return LocaleKeys.thisFieldIsRequired.tr();
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ImageValidation(
                                          noTextError: true,
                                          width: 95,
                                          // iconColor: Colors.grey,
                                          hint: LocaleKeys.inFront.tr(),
                                          validator: (value) {
                                            return shippingcubit.validation(
                                                message: LocaleKeys.thisFieldIsRequired
                                                        .tr(),
                                                condition: shippingcubit
                                                        .model.idImageInFront ==
                                                    null);
                                          },
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
                                          // iconColor: Colors.grey,
                                          hint: LocaleKeys.behind.tr(),
                                          validator: (value) {
                                            return shippingcubit.validation(
                                                message: LocaleKeys.thisFieldIsRequired
                                                        .tr(),
                                                condition: shippingcubit
                                                        .model.idImageInFront ==
                                                    null);
                                          },
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
                              validator: (value) {
                                if (shippingcubit.model.licenseImageBehind ==
                                        null ||
                                    shippingcubit.model.licenseImageInFront ==
                                        null) {
                                  return LocaleKeys.thisFieldIsRequired.tr();
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ImageValidation(
                                          noTextError: true,
                                          width: 95,
                                          // // iconColor: Colors.grey,
                                          hint: LocaleKeys.inFront.tr(),
                                          validator: (value) {
                                            return shippingcubit.validation(
                                                message: LocaleKeys.thisFieldIsRequired
                                                        .tr(),
                                                condition: shippingcubit
                                                        .model.idImageInFront ==
                                                    null);
                                          },
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
                                          // iconColor: Colors.grey,
                                          hint: LocaleKeys.behind.tr(),
                                          validator: (value) {
                                            return shippingcubit.validation(
                                                message: LocaleKeys.thisFieldIsRequired
                                                        .tr(),
                                                condition: shippingcubit
                                                        .model.idImageInFront ==
                                                    null);
                                          },
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
                    /////////////////////////////////////
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(20),
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xFFE0E0E0),
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Flexible(
                    //         // flex: 2,
                    //         child: Text(
                    //           LocaleKeys.identificationCard,
                    //           style: Styles.headerText(fontSize: 20),
                    //         ),
                    //       ),
                    //       const Spacer(),

                    //       // Gap(30),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           // ImagePickerPlaceholder(
                    //           //   tilte: LocaleKeys.behind,
                    //           //   // iconColor: Colors.grey,
                    //           // ),
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: LocaleKeys.behind,
                    //             validator: (value) {
                    //               return shippingcubit.validation(
                    //                   message: "This field is required.",
                    //                   condition:
                    //                       shippingcubit.model.idImageBehind ==
                    //                           null);
                    //             },
                    //             onTap: (image) {
                    //               shippingcubit.pickImageIdBehind(image: image);
                    //             },
                    //           ),
                    //           // Gap(15),
                    //           const SizedBox(
                    //             height: 15,
                    //           ),
                    // ImageValidation(
                    //   // iconColor: Colors.grey,
                    //   hint: LocaleKeys.inFront,
                    //   validator: (value) {
                    //     return shippingcubit.validation(
                    //         message: "This field is required.",
                    //         condition:
                    //             shippingcubit.model.idImageInFront ==
                    //                 null);
                    //   },
                    //   onTap: (image) {
                    //     shippingcubit.pickImageIdInFront(image: image);
                    //   },
                    // ),
                    // ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                            hint: LocaleKeys.idNumber.tr()
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
                      validator: (value) {
                        return shippingcubit.validation(
                            message: LocaleKeys.fillYourIdExpiryDate.tr(),
                            condition:
                                shippingcubit.model.idExpiryDate == null);
                      },
                    ),
                    // const Gap(40),
                    const SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(20),
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xFFE0E0E0),
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Row(
                    //     children: [
                    //       Flexible(
                    //         child: Text(
                    //           LocaleKeys.drivingLicense,
                    //           style: Styles.headerText(fontSize: 20),
                    //         ),
                    //       ),
                    //       const Spacer(),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           // ImagePickerPlaceholder(
                    //           //   tilte: LocaleKeys.behind,
                    //           //   // iconColor: Colors.grey,
                    //           // ),
                    //           // Gap(15),
                    //           // ImagePickerPlaceholder(
                    //           //     tilte: LocaleKeys.inFront, iconColor: Colors.grey),
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: LocaleKeys.behind,
                    //             validator: (value) {
                    //               return shippingcubit.validation(
                    //                   message: "This field is required.",
                    //                   condition:
                    //                       shippingcubit.model.drivingImageBehind ==
                    //                           null);
                    //             },
                    //             onTap: (image) {
                    //               shippingcubit.pickImageDrivingBehind(
                    //                   image: image);
                    //             },
                    //           ),
                    //           // Gap(15),
                    //           const SizedBox(
                    //             height: 15,
                    //           ),
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: LocaleKeys.inFront,
                    //             validator: (value) {
                    //               return shippingcubit.validation(
                    //                   message: "This field is required.",
                    //                   condition:
                    //                       shippingcubit.model.drivingImageInFront ==
                    //                           null);
                    //             },
                    //             onTap: (image) {
                    //               shippingcubit.pickImageDrivingInFront(
                    //                   image: image);
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // const Gap(20),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    CreateDoctorIDExpiryDatePicker(
                      title: LocaleKeys.drivingLicenseExpiryDate.tr(),
                      // title: "" ExpiryDate",
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
                      validator: (value) {
                        return shippingcubit.validation(
                            message: LocaleKeys.fillYourDrivingLicenseExpiryDate.tr(),
                            condition:
                                shippingcubit.model.drivingExpiryDate == null);
                      },
                    ),
                    // const Gap(40),
                    const SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   padding: const EdgeInsets.all(20),
                    //   decoration: BoxDecoration(
                    //       color: const Color(0xFFE0E0E0),
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Flexible(
                    //         child: Text(
                    //           LocaleKeys.license,
                    //           style: Styles.headerText(fontSize: 20),
                    //         ),
                    //       ),
                    //       const Spacer(),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: LocaleKeys.behind,
                    //             validator: (value) {
                    //               return shippingcubit.validation(
                    //                   message: "This field is required.",
                    //                   condition:
                    //                       shippingcubit.model.drivingImageInFront ==
                    //                           null);
                    //             },
                    //             onTap: (image) {
                    //               shippingcubit.pickImageDrivingInFront(
                    //                   image: image);
                    //             },
                    //           ),
                    //           // Gap(15),
                    //           const SizedBox(
                    //             height: 15,
                    //           ),
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: LocaleKeys.inFront,
                    //             validator: (value) {
                    //               return shippingcubit.validation(
                    //                   message: "This field is required.",
                    //                   condition:
                    //                       shippingcubit.model.drivingImageBehind ==
                    //                           null);
                    //             },
                    //             onTap: (image) {
                    //               shippingcubit.pickImageDrivingBehind(
                    //                   image: image);
                    //             },
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const Gap(20),

                    // const SizedBox(
                    //   height: 20,
                    // ),
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
                      validator: (value) {
                        return shippingcubit.validation(
                            message: LocaleKeys.fillYourLicenseExpiryDate.tr(),
                            condition:
                                shippingcubit.model.licenseExpiryDate == null);
                      },
                    ),
                    // const Gap(40),
                    const SizedBox(
                      height: 10,
                    ),
                    // DefaultTextFormField(
                    //   contentPadding: EdgeInsets.z,
                    //   constraints: BoxConstraints(
                    //     maxHeight: 70,
                    //     minHeight: 70
                    //   ),
                    //     onChanged: (value) {
                    //       shippingcubit.model.model = value;
                    //     },
                    //     validator: (value) {
                    //       if (value == null) {
                    //         return "This field is required.";
                    //       } else {
                    //         return null;
                    //       }
                    //     },
                    //     currentFocusNode: FocusNode(),
                    //     currentController: TextEditingController(),
                    //     hint: LocaleKeys.model),
                    FormField(
                      validator: (value) {
                        if (modelController.text.isEmpty) {
                          return  LocaleKeys.fillYourCarModel.tr();
                        }
                        return null;
                      },
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
                                  borderColor: Colors.transparent,

                                  contentPadding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  // constraints: const BoxConstraints(
                                  //     maxHeight: 70, minHeight: 70),
                                  // onChanged: (value) {
                                  //   shippingcubit.model.model = value;
                                  // },
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return "You have to fill your car model !";
                                  //   } else {
                                  //     return null;
                                  //   }
                                  // },
                                  // currentFocusNode: FocusNode(),
                                  // currentController: TextEditingController(),
                                  hint: LocaleKeys.model.tr()),
                            ),
                            if (field.hasError)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Text(
                                      field.errorText ?? "",
                                      style:
                                          Styles.mediumText(color: Colors.red),
                                    ),
                                  ),
                                ],
                              )
                          ],
                        );
                      },
                    ),

                    // TextFormField(
                    //   // auto
                    //   decoration: InputDecoration(
                    //     constraints: BoxConstraints(
                    //       maxHeight: 80,
                    //       minHeight: 80,
                    //     )
                    //   ),
                    // ),
                    // const Gap(30),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // DefaultTextFormField(currentFocusNode: FocusNode(), currentController: TextEditingController(), hint: LocaleKeys.phone),

                    // const Gap(50),
                    const SizedBox(
                      height: 10,
                    ),
                    // Center(
                    //   child: BlocListener<CreateDoctorCubit, CreateDoctorState>(
                    //     listener: (context, state) {
                    //       // TODO: implement listener
                    //     },
                    //     child: CreateDoctorGovernorateDropdown(
                    //       hintStyle: TextStyle(
                    //           fontSize: 17,
                    //           color: Colors.red,
                    //           fontWeight: FontWeight.w600),
                    //       onSelected: (value) {
                    //         if (value != null) {
                    //           shippingcubit.setGovernorate(governorate: value);
                    //         }
                    //       },
                    //       validator: (value) {
                    //         return shippingcubit.validation(
                    //             message: "You have to fill you Governorate!",
                    //             condition:
                    //                 shippingcubit.model.governorate == null);
                    //       },
                    //     ),
                    //   ),
                    // ),

                    // const Sizer(height: 20),
                    // const CreateDoctorCitiesDropdowns(),
                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Flexible(
                    //         child: Image.asset(
                    //       Assets.logo,
                    //       width: 25,
                    //       height: 25,
                    //     )),
                    //     // const Gap(10),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    // const Flexible(
                    //     flex: 3,
                    //     child: Text(LocaleKeys.theApplicationDoesNot,
                    //         textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w500))),
                    //   ],
                    // ),
                     AppInfoText(
                      text: LocaleKeys.theApplicationDoesNotDeductAnyPercentage.tr(),
                    ),
                    // const Gap(30),
                    const SizedBox(
                      height: 10,
                    ),
                     AppInfoText(
                      text: LocaleKeys.youWillGetPoundsAnnually.tr(),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Flexible(
                    //         child: Image.asset(
                    //       Assets.logo,
                    //       width: 25,
                    //       height: 25,
                    //     )),
                    //     const SizedBox(
                    //       width: 10,
                    //     ),
                    //     // const Gap(10),
                    //     const Flexible(
                    //         flex: 3,
                    //         child: Text(
                    //           LocaleKeys.youWillGetPounds,
                    //           textAlign: TextAlign.start,
                    //           style: TextStyle(
                    //               fontSize: 20, fontWeight: FontWeight.bold),
                    //         )),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const Gap(30),
                    Align(
                      alignment: Alignment.center,
                      child: AppButton(
                        backColor: AppColors.PRIMARY_COLOR,
                        textColor: Colors.white,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        label: LocaleKeys.submit.tr(),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            shippingcubit.model.model =
                                modelController.text;
                            shippingcubit.model.firstName =
                                firstNameController.text;
                            shippingcubit.model.lastName =
                                lastNameController.text;
                            shippingcubit.model.phone = phoneController.text;
                            shippingcubit.model.idNumber =
                                idNumberController.text;
                            shippingcubit.model.plateInfromation =
                                plateNumberController.text;
                            context.read<ShippingCubit>().register();
                          }
                        },
                      ),
                      // child: Container(
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //       color: AppColors.PRIMARY_COLOR,
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: Center(
                      //     child: Text(
                      //       LocaleKeys.submit,
                      //       style: Styles.headerText(
                      //           color: Colors.white, fontSize: 18),
                      //     ),
                      //   ),
                      // ),
                    ),
                    // const Gap(100)
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PickImageShippingCard extends StatefulWidget {
  const PickImageShippingCard(
      {super.key,
      required this.text,
      this.borderRadius,
      this.width = 68,
      this.height = 88,
      this.onTap});
  final String text;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final void Function(File image)? onTap;
  @override
  State<PickImageShippingCard> createState() => _PickImageShippingCardState();
}

class _PickImageShippingCardState extends State<PickImageShippingCard> {
  XFile? image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedImage != null) {
          setState(() {
            image = pickedImage;
            if (widget.onTap != null) {
              widget.onTap!(File(pickedImage.path));
            }
          });
        }
      },
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: widget.borderRadius,
            image: image != null
                ? DecorationImage(
                    image: FileImage(
                      File(image!.path),
                    ),
                    fit: BoxFit.cover)
                : null),
        child: image != null
            ? const SizedBox()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                      size: 30,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.text,
                      style: Styles.headerText(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
