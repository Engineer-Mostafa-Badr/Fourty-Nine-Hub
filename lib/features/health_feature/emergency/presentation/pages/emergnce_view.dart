import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/first_name_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/emergency/presentation/cubit/emergency_cubit.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
            showSuccessMessage(context, 'Doctors will call you now');
            break;

          default:
            break;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Emergency'),
        ),
        body: Form(
          key:context.read<HealthEmergencyCubit>().formKey,
          child: ListView(
            padding: const EdgeInsets.all(15.0),
            children: [
              const Sizer(height: 30),
              FirstNameTextFormField(
                currentFocusNode: emergencyCubit.firstNameFocusNode,
                currentController: emergencyCubit.firstNameController,
                nextFocusNode: emergencyCubit.phoneFocusNode,
              ),
              const Sizer(height: 30),
              PhoneTextFormField(
                currentFocusNode: emergencyCubit.phoneFocusNode,
                nextFocusNode: emergencyCubit.locationFocusNode,
                currentController: emergencyCubit.phoneController,
                onInputChanged: (value) {},
              ),
              const Sizer(height: 30),
              BlocBuilder<HealthEmergencyCubit, HealthEmergencyState>(
                buildWhen: (previous, current) => current is HealthEmergencySubCategoriesLoaded || current is HealthEmergencyInitial,
                builder: (context, state) {
                  if (state is HealthEmergencySubCategoriesLoaded) {
                    return DropdownMenu<SubCategoryEntity>(
                        width: MediaQuery.of(context).size.width * 0.9,
                        hintText: "Spiciality",
                        dropdownMenuEntries: state.subCategories
                            .map((e) => DropdownMenuEntry<SubCategoryEntity>(
                                value: e, label: e.name))
                            .toList(),
                        onSelected: (value) {
                          if (value != null) {
                            emergencyCubit.selectSubcategory(value);
                          }
                        });
                  } else {
                    return Text("can't select spiciality",
                        style: Styles.headerText());
                  }
                },
              ),
              const Sizer(height: 30),
              DefaultTextFormField(
                  currentFocusNode: emergencyCubit.locationFocusNode,
                  currentController: emergencyCubit.locationController,
                  isRequired: true,
                  hint: 'Address'),
              const Sizer(height: 30),
              ElevatedAppButton(
                label: 'Confirm',
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
