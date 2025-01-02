import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/pick_driver_image_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/profile_image_info_ride_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/features/shipping/create_shipping_request/presentation/cubit/shipping_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UserInfoShippingRegisterWidget extends StatefulWidget {
  const UserInfoShippingRegisterWidget({super.key});

  @override
  State<UserInfoShippingRegisterWidget> createState() =>
      _UserInfoShippingRegisterWidgetState();
}

class _UserInfoShippingRegisterWidgetState
    extends State<UserInfoShippingRegisterWidget> {
  DateTime? birthDate;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var shippingRegisterCubit = context.read<ShippingCubit>();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.isDarkMode?AppColors.UNSELECTED_DARK_GRAY_COLOR: Colors.white,
          boxShadow: context.isDarkMode?[]: [BoxShadow(color: Colors.grey.shade400, blurRadius: 30)]
          ),
      child: Column(
        children: [
          FormField(
            validator: (value) {
                    if (shippingRegisterCubit.model.driverImage == null) {
                      return context.isArabic
                          ? "يرجى إضافة صورة"
                          : "Please add an image";
                    }
                  },
            builder: (field) {
              return Column(
                children: [
                  Column(
                    children: [
                      BlocBuilder<PickDriverImageCubit, RiderState>(
            builder: (context, state) {
              if (state is SuccessPickDriverImageState) {
                return Column(
                      children: [
                        Container(
                            width: 90,
                            height: 90,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                      shippingRegisterCubit.model.driverImage!),
                                  fit: BoxFit.cover,
                                ),
                                color: AppColors.PRIMARY_COLOR,
                                shape: BoxShape.circle),
                            child: shippingRegisterCubit.model.driverImage == null
                                ? Image.asset(
                                    Assets.avatarRemovebackground,
                                    color: Colors.white,
                                  )
                                : null),
                        if (field.hasError)
                          ValidationErrorWidget(
                            message: field.errorText??"",
                          )
                      ],
                    );
              } else {
                return Container(
                    width: 90,
                    height: 90,
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: AppColors.PRIMARY_COLOR, shape: BoxShape.circle),
                    child: Image.asset(
                      Assets.avatarRemovebackground,
                      color: Colors.white,
                    ));
              }
            },
          ),
          const Sizer(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileImageInfoRideScreen(),
              ),
            ),
            child: Container(
              width: 130,
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                  child: Text(
                context.isArabic ? "إضافة صورة" : "Add Image",
                style: Styles.mediumText(),
              )),
            ),
          ),
          if(field.hasError)
          ValidationErrorWidget(message: field.errorText??"",)
                    ],
                  )
                ],
              );
            },
          ),
          const Sizer(),
          
          FirstNameTextFormField(
            isAuthentcation: true,
            onChanged: (value) {
              shippingRegisterCubit.model.firstName = value;
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.firstNameIsRequired.tr();
              }
              return null;
            },
            hintColor: AppColors.PRIMARY_COLOR,
            currentController: firstNameController,
          ),
          const Sizer(),
          LastNameTextFormField(
            currentController: lastNameController,
            onChanged: (value) {
              shippingRegisterCubit.model.lastName = value;
            },
            isAuthentcation: true,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.lastNameIsRequired.tr();
              }
              return null;
            },
            hintColor: AppColors.PRIMARY_COLOR,
          ),
          // const Gap(30),
          const Sizer(),
          FormField(
            validator: (value) {
              if (shippingRegisterCubit.model.birthDate == null) {
                return "";
              }
            },
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      var pickedDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1800),
                          lastDate: DateTime.now());
                      if (pickedDate != null) {
                        birthDate = pickedDate;
                        shippingRegisterCubit.model.birthDate = birthDate;
                      }
                      setState(() {});
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: field.hasError
                              ? Border.all(
                                  color: AppColors.SECONDARY_COLOR_DARK)
                              : null,
                          color: context.isDarkMode
                              ? Colors.black12
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Text(
                            birthDate != null
                                ? DateFormat("dd/MM/yyyy").format(birthDate!)
                                : LocaleKeys.birthDate.tr(),
                            style: Styles.mediumText(fontSize: 32),
                          ),
                          const Sizer(
                            width: 5,
                          ),
                          const Icon(Icons.keyboard_arrow_down_sharp)
                        ],
                      ),
                    ),
                  ),
                  if (field.hasError)
                    ValidationErrorWidget(
                      message: context.isArabic
                          ? "تاريخ الميلاد مطلوب"
                          : "Birth date is required",
                    )
                ],
              );
            },
          ),
          const Sizer(),
          DefaultTextFormField(
            onChanged: (value) {
              shippingRegisterCubit.model.phone = value;
            },
            isAuthentcation: true,
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
          const Sizer(),
          // DefaultTextFormField(
          //   isAuthentcation: true,
          //   currentFocusNode: pricingPerKmFocusNode,
          //   nextFocusNode: model,
          //   hint: LocaleKeys.pricingPerKm.tr(),
          //   hintColor: AppColors.PRIMARY_COLOR,
          //   currentController: pricingPerKmController,
          //   validator: (p0) {
          //     if (p0 == null || p0.isEmpty) {
          //       return LocaleKeys.pricingPerKmIsRequired.tr();
          //     }
          //     return null;
          //   },
          // ),
        ],
      ),
    );
  }
}
