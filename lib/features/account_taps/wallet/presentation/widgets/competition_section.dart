import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_header_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_list_view_item.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CompetitionsSection extends StatelessWidget {
  CompetitionsSection({super.key});

  final List<Map<String, String>> competitions = [
    {
      'title': 'Lucky Wheel',
      'value': '0',
      'svgPath': Assets.luckyWheelIcon,
    },
    {
      'title': 'Spcial ADS',
      'value': '0',
      'svgPath': Assets.spcialAdsIcon,
    },
    {
      'title': 'Friends',
      'value': '0',
      'svgPath': Assets.friendsIcon,
    },
    {
      'title': 'Ride',
      'value': '0',
      'svgPath': Assets.ride2Icon,
    },
  ];

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
                  title: c['title'] ?? '',
                  value: c['value'] ?? '',
                  svgPath: c['svgPath'] ?? '',
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
        const CompetitionListViewItem(
          title: 'Lucky Wheel',
        ),
      ],
    );
  }
}
