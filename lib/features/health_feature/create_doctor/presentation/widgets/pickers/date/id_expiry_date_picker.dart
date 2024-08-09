import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';

class CreateDoctorIDExpiryDatePicker extends StatelessWidget {
  const CreateDoctorIDExpiryDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return DatePickerWidget(
      title: "ID Expiry Date",
      initialDate: now,
      minDate: now,
      maxDate: DateTime(now.year + 5, now.month, now.day),
      onDateSelected: (date) {
        if (date != null) {
          context.read<CreateDoctorCubit>().pickIDExpiryDate(date);
        }
      },
    );
  }
}
