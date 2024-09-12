import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/name_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/phone_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/cities_dropdowns.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/governorate_dropdown.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
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
   RegisterShippingScreen({super.key});

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
        padding:  const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(
                  height: 30.h,
                ),
                //  Gap(30),
                Text(
                  "Welcome to shipping register",
                  style: Styles.headerText(
                    fontSize: 20.sp,
                    color: AppColors.PRIMARY_COLOR_DARK,
                  ),
                ),
                 SizedBox(
                  height: 40.h,
                ),
                //  Gap(40),
                Center(
                  child: BlocBuilder<ShippingCubit, ShippingState>(
                    builder: (context, state) {
                      if (state is SuccessGetBannerState) {
                        log(state.toString(), name: "llllllllllllllllllllll");

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gap(8),
                             SizedBox(
                              height: 8.h,
                            ),
                            FormField(
                              validator: (value) {
                                return shippingcubit.validation(
                                    message: "This field is required.",
                                    condition:
                                        shippingcubit.model.subCategoryEntity ==
                                            null);
                              },
                              builder: (field) {
                                log(field.hasError.toString(), name: "field");
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        hintText: "Sub Category",
                                        dropdownMenuEntries: state
                                            .model.subCategories!
                                            .map(
                                              (e) => SubCategoryEntity(
                                                  id: e.subCategoryId!,
                                                  image: e.picture ?? "",
                                                  isFavorite: false,
                                                  name: e.subCategoryNameEn ??
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
                                     SizedBox(
                                      height: 8.h,
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
                 SizedBox(
                  height: 35.h,
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
                    Sizer(),
                    Expanded(
                      child: LastNameTextFormField(
                        currentFocusNode: lastNameFocusNode,
                        currentController: lastNameController,
                        // nextFocusNode: phoneFocusNode,
                      ),
                    ),
                  ],
                ),
                //  Gap(30),
                 SizedBox(
                  height: 30.h,
                ),
                // CreateDoctorProfilePhotoPicker(),
                ImageValidation(
                  tilte: "Photo",
                  validator: (value) {
                    return shippingcubit.validation(
                        message: "This field is required.",
                        condition: shippingcubit.model.image == null);
                  },
                  onTap: (image) {
                    shippingcubit.pickImageUser(image: image);
                  },
                ),
                //  CreateDoctorPhoneField(),
                //  Gap(30),
                 SizedBox(
                  height: 30.h,
                ),
                Text(
                  "Car Pictures",
                  style: Styles.headerText(
                    fontSize: 20.sp,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
                //  Gap(20),
                 SizedBox(
                  height: 20.h,
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
                                    shippingcubit.model.carImageRight == null);
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
                                    shippingcubit.model.carImageLeft == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageCarLeft(image: image);
                          },
                        ),
                      ],
                    ),
                    // Gap(20),
                     SizedBox(
                      height: 20.h,
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
                                    shippingcubit.model.carImageBehind == null);
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
                //  Gap(30),
                 SizedBox(height: 30.h),
                // Container(
                //   width: double.infinity,
                //   padding:  EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //       color:  Color(0xFFE0E0E0),
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Flexible(
                //         // flex: 2,
                //         child: Text(
                //           Labels.identificationCard,
                //           style: Styles.headerText(fontSize: 20.sp),
                //         ),
                //       ),
                //        Spacer(),

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
                //            SizedBox(
                //             height: 15.h,
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
                    Sizer(),
                    Row(
                      children: [
                        ImageValidation(
                          // iconColor: Colors.grey,
                          hint: Labels.inFront,
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.idImageInFront == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageIdInFront(image: image);
                          },
                        ),
                        Sizer(),
                        ImageValidation(
                          // iconColor: Colors.grey,
                          hint: Labels.behind,
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.idImageInFront == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageIdBehind(image: image);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                //  Gap(20),
                 SizedBox(
                  height: 20.h,
                ),
                CreateDoctorIDExpiryDatePicker(
                  onDateSelected: (date) {
                    shippingcubit.pickIDExpiryDate(date!);
                  },
                  validator: (value) {
                    return shippingcubit.validation(
                        message: "This field is required.",
                        condition: shippingcubit.model.idExpiryDate == null);
                  },
                ),
                //  Gap(40),
                 SizedBox(
                  height: 40.h,
                ),
                // Container(
                //   width: double.infinity,
                //   padding:  EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //       color:  Color(0xFFE0E0E0),
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Row(
                //     children: [
                //       Flexible(
                //         child: Text(
                //           Labels.drivingLicense,
                //           style: Styles.headerText(fontSize: 20.sp),
                //         ),
                //       ),
                //        Spacer(),
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
                //            SizedBox(
                //             height: 15.h,
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
                    Sizer(),
                    Row(
                      children: [
                        ImageValidation(
                          // iconColor: Colors.grey,
                          hint: Labels.inFront,
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.idImageInFront == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageIdInFront(image: image);
                          },
                        ),
                        Sizer(),
                        ImageValidation(
                          // iconColor: Colors.grey,
                          hint: Labels.behind,
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.idImageInFront == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageLicenseBehind(image: image);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                //  Gap(20),
                 SizedBox(
                  height: 20.h,
                ),
                CreateDoctorIDExpiryDatePicker(
                  onDateSelected: (date) {
                    context.read<ShippingCubit>().pickDrivingExpiryDate(date!);
                  },
                  validator: (value) {
                    return shippingcubit.validation(
                        message: "This field is required.",
                        condition:
                            shippingcubit.model.drivingExpiryDate == null);
                  },
                ),
                //  Gap(40),
                 SizedBox(
                  height: 40.h,
                ),
                // Container(
                //   width: double.infinity,
                //   padding:  EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //       color:  Color(0xFFE0E0E0),
                //       borderRadius: BorderRadius.circular(10)),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Flexible(
                //         child: Text(
                //           Labels.license,
                //           style: Styles.headerText(fontSize: 20.sp),
                //         ),
                //       ),
                //        Spacer(),
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
                //            SizedBox(
                //             height: 15.h,
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
                //  Gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: Labels.license,
                      style: Styles.headerText(),
                    ),
                    Sizer(),
                    Row(
                      children: [
                        ImageValidation(
                          // // iconColor: Colors.grey,
                          hint: Labels.inFront,
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.idImageInFront == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageLicenseInFront(image: image);
                          },
                        ),
                        Sizer(),
                        ImageValidation(
                          // iconColor: Colors.grey,
                          hint: Labels.behind,
                          validator: (value) {
                            return shippingcubit.validation(
                                message: "This field is required.",
                                condition:
                                    shippingcubit.model.idImageInFront == null);
                          },
                          onTap: (image) {
                            shippingcubit.pickImageLicenseBehind(image: image);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                 SizedBox(
                  height: 20.h,
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
                //  Gap(40),
                 SizedBox(
                  height: 40.h,
                ),
                DefaultTextFormField(
                    validator: (value) {
                      if (value != null) {
                        return "This field is required.";
                      } else {
                        return null;
                      }
                    },
                    currentFocusNode: FocusNode(),
                    currentController: TextEditingController(),
                    hint: Labels.model),
                //  Gap(30),
                 SizedBox(
                  height: 30.h,
                ),
                // DefaultTextFormField(currentFocusNode: FocusNode(), currentController: TextEditingController(), hint: Labels.phone),

                //  Gap(50),
                 SizedBox(
                  height: 50.h,
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
                            condition: shippingcubit.model.governorate == null);
                      },
                    ),
                  ),
                ),

                Sizer(height: 20.h),
                 const CreateDoctorCitiesDropdowns(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Image.asset(
                      Assets.logo,
                      width: 25,
                      height: 25.h,
                    )),
                    //  Gap(10),
                     const SizedBox(
                      width: 10,
                    ),
                     Flexible(
                        flex: 3,
                        child: Text(Labels.theApplicationDoesNot,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold))),
                  ],
                ),
                //  Gap(30),
                 SizedBox(
                  height: 30.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        child: Image.asset(
                      Assets.logo,
                      width: 25,
                      height: 25.h,
                    )),
                     const SizedBox(
                      width: 10,
                    ),
                    //  Gap(10),
                     Flexible(
                        flex: 3,
                        child: Text(
                          Labels.youWillGetPounds,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                 SizedBox(
                  height: 30.h,
                ),
                //  Gap(30),
                Align(
                  alignment: Alignment.center,
                  child: AppButton(
                    label: Labels.submit,
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      //   log("333333333333333333333333333333333");
                      // }
                      // context.read<ShippingCubit>().getUserS3Imag();
                      context.go(Routes.CREATEDOCTOR);
                    },
                  ),
                  // child: Container(
                  //   padding:  EdgeInsets.all(10),
                  //   decoration: BoxDecoration(
                  //       color: AppColors.PRIMARY_COLOR,
                  //       borderRadius: BorderRadius.circular(20)),
                  //   child: Center(
                  //     child: Text(
                  //       Labels.submit,
                  //       style: Styles.headerText(
                  //           color: Colors.white, fontSize: 18.sp),
                  //     ),
                  //   ),
                  // ),
                ),
                //  Gap(100)
                 SizedBox(
                  height: 100.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PickImageShippingCard extends StatefulWidget {
   PickImageShippingCard(
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
            ?  const SizedBox()
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Icon(
                    Icons.camera_alt,
                    color: Colors.grey,
                    size: 30,
                  ),
                   SizedBox(height: 10.h),
                  Text(
                    widget.text,
                    style: Styles.headerText(),
                  ),
                ],
              )),
      ),
    );
  }
}
