import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:go_router/go_router.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Contact Us',
      ),
      bottomNavigationBar: AppButton(label: 'Send',
      margin: 10,
       onPressed: ()=> context.pop()),
       body: Padding(
         padding: const EdgeInsets.all(8.0),
         child: ListView(
          children: const[
            Label(text: UIConst.placeholderText),
             Sizer(),
            FormTextField(
              label: 'Phone (Optional)',
              required: false,
            ),
             Sizer(),
            FormTextField(
              hint: 'Message',
              maxLines: 3,
            ),
          ],
         ),
       ),

    );
  }
}
