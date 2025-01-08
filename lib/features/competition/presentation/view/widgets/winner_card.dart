import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/competition/domain/entity/winner_competition_entity.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';

class WinnerCard extends StatelessWidget {
  WinnerCard({super.key, required this.isWinner, required this.model});

  bool isWinner = false;
  final WinnerCompetitionEntity model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              Icons.star,
              size: 14,
              color: AppColors.ACCENT_COLOR,
            ),
            Column(
              children: [
                Icon(
                  FontAwesomeIcons.crown,
                  color: AppColors.ACCENT_COLOR,
                ),
                Sizer(),
              ],
            ),
            Icon(
              Icons.star,
              size: 14,
              color: AppColors.ACCENT_COLOR,
            ),
          ],
        ),
        CircleAvatar(
          radius: isWinner ? 42 : 35,
          backgroundColor:
              isWinner ? AppColors.ACCENT_COLOR : AppColors.PRIMARY_COLOR,
          child: ImageFromInternet(
            isCircle: true,
            image: model.image,
          ),
        ),
        const Sizer(),
        Label(
            text: '${model.firstName} ${model.lastName}',
            style: Styles.mediumText(fontWeight: FontWeight.w500)),
        Label(
            text:
                context.locale == Locales.english ? model.nameEn : model.nameAr,
            style: Styles.smallText()),
        Label(text: '${model.profit}', style: Styles.mediumText()),
      ],
    );
  }
}
