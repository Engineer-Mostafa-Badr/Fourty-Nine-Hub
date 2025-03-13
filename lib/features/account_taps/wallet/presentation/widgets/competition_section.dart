import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_header_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_list_view_item.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../domain/entities/gift_competitions_entity.dart';

class CompetitionsSection extends StatelessWidget {
  CompetitionsSection({super.key, required this.competitions});

  final List<GiftCompetitionEntity> competitions;

  final Map<String, String> competitionIcons = {
    '': Assets.luckyWheelIcon,
    '66bca1717a9c14dbbb053cea': Assets.rideUsageIcon,
    '663e265a9c4c5ed6b7621bc8': Assets.userShippingTripsIcon,
  };

  List<GiftCompetitionEntity> getFirstFourCompetitions(List<GiftCompetitionEntity> competitions) {
    final first4List = competitions.sublist(0, 4);
    return first4List;
  }

  @override
  Widget build(BuildContext context) {
    List<GiftCompetitionEntity> firstFourCompetitions = getFirstFourCompetitions(competitions);
    return Column(
      children: [
        Label(
          text: LocaleKeys.competitions.localize,
          style: Styles.headerText(fontSize: 32),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ...firstFourCompetitions.map(
              (c) {
                return Expanded(
                  child: CompetitionHeaderItem(
                    title: context.isArabic? c.nameAr! : c.nameEn!,
                    value: c.pricePerRequest.toString(),
                    svgPath: competitionIcons[c.id!]?? Assets.emergency,
                  ),
                );
              },
            ),
            Expanded(
              child: CompetitionHeaderItem(
                title: LocaleKeys.more.localize,
                value: '273',
                svgPath: Assets.moreIcon,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: competitions.length,
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
