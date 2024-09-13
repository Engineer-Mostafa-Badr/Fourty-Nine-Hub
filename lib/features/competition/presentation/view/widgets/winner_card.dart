import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/competition/data/models/winners_model.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class WinnerCard extends StatelessWidget {
  WinnerCard({super.key, required this.isWinner, required this.model});

  bool isWinner = false;
  final DataWinners model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(
              Icons.star,
              size: 14,
              color: AppColors.ACCENT_COLOR,
            ),
            Column(
              children: [
                const Icon(
                  FontAwesomeIcons.crown,
                  color: AppColors.ACCENT_COLOR,
                ),
                Sizer(),
              ],
            ),
            const Icon(
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
          child: CircleAvatar(
            radius: isWinner ? 40 : 33,
            backgroundColor: Colors.white,
            backgroundImage:
                NetworkImage('${model.userId?.userProfile?.profilePictureKey?.mediaKey}' ?? ''),
          ),
        ),
        Sizer(),
        Label(
            text: model.userId?.fullName ??'',
            style: Styles.mediumText(fontWeight: FontWeight.w500)),
        Label(
            text: context.locale == Locales.english
                ? model.competitionId!.nameEn!
                : model.competitionId!.nameAr!,
            style: Styles.smallText()),
        Label(text: '${model.profit}', style: Styles.mediumText()),
      ],
    );
  }
}
