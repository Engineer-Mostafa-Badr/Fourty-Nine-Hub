import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/phone_number_text_field.dart';
import 'package:fourtyninehub/core/enums/gender_type.dart';
import 'package:fourtyninehub/core/utils/validator.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookDoctorAppointmentPatientInfoCard extends StatelessWidget {
  const BookDoctorAppointmentPatientInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<BookDoctorAppointmentCubit>();

    return BookDoctorAppointmentCardInfo(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.GREY_BORDER_COLOR),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                serviceLocator<UserCubit>().state.data?.fullName ?? '',
                style: Styles.mediumText(),
              ),
            ),
            const Sizer(),
            Text(Labels.gender, style: Styles.headerText()),
            const _GenderSelector(),
            const Sizer(),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  CustomPhoneTextFormField(
                    currentFocusNode: controller.phoneFousNode,
                    currentController: controller.phoneNumberTextController,
                    onInputChanged: (value) {},
                    nextFocusNode: null,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                      currentFocusNode: controller.ageFocusNode,
                      currentController: controller.ageController,
                      keyboardType: TextInputType.number,
                      hint: Labels.age),
                  const Sizer(),
                  DefaultTextFormField(
                      currentFocusNode: controller.notesFocusNode,
                      currentController: controller.notesController,
                      keyboardType: TextInputType.text,
                      validator: (value) =>
                          Validator().shouldNotContainNumbers(value),
                      hint: Labels.notes),
                ],
              ),
            ),
          ],
        ),
        icon: Icons.person,
        height: kToolbarHeight * 5);
  }
}

class _GenderSelector extends StatefulWidget {
  const _GenderSelector();

  @override
  State<_GenderSelector> createState() => __GenderSelectorState();
}

class __GenderSelectorState extends State<_GenderSelector> {
  GenderType _selectedGender = GenderType.Male;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: RadioListTile<GenderType>(
            title: Text(Labels.male, style: Styles.mediumText()),
            value: GenderType.Male,
            groupValue: _selectedGender,
            onChanged: (value) {
              if (value != null) {
                context.read<BookDoctorAppointmentCubit>().selectGender(value);
                setState(() {
                  _selectedGender = value;
                });
              }
            },
          ),
        ),
        Expanded(
          child: RadioListTile<GenderType>(
            title: Text(Labels.female, style: Styles.mediumText()),
            value: GenderType.Female,
            groupValue: _selectedGender,
            onChanged: (value) {
              if (value != null) {
                context.read<BookDoctorAppointmentCubit>().selectGender(value);

                setState(() {
                  _selectedGender = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
