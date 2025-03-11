import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_header_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_list_view_item.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CompetitionsSection extends StatelessWidget {
  CompetitionsSection({super.key});

  final List<CompetitionsModell> competitions = CompetitionsModell.competitions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Label(
          text: 'Competitions',
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...competitions.map(
              (c) {
                return CompetitionHeaderItem(
                  title: c.title,
                  value: c.value,
                  svgPath: c.svgPath,
                );
              },
            ),
            CompetitionHeaderItem(
              title: 'More',
              value: '273',
              svgPath: Assets.moreIcon,
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: CompetitionsModell.competitions.length,
          itemBuilder: (context, index) {
            return CompetitionListViewItem(
              competition: competitions[index],
              onPressed: () {},
            );
          },
        )
      ],
    );
  }
}

class CompetitionsModell {
  final String title;
  final String value;
  final String svgPath;
  final int currentPoints;
  final int totalPoints;
  final num price;

  CompetitionsModell({
    required this.title,
    required this.value,
    required this.svgPath,
    required this.currentPoints,
    required this.totalPoints,
    required this.price,
  });

  static List<CompetitionsModell> competitions = [
    CompetitionsModell(
      title: 'Lucky Wheel',
      value: '0',
      svgPath: Assets.luckyWheelIcon,
      currentPoints: 1316,
      totalPoints: 5000,
      price: 0.0,
    ),
    CompetitionsModell(
      title: 'Spcial ADS',
      value: '0',
      svgPath: Assets.spcialAdsIcon,
      currentPoints: 5000,
      totalPoints: 5000,
      price: 0.0,
    ),
    CompetitionsModell(
      title: 'Friends',
      value: '0',
      svgPath: Assets.friendsIcon,
      currentPoints: 0,
      totalPoints: 5000,
      price: 0.0,
    ),
    CompetitionsModell(
      title: 'Ride',
      value: '0',
      svgPath: Assets.ride2Icon,
      currentPoints: 0,
      totalPoints: 5000,
      price: 0.0,
    ),
  ];
}
