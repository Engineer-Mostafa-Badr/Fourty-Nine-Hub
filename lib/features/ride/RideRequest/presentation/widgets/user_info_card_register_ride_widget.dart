import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/last_name_text_form_field.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UserInfoCardRegisterRideWidget extends StatefulWidget {
  const UserInfoCardRegisterRideWidget({super.key});

  @override
  State<UserInfoCardRegisterRideWidget> createState() => _UserInfoCardRegisterRideWidgetState();
}

class _UserInfoCardRegisterRideWidgetState extends State<UserInfoCardRegisterRideWidget> {
    FocusNode firstNameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode phoneFocusNode = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? birthDate;
  @override
  Widget build(BuildContext context) {
    return Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.shade400, blurRadius: 30)
                  ]
                ),
                child: Column(
                  children: [
                    Container(
                width: 90,
                height: 90,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR, shape: BoxShape.circle),
                child: Image.asset(
                  Assets.avatarRemovebackground,
                  color: Colors.white,
                ),
              ),
              Sizer(),
              Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                    child: Text(
                  "إضافة صورة",
                  style: Styles.mediumText(),
                )),
              ),
              Sizer(),
              FirstNameTextFormField(
                isAuthentcation: true,
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
              Sizer(),
              GestureDetector(
                onTap: () async {
                  var pickedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1800),
                      lastDate: DateTime.now());
                  if (pickedDate != null) {
                    birthDate = pickedDate;
                  }
                  setState(() {
                    
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Text(
                        birthDate != null? DateFormat("dd/MM/yyyy").format(birthDate!): LocaleKeys.birthDate.tr(),
                        style: Styles.mediumText(fontSize: 32),
                      ),
                      Sizer(width: 5,),
                      Icon(Icons.keyboard_arrow_down_sharp)
                    ],
                  ),
                ),
              ),
              Sizer(),
              DefaultTextFormField(
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
              Sizer(),
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