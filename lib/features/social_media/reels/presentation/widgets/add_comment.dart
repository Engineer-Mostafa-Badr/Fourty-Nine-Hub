import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';

class AddComment extends StatelessWidget {
  const AddComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          const ProfileImage(accountId: 0),
          const Sizer(),
          Expanded(
              child: FormTextField(
                  hint: 'Type your comment ....',
                  height: kToolbarHeight * .7,
                  action: (v) {}))
        ],
      ),
    );
  }
}
