import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/functions/helper/routing_helper.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/dynamic/shared_scaffold.dart';
import '../../../../../common/widgets/stateless/labels/info_text.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../health_feature/shared/domain/entities/governorate_entity.dart';
import '../../../../health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import '../../../../ride/RideRequest/presentation/widgets/Identity_confirmation_card_register_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/behind_car_license_register_card_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/behind_driver_license_card_register_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/car_image_register_card_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/driver_license_card_register_ride_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/expiration_date_driver_license_card_register_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/front_car_license_register_card_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/plate_number_register_card_widget.dart';
import '../../../../ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import '../../data/models/banner_model/sub_category.dart';
import '../cubit/shipping_cubit.dart';
import '../cubit/shipping_state.dart';
import '../widgets/user_info_shipping_register_widget.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../helpers/manage_vibration.dart';

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
  String? selectCity;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ShippingCubit>().getBannerData();
  }

  @override
  Widget build(BuildContext context) {
    context.read<HealthCubit>().getGovernorates();
    final shippingcubit = context.read<ShippingCubit>();
    return SharedScaffold(
      mainCategoryId: 1,
      body: BlocConsumer<ShippingCubit, ShippingState>(
        listener: (context, state) {
          if (state is SuccessRegisterState) {
            context.pushAndRemoveUntil(
              Routes.RIDE,
              (route) => false,
            );
            showSuccessMessage(context, state.message);
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
                child: CustomCircularProgressIndicator(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      LocaleKeys.welcomeToShipRegister.tr(),
                      style: Styles.headerText(
                        fontSize: 40,
                        color: AppColors.PRIMARY_COLOR_DARK,
                      ),
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
                                    message: LocaleKeys
                                        .chooseYourFavoriteSubCategory
                                        .tr(),
                                    condition:
                                        shippingcubit.model.subCategoryId ==
                                            null,
                                  );
                                },
                                builder: (field) {
                                  return Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: context.isDarkMode
                                            ? AppColors
                                                .UNSELECTED_DARK_GRAY_COLOR
                                            : Colors.white,
                                        boxShadow: context.isDarkMode
                                            ? []
                                            : [
                                                BoxShadow(
                                                    color: Colors.grey.shade400,
                                                    blurRadius: 30)
                                              ]),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...List.generate(
                                          state.model.subCategories?.length ??
                                              0,
                                          (index) {
                                            return SubCategoryShippingCard(
                                              onChanged: () {
                                                setState(() {});
                                              },
                                              isSelect: shippingcubit
                                                      .model.subCategoryId ==
                                                  state
                                                      .model
                                                      .subCategories![index]
                                                      .subCategoryId,
                                              model: state
                                                  .model.subCategories![index],
                                            );
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
                                    ),
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
                  const Sizer(
                    height: 30,
                  ),
                  const UserInfoShippingRegisterWidget(),
                  const Sizer(
                    height: 30,
                  ),
                  DriverLicenseCardRegisterRideWidget(
                    title: context.isArabic
                        ? "رقم رخصة السائق"
                        : "Driver's License Number",
                    onChanged: (value) {
                      shippingcubit.model.driverLicenseNumber = value;
                      // shippingCubit.model.driverLicenseNumber = value;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  BehindDriverLicenseCardRegisterWidget(
                    title: context.isArabic
                        ? "الجانب الامامي من رخصة السائق"
                        : "Front side of driver's license",
                    onTap: (image) {
                      shippingcubit.model.drivingImageInFront = image;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  BehindDriverLicenseCardRegisterWidget(
                    title: context.isArabic
                        ? "الجانب الخلفي من رخصة السائق"
                        : "Back side of driver's license",
                    onTap: (image) {
                      shippingcubit.model.drivingImageBehind = image;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  //
                  ExpirationDateDriverLicenseCardRegisterWidget(
                    onTap: (date) {
                      shippingcubit.model.drivingExpiryDate = date;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  //
                  BehindDriverLicenseCardRegisterWidget(
                      onTap: (image) {
                        shippingcubit.model.idImageInFront = image;
                      },
                      title: context.isArabic
                          ? "البطاقة الشخصية (الجزاء الامامي)"
                          : "ID card (front part)"),
                  const Sizer(
                    height: 30,
                  ),
                  BehindDriverLicenseCardRegisterWidget(
                      onTap: (image) {
                        shippingcubit.model.idImageInFront = image;
                      },
                      title: context.isArabic
                          ? "البطاقة الشخصية (الجزاء الخلفي)"
                          : "ID card (back part)"),
                  const Sizer(
                    height: 30,
                  ),
                  DriverLicenseCardRegisterRideWidget(
                    title:
                        context.isArabic ? "رقم البطاقة الشخصية" : "ID number",
                    onChanged: (value) {
                      shippingcubit.model.idNumber = value;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  ExpirationDateDriverLicenseCardRegisterWidget(
                    onTap: (date) {
                      shippingcubit.model.idExpiryDate = date;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  IdentityConfirmationCardRegisterWidget(
                    onChange: (image) {},
                  ),

                  const Sizer(
                    height: 30,
                  ),
                  const PlateNumberRegisterCardWidget(),
                  const Sizer(
                    height: 30,
                  ),
                  const FrontCarLicenseRegisterCardWidget(),
                  const Sizer(
                    height: 30,
                  ),
                  const BehindCarLicenseRegisterCardWidget(),
                  const Sizer(
                    height: 30,
                  ),
                  const CarImageRegisterCardWidget(),
                  const Sizer(
                    height: 30,
                  ),
                  DriverLicenseCardRegisterRideWidget(
                    title: context.isArabic ? "موديل السيارة" : "Car Model",
                    onChanged: (value) {
                      shippingcubit.model.model = value;
                    },
                  ),
                  const Sizer(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: context.isDarkMode
                            ? AppColors.UNSELECTED_DARK_GRAY_COLOR
                            : Colors.white,
                        boxShadow: context.isDarkMode
                            ? []
                            : [
                                BoxShadow(
                                    color: Colors.grey.shade400, blurRadius: 30)
                              ]),
                    child: Column(
                      children: [
                        Text(
                          context.isArabic
                              ? "يرجى اختيار المدينة"
                              : "Please select a city",
                          style: Styles.headerText(
                              fontWeight: FontWeight.w500, fontSize: 40),
                        ),
                        const Sizer(),
                        BlocBuilder<HealthCubit, HealthState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Align(
                                child: CustomCircularProgressIndicator(
                                  color: AppColors.PRIMARY_COLOR,
                                ),
                              );
                            }
                            return FormField(
                              validator: (value) {
                                if (selectCity == null) {
                                  return context.isArabic
                                      ? "يرجى اختيار المدينة"
                                      : "Please select a city";
                                }
                                return null;
                              },
                              builder: (field) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          border: field.hasError
                                              ? Border.all(
                                                  color: AppColors
                                                      .SECONDARY_COLOR_DARK)
                                              : null,
                                          color: context.isDarkMode
                                              ? Colors.black12
                                              : Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: DropdownButton<
                                                GovernorateEntity>(
                                              underline: Container(),
                                              icon: Container(),
                                              hint: Text((selectCity) ??
                                                  (context.isArabic
                                                      ? "المدينة المفضلة"
                                                      : "Favorite city")),
                                              items: state.governorates!
                                                  .map(
                                                    (e) => DropdownMenuItem<
                                                        GovernorateEntity>(
                                                      value: e,
                                                      child: Text(
                                                          (context.isArabic
                                                                  ? e.nameAr
                                                                  : e.nameEn) ??
                                                              ""),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (value) {
                                                shippingcubit.model.location =
                                                    value?.nameAr ?? "";
                                                selectCity = (context.isArabic
                                                        ? value?.nameAr
                                                        : value?.nameEn) ??
                                                    "";

                                                setState(() {});
                                              },
                                              dropdownColor: context.isDarkMode
                                                  ? AppColors.DARK_BLUE_COLOR
                                                  : Colors.white,
                                            ),
                                          ),
                                          const Icon(Icons
                                              .keyboard_arrow_down_outlined)
                                        ],
                                      ),
                                    ),
                                    if (field.hasError)
                                      ValidationErrorWidget(
                                          message: field.errorText ?? "")
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        AppInfoText(
                          text: LocaleKeys
                              .theApplicationDoesNotDeductAnyPercentage
                              .tr(),
                        ),
                        // const Gap(30),
                        const SizedBox(
                          height: 10,
                        ),
                        AppInfoText(
                          text: LocaleKeys.youWillGetPoundsAnnually.tr(),
                        ),
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
                              ManageVibration.vibrate();
                              if (formKey.currentState!.validate()) {
                                context.read<ShippingCubit>().register();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
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
        ManageVibration.vibrate();
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

class SubCategoryShippingCard extends StatefulWidget {
  const SubCategoryShippingCard(
      {super.key,
      required this.model,
      required this.isSelect,
      required this.onChanged});
  final SubCategory model;
  final bool isSelect;
  final void Function() onChanged;
  @override
  State<SubCategoryShippingCard> createState() =>
      _SubCategoryShippingCardState();
}

class _SubCategoryShippingCardState extends State<SubCategoryShippingCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(widget.model.picture ?? ""))),
          ),
          const Sizer(),
          Text((context.isArabic
                  ? widget.model.subCategoryNameAr
                  : widget.model.subCategoryNameEn) ??
              ""),
          const Spacer(),
          Checkbox(
            value: widget.isSelect,
            onChanged: (value) {
              widget.onChanged();
              context.read<ShippingCubit>().selectSubCategory(
                  subCategory: widget.model.subCategoryId ?? "");
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
