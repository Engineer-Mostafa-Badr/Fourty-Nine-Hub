import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/percentage_competition_widget.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CompetitionListViewItem extends StatelessWidget {
  const CompetitionListViewItem({
    super.key,
    required this.competition,
    required this.onPressed,
  });

  final CompetitionsModell competition;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Label(
          text: competition.title,
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
                currentPoints: competition.currentPoints,
                totalPoints: competition.totalPoints,
                price: competition.price,
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
                      text: 'Money Get',
                      style: Styles.mediumText(fontSize: 20),
                    ),
                    Label(
                      text: 'Withdraw Limit',
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
                          text:
                              'Every 4000 Friend request you will get 5000 EGP',
                          style: Styles.mediumText(fontSize: 20),
                        ),
                        Text(
                          'you reached till now 4000 friend request which is equal 5000 EGP',
                          // overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                          style: Styles.mediumText(fontSize: 20),
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
                title: 'Request Transfer',
                onpressed: onPressed,
                color: competition.totalPoints == competition.currentPoints
                    ? const Color(0xFFF33D49)
                    : const Color(0xB2F33D49),
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
                          text: 'Minimum request withdrawal is 10000 EGP for',
                          style: Styles.mediumText(fontSize: 20),
                        ),
                        Label(
                          text: 'personal transaction.',
                          style: Styles.mediumText(fontSize: 20),
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
