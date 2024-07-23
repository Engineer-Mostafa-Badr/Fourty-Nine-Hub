import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/subcategory.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/info.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/cities_dropdowns.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/governorate_dropdown.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/submit_button.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/call_time_table.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/clinic_time_table.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/home_visit_time_table.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/id_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/license_expiry_date_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/license_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/name_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/options_checkbox.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/doctor_photo_picker.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';

// ignore: must_be_immutable
class CreateDoctorView extends StatelessWidget {
  List<SubCategoryEntity>? subCategories;
  CreateDoctorView({super.key, this.subCategories});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDoctorCubit, CreateDoctorState>(
      listenWhen: (previous, current) => current is CreateDoctorError,
      listener: (context, state) {
        if (state is CreateDoctorError) {
          showErrorMessage(context, state.message);
        }
      },
      child: Scaffold(
        appBar: const HomeAppbar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: context.read<CreateDoctorCubit>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CreateDoctorSubcategoryDropdown(subCategories: subCategories),
                const Sizer(height: 20),
                CreateDoctorOptionsCheckbox(),
                const Sizer(height: 20),
                const CreateDoctorNameField(),
                const Sizer(height: 20),
                const CreateDoctorProfilePhotoPicker(),
                const Sizer(height: 20),
                const CreateDoctorIDPhotoPicker(),
                const Sizer(height: 20),
                const CreateDoctorIDExpiryDatePicker(),
                const Sizer(height: 20),
                const CreateDoctorLicensePhotoPicker(),
                const Sizer(height: 20),
                const CreateDoctorLicenseExpiryDatePicker(),
                const Sizer(height: 20),
                DefaultTextFormField(
                  hint: 'Specialty',
                  keyboardType: TextInputType.text,
                  isRequired: true,
                  currentFocusNode:
                      context.read<CreateDoctorCubit>().specialtyFocusNode,
                  currentController:
                      context.read<CreateDoctorCubit>().specialtyController,
                ),
                const Sizer(height: 20),
                const CreateDoctorGovernorateDropdown(),
                const Sizer(height: 20),
                const CreateDoctorCitiesDropdowns(),
                const Sizer(height: 20),
                DefaultTextFormField(
                  hint: 'Address',
                  keyboardType: TextInputType.text,
                  isRequired: true,
                  currentFocusNode:
                      context.read<CreateDoctorCubit>().addressFocusNode,
                  currentController:
                      context.read<CreateDoctorCubit>().addressController,
                ),
                const Sizer(height: 20),
                const CreateDoctorClinicTimeTable(),
                const Sizer(height: 20),
                const CreateDoctorCallTimeTable(),
                const Sizer(height: 20),
                const CreateDoctorHomeVisitTimeTable(),
                const Sizer(height: 20),
                const CreateDoctorInfoText(
                    text:
                        "The application does not deduct any percentage from the service provider."),
                const Sizer(height: 20),
                const CreateDoctorInfoText(
                    text:
                        'You will get EGP 3,650 per year if you subscribe daily.'),
                const Sizer(height: 20),
                const CreateDoctorSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
