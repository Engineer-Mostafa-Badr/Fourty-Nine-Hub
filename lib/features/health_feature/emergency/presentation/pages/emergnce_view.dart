import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/new_phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/widgets/subcategories_dropdown.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/localization/locale_keys.g.dart';

class HealthEmergencyView extends StatefulWidget {
  const HealthEmergencyView({super.key});

  @override
  State<HealthEmergencyView> createState() => _HealthEmergencyViewState();
}

class _HealthEmergencyViewState extends State<HealthEmergencyView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final emergencyCubit = context.read<HealthEmergencyCubit>();
      emergencyCubit.firstNameFocusNode.requestFocus();
    });
  }

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
            showSuccessMessage(
                context,
                context.isArabic
                    ? 'تم ارسال طلبك بنجاح, سيتم التواصل معك قريبا'
                    : 'Your request has been sent successfully, doctor will call you soon.');
            break;

          default:
            break;
        }
      },
      child: SharedScaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(30),
        //   child: AppBar(
        //     label: LocaleKeys.emergency.localize,
        //   ),
        // ),
        mainCategoryId: 1,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: context.read<HealthEmergencyCubit>().formKey,
            child: Column(
              // padding: const EdgeInsets.all(15.0),
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.h,
              children: [
                const SizedBox(height: 4),
                Label(
                  text: LocaleKeys.emergency.localize,
                  style: Styles.headerText(
                    fontSize: 36,
                  ),
                ),
                // Sizer(height: 30.h),
                DefaultTextFormField(
                  // hintColor: AppColors.QUANTITY_COLOR,
                  hint: LocaleKeys.firstName.localize,
                  currentFocusNode: emergencyCubit.firstNameFocusNode,
                  currentController: emergencyCubit.firstNameController,
                  nextFocusNode: emergencyCubit.phoneFocusNode,
                ),
                // Sizer(height: 30.h),
                // PhoneTextFormField(
                //   currentFocusNode: emergencyCubit.phoneFocusNode,
                //   nextFocusNode: emergencyCubit.locationFocusNode,
                //   currentController: emergencyCubit.phoneController,
                //   onInputChanged: (value) {},
                // ),
                NewPhoneNumberTextFormField(
                  currentController: emergencyCubit.phoneController,
                  currentFocusNode: emergencyCubit.phoneFocusNode,
                  nextFocusNode: emergencyCubit.locationFocusNode,
                  isRequired: true,
                ),
                // CustomPhoneTextFormField(
                //   currentFocusNode: emergencyCubit.phoneFocusNode,
                //   nextFocusNode: emergencyCubit.locationFocusNode,
                //   currentController: emergencyCubit.phoneController,
                //   onInputChanged: (value) {},
                // ),
                // Sizer(height: 30.h),
                const HealthEmergencySubCategoriesDropdown(),
                // Sizer(height: 30.h),
                DefaultTextFormField(
                  hintColor: AppColors.QUANTITY_COLOR,
                  currentFocusNode: emergencyCubit.locationFocusNode,
                  currentController: emergencyCubit.locationController,
                  isRequired: true,
                  hint: LocaleKeys.address.localize,
                ),
                const SizedBox(height: 8),
                AppButton(
                  label: LocaleKeys.confirm.localize,
                  style: Styles.headerText(
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    emergencyCubit.bookEmergency();
                  },
                  backColor: AppColors.SECONDARY_COLOR,
                ),
                // ElevatedAppButton(
                //   label: LocaleKeys.confirm.localize,
                //   onPressed: () {
                //     emergencyCubit.bookEmergency();
                //   },
                //   backColor: AppColors.SECONDARY_COLOR,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
