import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_header_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_list_view_item.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/utils/custom_show_dialog.dart';
import '../../domain/entities/gift_competitions_entity.dart';
import 'competitions_pop_up_items.dart';

class CompetitionsSection extends StatelessWidget {
  const CompetitionsSection({super.key, required this.competitions});

  final List<GiftCompetitionEntity> competitions;

  List<GiftCompetitionEntity> getFirstFourCompetitions(
      List<GiftCompetitionEntity> competitions) {
    final first4List = competitions.sublist(0, 4);
    return first4List;
  }

  @override
  Widget build(BuildContext context) {
    List<GiftCompetitionEntity> firstFourCompetitions =
        getFirstFourCompetitions(competitions);
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
                    title: context.isArabic ? c.nameAr! : c.nameEn!,
                    value: FormatNumbers()
                        .formatNumber(c.countOfRequest! * c.pricePerRequest!),
                    svgPath: competitionIcons[c.id] ?? '',
                  ),
                );
              },
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  showAnimatedDialog(
                    context,
                    CompetitionsPopUpItems(
                      competitions: competitions,
                    ),
                  );
                },
                child: CompetitionHeaderItem(
                  title: LocaleKeys.more.localize,
                  value: FormatNumbers().formatNumber(competitions
                      .map((c) {
                        return c.countOfRequest! * c.pricePerRequest!;
                      })
                      .toList()
                      .reduce((value, element) => value + element)),
                  svgPath: Assets.moreIcon,
                ),
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
              onPressed: () {
                // context.read<Cubit>().getHistories(context);
              },
            );
          },
        )
      ],
    );
  }
}

final Map<String, String> competitionIcons = {
  '66bca1717a9c14dbbb053cea': Assets.rideUsageIcon,
  '663e265a9c4c5ed6b7621bc8': Assets.userShippingTripsIcon,
  '66bc9d237a9c14dbbb053cdd': Assets.foodRequestIcon,
  '66bca0847a9c14dbbb053ce1': Assets.patientAppointmentIcon,
  '66bca1cf7a9c14dbbb053cec': Assets.premiumAdvertiseIcon,
  '663e260c9c4c5ed6b7621bc4': Assets.friendsIcon,
  '677d5ff2404736470bb04b46': '', // 'طلب متابعه - Follow Request',
  '677d634a404736470bb04e67': Assets.viewCountIcon,
  '677d566ce7cb468172395aac': Assets.likeClickedIcon,
  '663e25de9c4c5ed6b7621bc0': '', //'طلبات صداقه - Friend Requests',
  '677d5efc60a4075f2f61de1e': Assets.followersIcon,
  '677d5c1d60a4075f2f61db00': Assets.profileViewIcon,
  '67a88f44f77f8cccf2fa609b': '', // 'مشاهدات قصة - Story Views',
  '677d5979a500582a081522b8': Assets.reel_view_icon,
  '677d3ecd12853350f9a1acaf': Assets.postLikesIcon,
  '67aacf8df8842fddb6516ea4': '', // 'اعجابات القصة - Story Likes',
  '677d1f23f1066ffc57bab771': Assets.reelLikesIcon,
  '66bcaabf7a9c14dbbb053cf7': '', // 'اعجابات بث مباشر - Live Lickes',
  '66bca14c7a9c14dbbb053ce8': '', // 'رحلات كابتن - Captain Trips',
  '663e26789c4c5ed6b7621bcc': '', // 'رحلات سائق شحن - Shipping Driver Trips',
  '66bca0f87a9c14dbbb053ce6': '', // 'طلبات مطعم - Restaurant Orders',
  '66bca05d7a9c14dbbb053cdf': '', // 'حجوزات دكتور - Doctor Bookings',
  '67ac3a3b1b196340209a8918': '', // 'النقرات البث المباشرة - Clicks on live',
};
