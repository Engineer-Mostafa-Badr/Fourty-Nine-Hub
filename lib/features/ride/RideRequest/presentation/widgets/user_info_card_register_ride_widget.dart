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
import 'package:fourtyninehub/features/ride/RideRequest/data/models/driver_ride_model/driver_ride_model.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/pick_driver_image_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/rider_state.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/pages/profile_image_info_ride_screen.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/validation_error_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UserInfoCardRegisterRideWidget extends StatefulWidget {
  const UserInfoCardRegisterRideWidget({super.key, this.model,});
  final DriverRideModel? model;
  @override
  State<UserInfoCardRegisterRideWidget> createState() =>
      _UserInfoCardRegisterRideWidgetState();
}

class _UserInfoCardRegisterRideWidgetState
    extends State<UserInfoCardRegisterRideWidget> {
  FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? birthDate;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model != null) {
      firstNameController.text = widget.model?.driverFirstName ?? "";
      lastNameController.text = widget.model?.driverLastName ?? "";
      birthDate = widget.model?.birthDate??birthDate;
      phoneController.text = widget.model?.phone??"";
    }
  }

  @override
  Widget build(BuildContext context) {
    log(widget.model?.toJson().toString()??"ldf", name: "lksdjflskdjfkddkddd");
    var rideRegisterCubit = context.read<RegisterRiderCubit>();
    log("${rideRegisterCubit.print()}");
    setState(() {});
    return Container(
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
              : [BoxShadow(color: Colors.grey.shade400, blurRadius: 30)]),
      child: Column(
        children: [
          FormField(
            validator: (value) {
              if (rideRegisterCubit.model.driverImage == null) {
                return context.isArabic
                    ? "يرجى إضافة صورة"
                    : "Please add an image";
              }
              return null;
            },
            builder: (field) {
              return Column(
                children: [
                  Column(
                    children: [
                      BlocBuilder<PickDriverImageCubit, RiderState>(
                        builder: (context, state) {
                          if (state is SuccessPickDriverImageState) {
                            // /.model.driverImage = state.image;
                            return Column(
                              children: [
                                Container(
                                    width: 90,
                                    height: 90,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(state.image),
                                          fit: BoxFit.cover,
                                        ),
                                        color: AppColors.PRIMARY_COLOR,
                                        shape: BoxShape.circle),
                                    child: rideRegisterCubit.model.driverImage == null
                                            ? Image.asset(
                                                Assets.avatarRemovebackground,
                                                color: Colors.white,
                                              )
                                            : widget.model?.image != null? Image.file(widget.model!.image!): null),
                                if (field.hasError)
                                  ValidationErrorWidget(
                                    message: field.errorText ?? "",
                                  )
                              ],
                            );
                          } else {
                            return Container(
                                width: 90,
                                height: 90,
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: NetworkImage(widget.model?.driverPictureKey??"")),
                                    color: AppColors.PRIMARY_COLOR,
                                    shape: BoxShape.circle),
                                child: widget.model != null? null: Image.asset(
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
                            builder: (context) =>
                                const ProfileImageInfoRideScreen(),
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
                      if (field.hasError)
                        ValidationErrorWidget(
                          message: field.errorText ?? "",
                        )
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
              rideRegisterCubit.model.driverFirstName = value;
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return LocaleKeys.firstNameIsRequired.tr();
              }
              return null;
            },
            hintColor: AppColors.PRIMARY_COLOR,
            currentFocusNode: firstNameFocusNode,
            nextFocusNode: lastNameFocusNode,
            currentController: firstNameController,
          ),
          const Sizer(),
          LastNameTextFormField(
            onChanged: (value) {
              rideRegisterCubit.model.driverLastName = value;
            },
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
          // const Gap(30),
          const Sizer(),
          FormField(
            validator: (value) {
              if (rideRegisterCubit.model.birthDate == null) {
                return "";
              }
              return null;
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
                        rideRegisterCubit.model.birthDate = birthDate;
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
              rideRegisterCubit.model.phone = value;
            },
            isAuthentcation: true,
            currentFocusNode: phoneFocusNode,
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
        ],
      ),
    );
  }
}
