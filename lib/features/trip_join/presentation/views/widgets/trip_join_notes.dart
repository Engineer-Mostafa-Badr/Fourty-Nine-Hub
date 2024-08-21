import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
          style: Styles.headerText(),
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
