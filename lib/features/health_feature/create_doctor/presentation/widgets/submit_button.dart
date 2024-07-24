import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';

class CreateDoctorSubmitButton extends StatelessWidget {
  const CreateDoctorSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: ElevatedAppButton(onPressed: () {}, label: 'Submit')),
      ],
    );
  }
}
