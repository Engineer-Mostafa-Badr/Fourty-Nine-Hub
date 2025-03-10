import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/percentage_competition_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CompetitionListViewItem extends StatelessWidget {
  const CompetitionListViewItem({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Label(
          text: title,
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
          child: const Column(
            children: [
              PercentageCompetitionWidget(),
            ],
          ),
        )
      ],
    );
  }
}
