import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/form/text_fields/new_phone_number_text_field.dart';
import '../widgets/close_widget.dart';
import '../widgets/register_floating_action_button.dart';

class TruckPersonalInformationScreen extends StatelessWidget {
  const TruckPersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController surNameController = TextEditingController();
    TextEditingController dateOfBirthDayController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    return CustomScaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: HomeAppbar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 32,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    closeWidget(
                        context: context,
                        onAcceptSaveData: () {},
                        closeRemoveData: () {}),
                    Label(
                      text: LocaleKeys.personalInformation.localize,
                      style: Styles.headerText(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Sizer(),
                    DefaultTextFormField(
                      currentController: firstNameController,
                      fillColor: context.isDarkMode
                          ? Colors.grey.shade600
                          : AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      hint: LocaleKeys.firstName.localize,
                    ),
                    const Sizer(),
                    DefaultTextFormField(
                      currentController: surNameController,
                      fillColor: context.isDarkMode
                          ? Colors.grey.shade600
                          : AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      hint: LocaleKeys.surname.localize,
                    ),
                    const Sizer(),
                    DefaultTextFormField(
                      currentController: dateOfBirthDayController,
                      fillColor: context.isDarkMode
                          ? Colors.grey.shade600
                          : AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      hint: LocaleKeys.user_info_date_of_birth.localize,
                    ),
                    const Sizer(),
                    NewPhoneNumberTextFormField(
                      currentController: phoneNumberController,
                      fillColor: AppColors.GREYBG,
                      borderColor: Colors.transparent,
                      isRequired: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          RegisterNextRow(
            index: 1,
            onTap: () => context.pushNamed(Routes.truckDriversLicenseScreen),
          ),
        ],
      ),
    );
  }
}
