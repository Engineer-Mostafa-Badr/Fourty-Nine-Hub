import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/investment_item.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InvestmentSection extends StatefulWidget {
  const InvestmentSection({super.key, required this.yearsFromFiveYears, required this.yearsFromTenYears});

  final int yearsFromFiveYears;
  final int yearsFromTenYears;

  @override
  State<InvestmentSection> createState() => _InvestmentSectionState();
}

class _InvestmentSectionState extends State<InvestmentSection> {
  bool _isHintOped = true;

  void _toggleHint() {
    setState(() {
      _isHintOped = !_isHintOped;
    });
  }

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
                child: InkWell(
                  onTap: () => _toggleHint(),
                  child: SvgPicture.asset(
                    Assets.ideaIcon,
                  ),
                ),
              ),
            ),
          ],
        ),
        // const SizedBox(
        //   height: 16,
        // ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _isHintOped
              ? Container(
                  key: const ValueKey(1),
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    children: [
                      InvestmentItem(
                        totalYears: 5,
                        currentYears: widget.yearsFromFiveYears,
                        onPressed: () {},
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InvestmentItem(
                        totalYears: 10,
                        currentYears: widget.yearsFromTenYears,
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              : Container(
                  key: const ValueKey(2),
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 4, bottom: 4),
                  padding: const EdgeInsets.only(
                    top: 8,
                    bottom: 28,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Label(
                        text: 'Hint',
                        style: Styles.headerText(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF33D49),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Label(
                        text: 'Any money you subscribe',
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                      Label(
                        text: 'inside app, you will get interest',
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                      Label(
                        text: 'after 5 years and 10 years',
                        style: Styles.mediumText(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
