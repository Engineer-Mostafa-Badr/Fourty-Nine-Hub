import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';

class OTPTextField extends StatelessWidget {
  final int numberOfFields;
  final Function(String) onSubmitted;
  const OTPTextField(
      {super.key, this.numberOfFields = 6, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      numberOfFields: numberOfFields,
      borderColor: AppColors.PRIMARY_COLOR_DARK,
      clearText: true,
      focusedBorderColor: AppColors.PRIMARY_COLOR,

      showFieldAsBox: true,
      textStyle: Styles.mediumText(),
      onCodeChanged: (String value) {},
      handleControllers: (controllers) {},

      onSubmit: (String verificationCode) =>
          onSubmitted(verificationCode), // end onSubmit
    );
  }
}
