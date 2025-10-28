import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/address_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/create_doctor_phone_number_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/create_doctor_waiting_time_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/description_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/email_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/location_fields.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/fields/name_filed.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/cities_dropdowns.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/location/governorate_dropdown.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/options_checkbox.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/date/license_expiry_date_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/doctor_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/id_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/pickers/photo/license_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/subcategory.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/submit_button.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/call_time_table.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/clinic_time_table.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/home_visit_time_table.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorViewBody extends StatefulWidget {
  const CreateDoctorViewBody({
    super.key,
  });

  @override
  State<CreateDoctorViewBody> createState() => _CreateDoctorViewBodyState();
}

class _CreateDoctorViewBodyState extends State<CreateDoctorViewBody> {
  final FocusNode nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
        key: context.read<CreateDoctorCubit>().formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Label(
              text: LocaleKeys.welcomeToDoctorRegistration.localize,
              style: Styles.headerText(
                fontWeight: FontWeight.bold,
                color: AppColors.getRedColor(context),
                height: 1.60,
              ),
            ),
            // Label(
            //     text: LocaleKeys.doctor.localize,
            //     style: Styles.headerText(color: AppColors.SECONDARY_COLOR)),
            const SizedBox(height: 16),
            const CreateDoctorSubcategoryDropdown(),
            const SizedBox(height: 8),
            const CreateDoctorOptionsCheckbox(),
            const SizedBox(height: 8),
            CreateDoctorNameField(
              focusNode: nameFocusNode,
            ),
            const SizedBox(height: 8),
            const CreateDoctorPhoneNumberField(),
            const SizedBox(height: 8),
            const CreateDoctorEmailField(),
            const SizedBox(height: 8),
            const CreateDoctorProfilePhotoPicker(),
            const SizedBox(height: 8),
            const CreateDoctorIDPhotoPicker(),
            const SizedBox(height: 8),
            CreateDoctorIDExpiryDatePicker(
              onDateSelected: (date) {
                context.read<CreateDoctorCubit>().pickIDExpiryDateNew(date!);
              },
            ),
            const SizedBox(height: 8),
            const CreateDoctorLicensePhotoPicker(),
            const SizedBox(height: 8),
            const CreateDoctorLicenseExpiryDatePicker(),
            const SizedBox(height: 8),
            const CreateDoctorDescriptionField(),
            const SizedBox(height: 8),
            CreateDoctorGovernorateDropdown(
              onSelected: (value) {
                if (value != null) {
                  context.read<CreateDoctorCubit>().selectGovernorate(value);
                }
              },
            ),
            const SizedBox(height: 8),
            const CreateDoctorCitiesDropdowns(),
            const SizedBox(height: 8),
            const CreateDoctorAddressField(),
            const SizedBox(height: 8),
            const CreateDoctorLocationFields(),
            const SizedBox(height: 8),
            const CreateDoctorWaitingTimeField(),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       "${LocaleKeys.waitingTime.localize}:",
            //       style: Styles.mediumText(),
            //     ),
            //     DefaultTextFormField(
            //       hint: '${LocaleKeys.waitingTime.localize}*',
            //       keyboardType: TextInputType.number,
            //       isRequired: true,
            //       currentFocusNode:
            //           context.read<CreateDoctorCubit>().waitingTimeFocusNode,
            //       currentController:
            //           context.read<CreateDoctorCubit>().waitingTimeController,
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 8,
            ),
            const CreateDoctorClinicTimeTable(),
            const SizedBox(height: 8),
            const CreateDoctorCallTimeTable(),
            const SizedBox(height: 8),
            const CreateDoctorHomeVisitTimeTable(),
            const SizedBox(height: 8),
            AppInfoText(
                text: context.isArabic
                    ? "التطبيق لا يخصم اي نسبه من مزود الخدمة."
                    : "The application does not deduct any percentage from the service provider."),
            SizedBox(height: 20.h),
            AppInfoText(
                text: context.isArabic
                    ? 'سوف تحصل على 3650 جنيها في السنه عندما تشترك يوميا.'
                        .toArabicNumbers(context)
                    : 'You will get EGP 3,650 per year if you subscribe daily.'),
            SizedBox(height: 20.h),
            const CreateDoctorSubmitButton(),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
