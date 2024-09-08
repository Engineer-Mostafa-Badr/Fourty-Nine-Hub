import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/competitions_wallet_entity.dart';

class CompetitionCard extends StatelessWidget {
  final CompetitionsWalletEntity competitionsWalletEntity;
  final Function(BuildContext context) onTap;

  const CompetitionCard(
      {super.key, required this.onTap, required this.competitionsWalletEntity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: .5),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      text: context.locale == Locales.english
                          ? competitionsWalletEntity.nameEn
                          : competitionsWalletEntity.nameAr,
                      style: Styles.mediumText(fontWeight: FontWeight.bold),
                    ),
                    Label(
                      text: '${competitionsWalletEntity.countOfRequest}',
                    ),
                  ],
                )),
                SizedBox(
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CircularProgressIndicator(
                          value: competitionsWalletEntity.countOfRequest /
                              competitionsWalletEntity.maxRequests,
                          strokeWidth: 10,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Label(
                            text:
                                '${((competitionsWalletEntity.countOfRequest / competitionsWalletEntity.maxRequests) * 100).toStringAsFixed(1)}%',
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const Sizer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                const Sizer(),
                Expanded(
                    child: Label(
                  text:
                      '${LocaleKeys.minimum.localize} ${competitionsWalletEntity.maxRequests} ${LocaleKeys.requestTransaction.localize}',
                  style: Styles.mediumText(color: Colors.grey),
                )),
              ],
            ),
            const Sizer(),
            AppButton(
              label: LocaleKeys.requestWithdraw.localize,
              color: AppColors.AUTH_CONTAINER_COLOR,
              backColor: competitionsWalletEntity.countOfRequest >= 5000 &&
                      competitionsWalletEntity.isWinner == true
                  ? Colors.red
                  : Colors.red.withOpacity(.5),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
