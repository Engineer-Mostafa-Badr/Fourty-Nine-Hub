import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/button.dart';

class StartTextFieldAndFindButon extends StatelessWidget {
  const StartTextFieldAndFindButon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          Expanded(
            child: DefaultTextFormField(
              currentController: TextEditingController(),
              hint: 'Find your starting Point..!',
            ),
          ),
          const Sizer(width: 5),
          CustomButton(onTap: () {}),
        ],
      ),
    );
  }
}
