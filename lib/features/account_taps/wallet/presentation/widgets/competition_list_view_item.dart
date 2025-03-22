import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wheel_wallet_entity.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/percentage_competition_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../domain/entities/gift_competitions_entity.dart';

class CompetitionListViewItem extends StatelessWidget {
  const CompetitionListViewItem({
    super.key,
    required this.competition,
    required this.luckyWheel,
    required this.currency,
    required this.onPressed,
  });

  final GiftCompetitionEntity competition;
  final WheelWalletEntity? luckyWheel;
  final String currency;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    if(luckyWheel != null) {
      return Column(
        children: [
          Label(
            text: LocaleKeys.luckyWheel.localize,
            style: Styles.headerText(fontSize: 32),
          ),
          const SizedBox(
            height: 8,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: const Color(0xffD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                PercentageCompetitionWidget(
                  currency: currency,
                  currentPoints: luckyWheel!.point,
                  totalPoints: luckyWheel!.limit.toInt(),
                  price: luckyWheel!.amount,
                  percentage: luckyWheel!.point / luckyWheel!.limit,
                ),
                const SizedBox(
                  height: 4,
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 24, end: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: LocaleKeys.getMoney.localize,
                        //'Money Get',
                        style: Styles.mediumText(fontSize: 20),
                      ),
                      Label(
                        text: LocaleKeys.withdrawalLimit.localize,
                        style: Styles.mediumText(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.alertIcon,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Label(
                            text: context.isArabic
                                ? luckyWheel!.descriptionAr
                                : luckyWheel!.descriptionEn,
                            style: Styles.mediumText(fontSize: 20),
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomButtonWalletAndGiftAndCashback(
                  title: LocaleKeys.requestTransaction2.localize,
                  //'Request Transfer',
                  onPressed: onPressed,
                  status: luckyWheel!.point > luckyWheel!.limit,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      Assets.alertIcon,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Label(
                            text: context.isArabic
                                ? luckyWheel!.descriptionGiftWalletAr
                                : luckyWheel!.descriptionGiftWalletEn,
                            style: Styles.mediumText(fontSize: 20),
                            maxLines: 5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      );
    }
    return Column(
      children: [
        Label(
          text: context.isArabic ? competition.nameAr! : competition.nameEn!,
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: const Color(0xffD9D9D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              PercentageCompetitionWidget(
                currency: currency,
                currentPoints: competition.countOfRequest!,
                totalPoints: competition.maxRequests!,
                price:
                    competition.countOfRequest! * competition.pricePerRequest!,
                percentage: ((competition.countOfRequest! *
                        competition.pricePerRequest!) /
                    competition.withdrawLimit!),
              ),
              const SizedBox(
                height: 4,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 24, end: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(
                      text: LocaleKeys.getMoney.localize,
                      //'Money Get',
                      style: Styles.mediumText(fontSize: 20),
                    ),
                    Label(
                      text: LocaleKeys.withdrawalLimit.localize,
                      style: Styles.mediumText(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.alertIcon,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Label(
                          text: context.isArabic
                              ? competition.descriptionAr!
                              : competition.descriptionEn!,
                          style: Styles.mediumText(fontSize: 20),
                          maxLines: 5,
                        ),
                        // Text(
                        //   'you reached till now 4000 friend request which is equal 5000 EGP',
                        //   // overflow: TextOverflow.ellipsis,
                        //   maxLines: 2,
                        //   softWrap: true,
                        //   style: Styles.mediumText(fontSize: 20),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButtonWalletAndGiftAndCashback(
                title: LocaleKeys.requestTransaction2.localize,
                //'Request Transfer',
                onPressed: onPressed,
                status: competition.countOfRequest! > competition.maxRequests!,
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    Assets.alertIcon,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Label(
                          text: context.isArabic
                              ? competition.descriptionGiftWalletAr!
                              : competition.descriptionGiftWalletEn!,
                          style: Styles.mediumText(fontSize: 20),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
