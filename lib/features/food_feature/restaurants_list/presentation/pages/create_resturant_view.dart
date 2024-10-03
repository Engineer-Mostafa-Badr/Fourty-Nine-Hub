import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/create_resturant_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/address_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/description_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/subcategory.dart';
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
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/name_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/options_checkbox.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/doctor_photo_picker.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';

class CreateResturantView extends StatelessWidget {
  const CreateResturantView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateResturantCubit, CreateResturantState>(
      listener: (context, state) {
        switch (state) {
          case CreateResturantLoading _:
            showLoadingDialog(context);
            break;
          case CreateResturantCloseLoading _:
            Navigator.pop(context);
            break;
          case CreateResturantError _:
            showErrorMessage(context, state.message);
            break;
          case CreateResturantSuccess _:
            showSuccessMessage(context, state.message);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: const HomeAppbar(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: context.read<CreateResturantCubit>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: Labels.welcomRegiesterResturant,
                    style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
                const CreateDoctorSubcategoryDropdown(),
                Sizer(height: 20.h),
                CreateDoctorOptionsCheckbox(),
                Sizer(height: 20.h),
                const CreateDoctorNameField(),
                Sizer(height: 20.h),
                const CreateDoctorProfilePhotoPicker(),
                Sizer(height: 20.h),
                const CreateDoctorIDPhotoPicker(),
                Sizer(height: 20.h),
                CreateDoctorIDExpiryDatePicker(
                  onDateSelected: (date) {
                    context
                        .read<CreateResturantCubit>()
                        .pickIDExpiryDate(date!);
                  },
                ),
                Sizer(height: 20.h),
                const CreateDoctorLicensePhotoPicker(),
                Sizer(height: 20.h),
                const CreateDoctorLicenseExpiryDatePicker(),
                Sizer(height: 20.h),
                const CreateDoctorDescriptionField(),
                Sizer(height: 20.h),
                CreateDoctorGovernorateDropdown(
                  onSelected: (value) {
                    if (value != null) {
                      context
                          .read<CreateResturantCubit>()
                          .selectGovernorate(value);
                    }
                  },
                ),
                Sizer(height: 20.h),
                const CreateDoctorCitiesDropdowns(),
                Sizer(height: 20.h),
                const CreateDoctorAddressField(),
                Sizer(height: 20.h),
                const CreateDoctorClinicTimeTable(),
                Sizer(height: 20.h),
                const CreateDoctorCallTimeTable(),
                Sizer(height: 20.h),
                const CreateDoctorHomeVisitTimeTable(),
                Sizer(height: 20.h),
                const AppInfoText(
                    text:
                        "The application does not deduct any percentage from the service provider."),
                Sizer(height: 20.h),
                const AppInfoText(
                    text:
                        'You will get EGP 3,650 per year if you subscribe daily.'),
                Sizer(height: 20.h),
                const CreateDoctorSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
