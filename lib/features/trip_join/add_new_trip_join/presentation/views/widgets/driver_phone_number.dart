import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DriverPhoneNumber extends StatelessWidget {
  const DriverPhoneNumber({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
        ),
        DefaultTextFormField(
          currentController: TextEditingController(),
          hint: '0123456789',
          keyboardType: TextInputType.phone,
        ),
        Sizer(),
      ],
    );
  }
}
