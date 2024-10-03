import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
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
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "First name is required!";
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
                          return "Last name is required!";
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
                      currentFocusNode: phoneFocusNode,
                      nextFocusNode: vehicleModelFocusNode,
                      hint: Labels.phone,
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentController: phoneController,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Phone is required!";
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
                      currentFocusNode: pricingPerKmFocusNode,
                      nextFocusNode: model,
                      hint: "Pricing Per Km",
                      hintColor: AppColors.PRIMARY_COLOR,
                      currentController: pricingPerKmController,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Pricing Per Km is required!";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Flexible(
              //       child: DefaultTextFormField(
              //         currentFocusNode: vehicleModelFocusNode,
              //         nextFocusNode: vehicleBrandFocusNode,
              //         hint: "Vehicle Model",
              //         hintColor: AppColors.PRIMARY_COLOR,
              //         currentController: vehicleModelController,
              //         validator: (p0) {
              //           if (p0 == null || p0.isEmpty) {
              //             return "Vehicle Model is required!";
              //           }
              //           return null;
              //         },
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Flexible(
              //       child: DefaultTextFormField(
              //         currentFocusNode: vehicleBrandFocusNode,
              //         nextFocusNode: vehicleColorFocusNode,
              //         hint: "Vehicle Brand",
              //         hintColor: AppColors.PRIMARY_COLOR,
              //         currentController: vehicleBrandController,
              //         validator: (p0) {
              //           if (p0 == null || p0.isEmpty) {
              //             return "Vehicle Brand is required!";
              //           }
              //           return null;
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Flexible(
              //       child: DefaultTextFormField(
              //         currentFocusNode: vehicleYearFocusNode,
              //         nextFocusNode: pricingPerKmFocusNode,
              //         hint: "Vehicle Year",
              //         hintColor: AppColors.PRIMARY_COLOR,
              //         currentController: vehicleYearController,
              //         validator: (p0) {
              //           if (p0 == null || p0.isEmpty) {
              //             return "Vehicle Year is required!";
              //           }
              //           return null;
              //         },
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Flexible(
              //       child: DefaultTextFormField(
              //         currentFocusNode: yourFavoriteCiryFocusNode,
              //         hint: "Your Favorite City",
              //         hintColor: AppColors.PRIMARY_COLOR,
              //         currentController: yourFavoriteCiryController,
              //         validator: (p0) {
              //           if (p0 == null || p0.isEmpty) {
              //             return "Vehicle Year is required!";
              //           }
              //           return null;
              //         },
              //       ),
              //     )
              //   ],
              // ),
              const SizedBox(
                height: 10,
              ),
              const CarInfoRider(),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 1,
              //       child: TypeAheadField<String>(
              //         builder: (context, controller, focusNode) {
              //           // controller.text = fetchCarBrandsCubit.brand ?? '';
              //           return TextField(
              //             controller: controller,
              //             focusNode: focusNode,

              //             // autofocus: true,
              //             decoration: InputDecoration(
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(15)),
              //               fillColor: Colors.transparent,
              //               label: const Text('Brand'),
              //               isDense: true,
              //               // Added this
              //               contentPadding: const EdgeInsets.all(14),
              //             ),
              //             onChanged: (value) {
              //               riderCubit.pickBrand(value);
              //               fetchCarModelsCubit.fetchCarModel(brand: value);
              //               fetchCarBrandsCubit.fetchCarBrand(search: value);
              //             },
              //             // validator: (value) {
              //             //   if (value == null || value.isEmpty) {
              //             //     return 'Car Brand Required';
              //             //   }
              //             //   return null;
              //             // },
              //           );
              //         },
              //         itemBuilder: (context, value) {
              //           return ListTile(title: Text(value));
              //         },
              //         onSelected: (value) {
              //           fetchCarBrandsCubit.brand = value;
              //           setState(() {});
              //         },
              //         suggestionsCallback: (search) async {
              //           // fetchCarBrandsCubit.brand = search;
              //           return fetchCarBrandsCubit.carBrandsList
              //               .map((e) => e?.brand ?? '')
              //               .toList();
              //         },
              //       ),
              //     ),
              //     const Sizer(),
              //     Expanded(
              //       flex: 1,
              //       child: TypeAheadField<String>(
              //         builder: (context, controller, focusNode) {
              //           log(controller.text,
              //               name: "lkkkkkkkkkkkkkkkkkdddddddddddddd");
              //           // controller.text = fetchCarModelsCubit.model ?? '';
              //           return TextField(
              //             controller: controller,
              //             focusNode: focusNode,
              //             // autofocus: true,
              //             decoration: InputDecoration(
              //               border: OutlineInputBorder(
              //                   borderRadius: BorderRadius.circular(15)),
              //               fillColor: Colors.transparent,
              //               label: const Text('Model'),
              //               isDense: true,
              //               // Added this
              //               contentPadding: const EdgeInsets.all(14),
              //             ),
              //             onChanged: (value) {
              //               riderCubit.pickModel(value);
              //               if (value.length == 1) {
              //                 fetchCarModelsCubit.fetchCarModel(
              //                     brand: fetchCarBrandsCubit.brand ?? '');
              //               }
              //             },
              //             // validator: (value) {
              //             //   if (value == null || value.isEmpty) {
              //             //     return 'Car Model Required';
              //             //   }
              //             //   return null;
              //             // },
              //           );
              //         },
              //         itemBuilder: (context, value) {
              //           return ListTile(title: Text(value));
              //         },
              //         onSelected: (value) {
              //           // print(' ============== $value');
              //           // fetchCarModelsCubit.model = value;
              //           setState(() {});
              //         },
              //         suggestionsCallback: (search) async {
              //           return fetchCarModelsCubit.carModels
              //               .map((e) => e?.model ?? '')
              //               .where((element) => element
              //                   .toLowerCase()
              //                   .contains(search.toLowerCase()))
              //               .toList();
              //         },
              //       ),
              //     ),
              const Sizer(),
              // Expanded(
              //   // height: 50,
              //   // width: 150,
              //   child: TypeAheadField<String>(
              //     builder: (context, controller, focusNode) {
              //       controller.text = fetchCarYearTypeCubit.year ?? '';
              //       return TextField(
              //         controller: controller,
              //         focusNode: focusNode,
              //         // autofocus: true,
              //         decoration: InputDecoration(
              //           border: OutlineInputBorder(
              //               borderRadius: BorderRadius.circular(15)),
              //           fillColor: Colors.transparent,
              //           hintText: 'Year',
              //         ),
              //         keyboardType: TextInputType.number,
              //         onChanged: (value) {
              //           fetchCarYearTypeCubit.year = value;
              //         },
              //       );
              //     },
              //     itemBuilder: (context, value) {
              //       return ListTile(title: Text(value));
              //     },
              //     onSelected: (value) {
              //       riderCubit.pickYear(value);
              //       setState(() {});
              //     },
              //     suggestionsCallback: (search) {
              //       fetchCarYearTypeCubit.getCarYears(
              //         brand: fetchCarBrandsCubit.brand ?? '',
              //         model: fetchCarModelsCubit.model ?? '',
              //       );
              //       // log(
              //       //     fetchCarYearTypeCubit.carYears
              //       //         .map((e) => e?.year ?? '')
              //       //         .where((element) =>
              //       //             element.toLowerCase().contains(search.toLowerCase()))
              //       //         .toList()
              //       //         .toString(),
              //       //     name: "lskjdflskdjflskjdf");
              //       // return fetchCarYearTypeCubit.carYears.map((e) => e?.year ?? '2000').toList();
              //       return fetchCarYearTypeCubit.carYears
              //           .map((e) => e?.year ?? '')
              //           .where((element) =>
              //               element.toLowerCase().contains(search.toLowerCase()))
              //           .toList();
              //     },
              //   ),
              // ),
              //   ],
              // ),
              // CarInfoV2(),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          onChanged: (value) {
                            setState(() {
                              registerRider.model.airCondition = value;
                            });
                          },
                          value: registerRider.model.airCondition ?? false,
                        ),
                        const Text(
                          "Air condition ac",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Switch(
                          onChanged: (value) {
                            setState(() {
                              registerRider.model.smoker = value;
                            });
                          },
                          value: registerRider.model.smoker ?? false,
                        ),
                        const Text(
                          "Smoker",
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              FormField(
                validator: (value) {
                  if (registerRider.model.carImage == null) {
                    return "This field is required!";
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
                                const Text(
                                  "Car Picture",
                                  style: TextStyle(
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
                                      validator: (value) {
                                        return registerRider.validation(
                                            message: "This field is required.",
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
                                const Label(
                                  text: "ID",
                                  style: TextStyle(
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
                                          validator: (value) {
                                            return registerRider.validation(
                                                message:
                                                    "This field is required.",
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
                                          onTap: (image) {
                                            registerRider
                                                .pickIdBehindImage(image);
                                          },
                                          validator: (value) {
                                            return registerRider.validation(
                                                message:
                                                    "This field is required.",
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
                                    onTap: (image) {
                                      registerRider
                                          .pickDrivingInFrontImage(image);
                                    },
                                    validator: (value) {
                                      return registerRider.validation(
                                          message: "This field is required.",
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
                                          message: "This field is required.",
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
                                          message: "This field is required.",
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
                                          message: "This field is required.",
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
                          return "This field is required!";
                        }
                        return null;
                      },
                      currentController: idNumberController,
                      currentFocusNode: idNumberFocusNode,
                      hint: "ID Number",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: DefaultTextFormField(
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "This field is required!";
                        }
                        return null;
                      },
                      currentController: plateNumberController,
                      currentFocusNode: plateNumberFocusNode,
                      hint: "Plate information",
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
                    return "This Faild is required!";
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
                    return "This Faild is required!";
                  }
                  return null;
                },
                title: "Driving License Expiry Date",
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
                    return "This Faild is required!";
                  }
                  return null;
                },
                borderWidth: 1,
                title: "License Expiry Date",
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
                                const Label(
                                  text: "Drag analysis",
                                  style: TextStyle(
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
                                        message: "This field is required.",
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
                                const Label(
                                  text: "Drag analysis",
                                  style: TextStyle(
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
                                        message: "This field is required.",
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
                                const Label(
                                  text: "Drag analysis",
                                  style: TextStyle(
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
                                        message: "This field is required.",
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
                    log(widget.formKey.currentState!.validate().toString(),
                        name: "lksdjflksjf");
                    // log("lksjdflksdjflskdjf", name: lastNameController.text);
                    // log(formKey.currentState!.validate().toString(),
                    // name: "laksjdf");
                    if (widget.formKey.currentState?.validate() ?? false) {
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
                      registerRider.model.plateInfo =
                          plateNumberController.text;
                      registerRider.registerOne();
                    }
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
