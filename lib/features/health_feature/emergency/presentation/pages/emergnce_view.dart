import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/widgets/subcategories_dropdown.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class HealthEmergencyView extends StatelessWidget {
  const HealthEmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    final emergencyCubit = context.read<HealthEmergencyCubit>();
    return BlocListener<HealthEmergencyCubit, HealthEmergencyState>(
      listener: (context, state) {
        switch (state) {
          case HealthEmergencyError _:
            showErrorMessage(context, state.message);
            break;

          case HealthEmergencySuccess _:
            showSuccessMessage(context, context.isArabic?'تم ارسال طلبك بنجاح, سيتم التواصل معك قريبا':'Your request has been sent successfully, doctor will call you soon.');
            break;

          default:
            break;
        }
      },
      child: Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.emergency.localize,
        ),
        body: Form(
          key: context.read<HealthEmergencyCubit>().formKey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              Sizer(height: 30.h),
              FirstNameTextFormField(
                hintColor: AppColors.QUANTITY_COLOR,
                currentFocusNode: emergencyCubit.firstNameFocusNode,
                currentController: emergencyCubit.firstNameController,
                nextFocusNode: emergencyCubit.phoneFocusNode,
              ),
              Sizer(height: 30.h),
              // PhoneTextFormField(
              //   currentFocusNode: emergencyCubit.phoneFocusNode,
              //   nextFocusNode: emergencyCubit.locationFocusNode,
              //   currentController: emergencyCubit.phoneController,
              //   onInputChanged: (value) {},
              // ),
              CustomPhoneTextFormField(
                currentFocusNode: emergencyCubit.phoneFocusNode,
                nextFocusNode: emergencyCubit.locationFocusNode,
                currentController: emergencyCubit.phoneController,
                onInputChanged: (value) {},
              ),
              Sizer(height: 30.h),
              const HealthEmergencySubCategoriesDropdown(),
              Sizer(height: 30.h),
              DefaultTextFormField(
                hintColor: AppColors.QUANTITY_COLOR,
                currentFocusNode: emergencyCubit.locationFocusNode,
                currentController: emergencyCubit.locationController,
                isRequired: true,
                hint: LocaleKeys.address.localize,
              ),
              Sizer(height: 30.h),
              ElevatedAppButton(
                label: LocaleKeys.confirm.localize,
                onPressed: () {
                  emergencyCubit.bookEmergency();
                },
                backColor: AppColors.SECONDARY_COLOR,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
