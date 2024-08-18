import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

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
              suffixIcon: const Icon(
                Icons.check,
                color: AppColors.CHECK_MARK_COLOR,
                size: 30,
              ),
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
