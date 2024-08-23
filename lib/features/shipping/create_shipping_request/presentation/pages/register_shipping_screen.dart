import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/app_info_service.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/name_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/phone_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/cities_dropdowns.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/governorate_dropdown.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/create_trip_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_state.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/widgets/image_validation.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
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
  FocusNode descriptionFocusNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
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
              context.push(Routes.SHIPPING);
            }
            if (state is FailureShippingState) {
              showErrorMessage(
                  context, getFailureMessage(state.failure, context));
            }
          },
          builder: (context, state) {
            if (state is LoadingShippingState) {
              return Align(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.PRIMARY_COLOR,),
                ),
              );
            }
            return Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    // const Gap(30),
                    Text(
                      "Welcome to shipping register",
                      style: Styles.headerText(
                        fontSize: 20,
                        color: AppColors.PRIMARY_COLOR_DARK,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
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
                                    return shippingcubit.validation(
                                        message: "This field is required.",
                                        condition: shippingcubit
                                                .model.subCategoryEntity ==
                                            null);
                                  },
                                  builder: (field) {
                                    log(field.hasError.toString(),
                                        name: "field");
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        DropdownMenu<SubCategoryEntity>(
                                            inputDecorationTheme:
                                                InputDecorationTheme(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: field.hasError
                                                          ? Colors.red
                                                          : Colors.grey)),
                                              errorBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: field.hasError
                                                    ? Colors.red
                                                    : Colors.grey,
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: field.hasError
                                                    ? Colors.red
                                                    : Colors.grey,
                                              )),
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: field.hasError
                                                    ? Colors.red
                                                    : Colors.grey,
                                              )),
                                            ),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.95,
                                            hintText: "Sub Category",
                                            dropdownMenuEntries: state
                                                .model.subCategories!
                                                .map(
                                                  (e) => SubCategoryEntity(
                                                      id: e.subCategoryId!,
                                                      image: e.picture ?? "",
                                                      isFavorite: false,
                                                      name:
                                                          e.subCategoryNameEn ??
                                                              ""),
                                                )
                                                .map((e) => DropdownMenuEntry<
                                                        SubCategoryEntity>(
                                                    value: e, label: e.name))
                                                .toList(),
                                            onSelected: (value) {
                                              if (value != null) {
                                                shippingcubit.selectSubCategory(
                                                    subCategory: value);
                                              }
                                            }),
                                        // Gap(8),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        if (field.hasError)
                                          Text(
                                            field.errorText ?? "",
                                            style: Styles.mediumText(
                                                color: Colors.red),
                                          )
                                      ],
                                    );
                                  },
                                )
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    // Gap(35),
                    const SizedBox(
                      height: 35,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: FirstNameTextFormField(
                            currentFocusNode: firstNameFocusNode,
                            currentController: firstNameController,
                            nextFocusNode: lastNameFocusNode,
                          ),
                        ),
                        const Sizer(),
                        Expanded(
                          child: LastNameTextFormField(
                            currentFocusNode: lastNameFocusNode,
                            currentController: lastNameController,
                            // nextFocusNode: phoneFocusNode,
                          ),
                        ),
                      ],
                    ),
                    // const Gap(30),
                    const SizedBox(
                      height: 30,
                    ),
                    DefaultTextFormField(
                      hint: Labels.phone,
                      currentFocusNode: phoneFocusNode,
                      currentController: phoneController,
                      nextFocusNode: phoneFocusNode,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // CreateDoctorProfilePhotoPicker(),
                    ImageValidation(
                      title: "Photo",
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: shippingcubit.model.image == null);
                      },
                      onTap: (image) {
                        shippingcubit.pickImageUser(image: image);
                      },
                    ),
                    // const CreateDoctorPhoneField(),
                    // const Gap(30),
                    const SizedBox(
                      height: 30,
                    ),
                    ImageValidation(
                      title: "Plate",
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition: shippingcubit.model.plate == null);
                      },
                      onTap: (image) {
                        shippingcubit.pickImagePlate(image: image);
                      },
                    ),
                    // const CreateDoctorPhoneField(),
                    // const Gap(30),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Car Pictures",
                      style: Styles.headerText(
                        fontSize: 20,
                        color: AppColors.PRIMARY_COLOR,
                      ),
                    ),
                    // const Gap(20),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // FormField()
                            // ImagePickerPlaceholder(
                            //   tilte: Labels.left,
                            // ),
                            ImageValidation(
                              hint: Labels.right,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.carImageRight ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageCarRight(image: image);
                              },
                            ),
                            ImageValidation(
                              hint: Labels.left,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.carImageLeft ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageCarLeft(image: image);
                              },
                            ),
                          ],
                        ),
                        // Gap(20),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // ImagePickerPlaceholder(
                            //   tilte: Labels.behind,
                            // ),
                            ImageValidation(
                              hint: Labels.behind,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.carImageBehind ==
                                            null);
                              },
                              onTap: (image) {
                                log(image.toString());
                                shippingcubit.pickImageCarBehind(image: image);
                              },
                            ),
                            ImageValidation(
                              hint: Labels.inFront,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.carImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageCarInFront(image: image);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const Gap(30),
                    const SizedBox(height: 30),
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
                    //           Labels.identificationCard,
                    //           style: Styles.headerText(fontSize: 20),
                    //         ),
                    //       ),
                    //       const Spacer(),

                    //       // Gap(30),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           // ImagePickerPlaceholder(
                    //           //   tilte: Labels.behind,
                    //           //   // iconColor: Colors.grey,
                    //           // ),
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: Labels.behind,
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
                    //   hint: Labels.inFront,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: "ID",
                          style: Styles.headerText(),
                        ),
                        const Sizer(),
                        Row(
                          children: [
                            ImageValidation(
                              // iconColor: Colors.grey,
                              hint: Labels.inFront,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.idImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageIdInFront(image: image);
                              },
                            ),
                            const Sizer(),
                            ImageValidation(
                              // iconColor: Colors.grey,
                              hint: Labels.behind,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.idImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageIdBehind(image: image);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const Gap(20),
                    const SizedBox(
                      height: 20,
                    ),
                    CreateDoctorIDExpiryDatePicker(
                      onDateSelected: (date) {
                        shippingcubit.pickIDExpiryDate(date!);
                      },
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition:
                                shippingcubit.model.idExpiryDate == null);
                      },
                    ),
                    // const Gap(40),
                    const SizedBox(
                      height: 40,
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
                    //           Labels.drivingLicense,
                    //           style: Styles.headerText(fontSize: 20),
                    //         ),
                    //       ),
                    //       const Spacer(),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           // ImagePickerPlaceholder(
                    //           //   tilte: Labels.behind,
                    //           //   // iconColor: Colors.grey,
                    //           // ),
                    //           // Gap(15),
                    //           // ImagePickerPlaceholder(
                    //           //     tilte: Labels.inFront, iconColor: Colors.grey),
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: Labels.behind,
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
                    //             hint: Labels.inFront,
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

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: Labels.drivingLicense,
                          style: Styles.headerText(),
                        ),
                        const Sizer(),
                        Row(
                          children: [
                            ImageValidation(
                              // iconColor: Colors.grey,
                              hint: Labels.inFront,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.idImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageDrivingInFront(
                                    image: image);
                              },
                            ),
                            const Sizer(),
                            ImageValidation(
                              // iconColor: Colors.grey,
                              hint: Labels.behind,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.idImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageDrivingBehind(
                                    image: image);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const Gap(20),
                    const SizedBox(
                      height: 20,
                    ),
                    CreateDoctorIDExpiryDatePicker(
                      onDateSelected: (date) {
                        context
                            .read<ShippingCubit>()
                            .pickDrivingExpiryDate(date!);
                      },
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition:
                                shippingcubit.model.drivingExpiryDate == null);
                      },
                    ),
                    // const Gap(40),
                    const SizedBox(
                      height: 40,
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
                    //           Labels.license,
                    //           style: Styles.headerText(fontSize: 20),
                    //         ),
                    //       ),
                    //       const Spacer(),
                    //       Column(
                    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //         children: [
                    //           ImageValidation(
                    //             // iconColor: Colors.grey,
                    //             hint: Labels.behind,
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
                    //             hint: Labels.inFront,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: Labels.license,
                          style: Styles.headerText(),
                        ),
                        const Sizer(),
                        Row(
                          children: [
                            ImageValidation(
                              // // iconColor: Colors.grey,
                              hint: Labels.inFront,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.idImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageLicenseInFront(
                                    image: image);
                              },
                            ),
                            const Sizer(),
                            ImageValidation(
                              // iconColor: Colors.grey,
                              hint: Labels.behind,
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.idImageInFront ==
                                            null);
                              },
                              onTap: (image) {
                                shippingcubit.pickImageLicenseBehind(
                                    image: image);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CreateDoctorIDExpiryDatePicker(
                      onDateSelected: (date) {
                        shippingcubit.pickLicenseExpiryDate(date!);
                      },
                      validator: (value) {
                        return shippingcubit.validation(
                            message: "This field is required.",
                            condition:
                                shippingcubit.model.licenseExpiryDate == null);
                      },
                    ),
                    // const Gap(40),
                    const SizedBox(
                      height: 40,
                    ),
                    DefaultTextFormField(
                        onChanged: (value) {
                          shippingcubit.model.model = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "This field is required.";
                          } else {
                            return null;
                          }
                        },
                        currentFocusNode: FocusNode(),
                        currentController: TextEditingController(),
                        hint: Labels.model),
                    // const Gap(30),
                    // const SizedBox(
                    //   height: 30,
                    // ),
                    // DefaultTextFormField(currentFocusNode: FocusNode(), currentController: TextEditingController(), hint: Labels.phone),

                    // const Gap(50),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: BlocListener<CreateDoctorCubit, CreateDoctorState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        child: CreateDoctorGovernorateDropdown(
                          onSelected: (value) {
                            if (value != null) {
                              shippingcubit.setGovernorate(governorate: value);
                            }
                          },
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.governorate == null);
                          },
                        ),
                      ),
                    ),

                    const Sizer(height: 20),
                    const CreateDoctorCitiesDropdowns(),
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
                    //     child: Text(Labels.theApplicationDoesNot,
                    //         textAlign: TextAlign.start,
                    //         style: TextStyle(
                    //             fontSize: 18, fontWeight: FontWeight.w500))),
                    //   ],
                    // ),
                    AppInfoText(
                      text: Labels.theApplicationDoesNot,
                    ),
                    // const Gap(30),
                    const SizedBox(
                      height: 30,
                    ),
                    AppInfoText(
                      text: Labels.youWillGetPounds,
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
                    //           Labels.youWillGetPounds,
                    //           textAlign: TextAlign.start,
                    //           style: TextStyle(
                    //               fontSize: 20, fontWeight: FontWeight.bold),
                    //         )),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 30,
                    ),
                    // const Gap(30),
                    Align(
                      alignment: Alignment.center,
                      child: AppButton(
                        label: Labels.submit,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            shippingcubit.model.firstName =
                                firstNameController.text;
                            shippingcubit.model.lastName =
                                lastNameController.text;
                            shippingcubit.model.phone = phoneController.text;
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
                      //       Labels.submit,
                      //       style: Styles.headerText(
                      //           color: Colors.white, fontSize: 18),
                      //     ),
                      //   ),
                      // ),
                    ),
                    // const Gap(100)
                    const SizedBox(
                      height: 100,
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
