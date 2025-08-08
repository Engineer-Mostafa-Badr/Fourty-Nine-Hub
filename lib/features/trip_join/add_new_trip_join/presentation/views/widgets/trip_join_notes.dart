import 'package:flutter/material.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/default_text_form_field.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class TripJoinNotes extends StatelessWidget {
  const TripJoinNotes({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes',
          style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
        ),
        DefaultTextFormField(
          currentController: TextEditingController(),
          hint: 'Type trip notes',
        ),
        const Sizer(),
      ],
    );
  }
}
