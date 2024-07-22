import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';

class DoctorLoginSubmitButton extends StatelessWidget {
  const DoctorLoginSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ElevatedAppButton(onPressed: () {}, label: 'Submit')),
      ],
    );
  }
}