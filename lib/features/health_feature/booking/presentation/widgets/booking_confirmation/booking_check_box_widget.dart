import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class BookingCheckBoxWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final Color? borderColor; // for inactive checkbox

  const BookingCheckBoxWidget({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: borderColor ?? Colors.grey, // border color when unchecked
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return activeColor ?? Theme.of(context).primaryColor;
            }
            return borderColor ?? Colors.grey;
          }),
          checkColor: WidgetStateProperty.all(
              checkColor ?? Colors.white), // checkmark color
        ),
      ),
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 8.w),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
            Expanded(
              child: Text(
                'I am booking on behalf of another patient',
                style:Styles.mediumText(
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
