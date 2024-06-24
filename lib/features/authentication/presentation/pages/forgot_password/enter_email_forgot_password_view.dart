import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/default_button.dart';

class EnterEmailForgotPasswordView extends StatelessWidget {
  const EnterEmailForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: 'Forgot Password',
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              FormTextField(
                label: 'E-mail',
                hint: 'Type here',
                prefix: const Icon(Icons.person),
                action: (v) {},
              ),
              const Sizer(),
              DefaultButton(
                label: 'Send OTP',
                onPressed: () async{},
              ),
            ],
          ),
        ));
  }
}
