import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/widgets/subcategories_dropdown.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

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
            showSuccessMessage(context, Labels.doctorWillCallSoon);
            break;

          default:
            break;
        }
      },
      child: Scaffold(
        appBar: const BackAppBar(
          label: Labels.emergency,
        ),
        body: Form(
          key: context.read<HealthEmergencyCubit>().formKey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              const Sizer(height: 30),
              FirstNameTextFormField(
                hintColor: AppColors.QUANTITY_COLOR,
                currentFocusNode: emergencyCubit.firstNameFocusNode,
                currentController: emergencyCubit.firstNameController,
                nextFocusNode: emergencyCubit.phoneFocusNode,
              ),
              const Sizer(height: 30),
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
              const Sizer(height: 30),
              const HealthEmergencySubCategoriesDropdown(),
              const Sizer(height: 30),
              DefaultTextFormField(
                hintColor: AppColors.QUANTITY_COLOR,
                  currentFocusNode: emergencyCubit.locationFocusNode,
                  currentController: emergencyCubit.locationController,
                  isRequired: true,
                  hint: Labels.address),
              const Sizer(height: 30),
              ElevatedAppButton(
                label: Labels.confirm,
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
