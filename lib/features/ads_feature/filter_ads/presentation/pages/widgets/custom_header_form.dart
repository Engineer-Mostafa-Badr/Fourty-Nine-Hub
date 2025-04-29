import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';

import '../../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../create_ad/domain/entities/categorization_entity.dart';

class CustomHeaderForm extends StatelessWidget {
  const CustomHeaderForm({
    super.key,
    required this.categorization,
  });

  final CategorizationEntity categorization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.createAd.localize,style: Styles.headerText(),),
        Sizer(),
        Row(
          children: [

            SquareImage(
              // width: kToolbarHeight * .8,
              // height: kToolbarHeight * .8,
              width: 60,
              height: 60,
              radius: 10,
              url: categorization.subCategory.image,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: context.isArabic
                      ? categorization.subCategory.nameAr
                      : categorization.subCategory.nameEn,
                  style: Styles.headerText(fontSize: 32),
                ),
                Label(
                  text:
                  categorization.mainCategory.name == LocaleKeys.health.localize
                      ? LocaleKeys.medicalService.localize
                      : categorization.mainCategory.name  ?? "",
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w500,
                    fontSize: 32,
                    color: context.isDarkMode?Colors.white:Colors.black.withValues(alpha: 153),
                  ),
                ),
              ],
            )),
          ],
        ),
      ],
    );
  }
}
