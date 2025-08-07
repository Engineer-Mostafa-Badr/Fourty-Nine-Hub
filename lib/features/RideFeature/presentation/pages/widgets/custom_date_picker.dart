import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../res/style/app_colors.dart';
import 'custom_pickup_container.dart';

import 'package:flutter_date_pickers/flutter_date_pickers.dart'; // بدون alias

import 'package:intl/intl.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';


class CustomDatePickerButton extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;

  const CustomDatePickerButton({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryTextColor = isDark ? Colors.white : Colors.black;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;

    DateTime pickedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.PRIMARY_COLOR,
                          onPrimary: Colors.white,
                          onSurface: primaryTextColor,
                        ),
                        textTheme: Theme.of(context).textTheme.apply(
                          bodyColor: primaryTextColor,
                          displayColor: primaryTextColor,
                        ),
                        canvasColor: backgroundColor,
                      ),
                      child:

                      Localizations.override(
                        context: context,
                        locale: context.isArabic ? const Locale('ar', 'EG') : const Locale('en', 'US'),
                        child: DayPicker.single(
                          selectedDate: pickedDate,
                          onChanged: (date) {
                            setState(() => pickedDate = date);
                          },
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          datePickerStyles: DatePickerRangeStyles(
                            selectedDateStyle: const TextStyle(color: Colors.white),
                            selectedSingleDateDecoration: BoxDecoration(
                              color: AppColors.PRIMARY_COLOR,
                              shape: BoxShape.circle,
                            ),
                            disabledDateStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            dayHeaderStyle: DayHeaderStyle(
                              textStyle: TextStyle(color: primaryTextColor),
                            ),
                          ),
                        ),
                      )
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            radius: 15,
                            height: 38,
                            backColor: AppColors.PRIMARY_COLOR,
                            onPressed: () {
      ManageVibration.vibrate();
                              // Determine locale based on app language
                              final locale = context.isArabic
                                  ? const Locale('ar', 'EG')
                                  : const Locale('en', 'US');

                              final formatter =
                              DateFormat('dd/MM/yyyy', locale.toString());
                              final newDateStr = formatter.format(pickedDate);

                              onDateSelected(newDateStr);
                              Navigator.pop(context);
                            },
                            label: LocaleKeys.confirm.localize,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            radius: 15,
                            height: 38,
                            backColor: AppColors.LIGHT_COLOR,
                            onPressed: () {
      ManageVibration.vibrate();
                              Navigator.pop(context);
                            },
                            label: LocaleKeys.cancel.localize,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayDate = selectedDate.isEmpty
        ? LocaleKeys.pickupDate.localize
        : selectedDate;

    return GestureDetector(
      onTap: () => _showCustomDatePicker(context),
      child: PickUpContainer(
        fontWeight: FontWeight.w400,
        title: displayDate,
      ),
    );
  }
}




class CustomDatePickerButtonNonSocket extends StatelessWidget {
  final String selectedDate;
  final Function(String) onDateSelected;
  final IconData icon;

  const CustomDatePickerButtonNonSocket({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.icon,
  });

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color primaryTextColor = isDark ? Colors.white : Colors.black;
    final Color backgroundColor = isDark ? Colors.black : Colors.white;

    DateTime pickedDate = DateTime.now();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: backgroundColor,
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(
                          primary: AppColors.PRIMARY_COLOR,
                          onPrimary: Colors.white,
                          onSurface: primaryTextColor,
                        ),
                        textTheme: Theme.of(context).textTheme.apply(
                          bodyColor: primaryTextColor,
                          displayColor: primaryTextColor,
                        ),
                        canvasColor: backgroundColor,
                      ),
                      child: DayPicker.single(
                        selectedDate: pickedDate,
                        onChanged: (date) {
                          setState(() {
                            pickedDate = date;
                          });
                        },
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        datePickerStyles: DatePickerRangeStyles(
                          selectedDateStyle: const TextStyle(color: Colors.white),
                          selectedSingleDateDecoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            shape: BoxShape.circle,
                          ),
                          disabledDateStyle: TextStyle(
                            color: Colors.grey.withOpacity(0.4),
                          ),
                          dayHeaderStyle: DayHeaderStyle(
                            textStyle: TextStyle(color: primaryTextColor),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            radius: 15,
                            height: 38,
                            backColor: AppColors.PRIMARY_COLOR,
                            onPressed: () {
      ManageVibration.vibrate();
                              final newDateStr =
                                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                              onDateSelected(newDateStr);
                              Navigator.pop(context);
                            },
                            label: LocaleKeys.confirm.localize,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            radius: 15,
                            height: 38,
                            backColor: AppColors.LIGHT_COLOR,
                            onPressed: () {
      ManageVibration.vibrate();
                              Navigator.pop(context);
                            },
                            label: LocaleKeys.cancel.localize,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: AppColors.PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      

                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String displayDate = selectedDate.isEmpty
        ? LocaleKeys.pickupDate.localize
        : selectedDate;

    return GestureDetector(
      onTap: () => _showCustomDatePicker(context),
      child: PickUpContainerNonSocket(
        fontWeight: FontWeight.w400,
        title: displayDate,
        icon: icon,
      ),
    );
  }
}