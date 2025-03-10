import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/investment_item.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InvestmentSection extends StatelessWidget {
  const InvestmentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Label(
                text: 'Investment',
                style: Styles.headerText(
                  fontSize: 32,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 20),
                child: SvgPicture.asset(
                  Assets.ideaIcon,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Column(
            children: [
              InvestmentItem(
                totalYears: '5',
                currentYears: '0',
                onPressed: () {},
              ),
              const SizedBox(
                height: 12,
              ),
              InvestmentItem(
                totalYears: '10',
                currentYears: '0',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
