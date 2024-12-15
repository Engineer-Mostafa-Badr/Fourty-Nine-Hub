import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
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
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';

class CreateDoctorView extends StatelessWidget {
  const CreateDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateDoctorCubit, CreateDoctorState>(
      listener: (context, state) {
        switch (state) {
          case CreateDoctorLoading _:
            showLoadingDialog(context);
            break;
          case CreateDoctorCloseLoading _:
            Navigator.pop(context);
            break;
          case CreateDoctorError _:
            showErrorMessage(context, state.message);
            break;
          case CreateDoctorSuccess _:
            showSuccessMessage(context, state.message);
            break;
          default:
            break;
        }
      },
      child: Scaffold(
        appBar: const HomeAppbar(),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: context.read<CreateDoctorCubit>().formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: LocaleKeys.doctor.localize,
                    style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
                Sizer(height: 20.h),
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
                    context.read<CreateDoctorCubit>().pickIDExpiryDate(date!);
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
                          .read<CreateDoctorCubit>()
                          .selectGovernorate(value);
                    }
                  },
                ),
                Sizer(height: 20.h),
                const CreateDoctorCitiesDropdowns(),
                Sizer(height: 20.h),
                const CreateDoctorAddressField(),
                Sizer(height: 20.h),
                const Sizer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${LocaleKeys.waitingTime.localize}:", style: Styles.mediumText(),),
                    DefaultTextFormField(
                      hint: LocaleKeys.waitingTime.localize,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                      currentFocusNode: context.read<CreateDoctorCubit>().waitingTimeFocusNode,
                      currentController: context.read<CreateDoctorCubit>().waitingTimeController,
                    ),
                  ],
                ),
                const Sizer(),
                const CreateDoctorClinicTimeTable(),
                Sizer(height: 20.h),
                const CreateDoctorCallTimeTable(),
                Sizer(height: 20.h),
                const CreateDoctorHomeVisitTimeTable(),
                Sizer(height: 20.h),
                AppInfoText(
                    text:
                        context.isArabic?"التطبيق لا يخصم اي نسبه من مزود الخدمة.":"The application does not deduct any percentage from the service provider."),
                Sizer(height: 20.h),
                AppInfoText(
                    text:
                        context.isArabic?'سوف تحصل على 3650 جنيها في السنه عندما تشترك يوميا.':'You will get EGP 3,650 per year if you subscribe daily.'),
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
