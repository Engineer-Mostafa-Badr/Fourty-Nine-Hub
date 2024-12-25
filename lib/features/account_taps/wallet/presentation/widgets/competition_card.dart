import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

// import '../../../../../common/widgets/dynamic/sizer,.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/competitions_wallet_entity.dart';

class CompetitionCard extends StatelessWidget {
  final CompetitionsWalletEntity competitionsWalletEntity;
  final Function() onTap;

  const CompetitionCard(
      {super.key, required this.onTap, required this.competitionsWalletEntity});

  @override
  Widget build(BuildContext context) {
    final int countOfRequest =
        (competitionsWalletEntity.countOfRequest).toInt();
    final int maxRequests = (competitionsWalletEntity.maxRequests).toInt();
    print('max request is $maxRequests');
    return Container(
      margin: EdgeInsets.all(5.w),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey, width: .5.w),
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
                    style: Styles.mediumText(
                        fontSize: 55.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              )),
              Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                    width: kToolbarHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Padding(
                            padding:  EdgeInsets.all(8.w),
                            child: CircularProgressIndicator(
                              value: countOfRequest / maxRequests,
                              strokeWidth: 8,
                              color: AppColors.SECONDARY_COLOR,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Label(
                              text:
                                  '${((countOfRequest / maxRequests) * 100).toStringAsFixed(1)}%',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Label(
                    text: '${competitionsWalletEntity.countOfRequest}',
                  ),
                ],
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
              Sizer(
                width: 10.w,
              ),
              Expanded(
                  child: Label(
                maxLines: 2,
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
            backColor: competitionsWalletEntity.countOfRequest >= competitionsWalletEntity.maxRequests &&
                    competitionsWalletEntity.isWinner == true
                ? Colors.red
                : Colors.red.withOpacity(.5),
            onPressed: competitionsWalletEntity.countOfRequest >= competitionsWalletEntity.maxRequests &&
                    competitionsWalletEntity.isWinner == true
                ? () {
                    onTap();
                  }
                : () {},
          ),
        ],
      ),
    );
  }
}
