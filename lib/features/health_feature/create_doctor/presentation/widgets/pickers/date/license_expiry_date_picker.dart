import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/date_picker.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CreateDoctorLicenseExpiryDatePicker extends StatelessWidget {
  const CreateDoctorLicenseExpiryDatePicker({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return DatePickerField(
      title: LocaleKeys.licenseExpiryDate.localize,
      backgroundColor: AppColors.getFindFillColor(context),
      borderColor: AppColors.getFindFillColor(context),
      textStyle: Styles.mediumText(
        fontSize: 32,
        height: 1.60,
      ),
      icon: SvgPicture.asset(
        Assets.calendarIcon,
        color: context.isDarkMode ? AppColors.getTextColor(context) : null,
      ),
      initialDate: now,
      minDate: now,
      maxDate: DateTime(now.year + 5, now.month, now.day),
      onDateSelected: (date) {
        if (date != null) {
          context.read<CreateDoctorCubit>().pickPracticingExpiryDateNew(date);
        }
      },
    );
  }
}
