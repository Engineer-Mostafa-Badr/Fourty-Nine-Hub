import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ButtonsProfileInstagramSection extends StatelessWidget {
  const ButtonsProfileInstagramSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Edit profile',
              backColor: Colors.white,
              radius: 7,
              border: Border.all(
                color: Colors.black,
              ),
              style: Styles.mediumText(
                fontSize: 32,
                height: 1.22,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              label: 'Share profile',
              backColor: Colors.white,
              radius: 7,
              border: Border.all(
                color: Colors.black,
              ),
              style: Styles.mediumText(
                fontSize: 32,
                height: 1.22,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
