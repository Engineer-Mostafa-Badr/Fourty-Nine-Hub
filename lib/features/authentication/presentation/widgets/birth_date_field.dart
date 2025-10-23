import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:intl/intl.dart';

import '../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:bottom_picker/bottom_picker.dart';

class BirthDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final Function(String? date) onDateChanged;
  const BirthDatePicker({super.key, required this.controller,required this.onDateChanged});

  @override
  _BirthDatePickerState createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  DateTime? selectedDate;
  final DateFormat dateFormat =
      DateFormat('dd/MM/yyyy'); // Formatting as 05/04/2001

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DefaultTextFormField(
          readOnly: true,
          borderColor: Colors.black,
          currentController: widget.controller,
          hint: LocaleKeys.birthDate.localize,
          prefixIcon: const Icon(Icons.calendar_today,size: 22,),
          onTap: () => _selectDate(context),
          validator: (s) {
            return null;
          },
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    BottomPicker.date(
      headerBuilder: (context) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              context.isArabic?'تحديد تاريخ الميلاد':'Set your Birthday',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
              ),
            ),
          ],
        );
      },
      buttonSingleColor: AppColors.PRIMARY_COLOR,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      buttonContent: Text(
        context.isArabic?'تحديد':'Select',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: AppColors.whiteColor,
        ),
      ),
      initialDateTime: DateTime(1996, 10, 22),
      maxDateTime: DateTime(2012),
      minDateTime: DateTime(1980),
      onChange: (index) {
        debugPrint("onChange $index");
      },
      pickerThemeData: CupertinoTextThemeData(
        primaryColor: AppColors.PRIMARY_COLOR,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
        ),
        dateTimePickerTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: context.isDarkMode?AppColors.whiteColor:AppColors.PRIMARY_COLOR,
        )
      ) ,
      onSubmit: (index) {
        debugPrint("onSubmit $index");
        debugPrint("onSubmit ${DateFormat('dd/MM/yyyy', context.isArabic?'ar':'en').format(index)}");
        widget.onDateChanged(index?.toIso8601String());
        String formattedDate = DateFormat('dd/MM/yyyy', context.isArabic?'ar':'en').format(index);
        widget.controller.text =formattedDate;
        // widget.controller.text = dateFormat.format(index);
        debugPrint("widget.controller.text${widget.controller.text}");
      },
      onDismiss: (p0) {
        debugPrint('onDismiss $p0');
      },
      // bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }
}
