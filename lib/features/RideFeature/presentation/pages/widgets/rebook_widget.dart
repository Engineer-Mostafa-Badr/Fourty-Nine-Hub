import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';

class RebookWidget extends StatelessWidget {
  const RebookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 88,
      decoration: BoxDecoration(
        color: AppColors.cF3F3F3,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4),
        child: Row(
          children: [
            SvgPicture.asset(Assets.reBookIcon),
            const SizedBox(width: 4,),
            Label(text: LocaleKeys.rebook.localize,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14
              ),
            ),
          ],
        ),
      ),
    );
  }
}