import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorLicenseExpiryDatePicker extends StatelessWidget {
  const CreateDoctorLicenseExpiryDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return DatePickerField(
      title: context.isArabic ? 'تاريخ انتهاء الترخيص' : 'License Expiry Date',
      textStyle: Styles.mediumText(),
      initialDate: now,
      minDate: now,
      maxDate: DateTime(now.year + 5, now.month, now.day),
      onDateSelected: (date) {
        if (date != null) {
          context.read<CreateDoctorCubit>().pickPracticingExpiryDate(date);
        }
      },
    );
  }
}
