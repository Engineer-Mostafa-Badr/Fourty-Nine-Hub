import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class MyAdCard extends StatelessWidget {
  final AdEntity item;
  const MyAdCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADdetails),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.LIGHT_GRAY_COLOR,
            ),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAdInfo(),
            Label(text: item.formatedDate),
            _buildContactInfo(),
            BadgedLabel(
              label: item.active ? 'Active' : 'Un Active',
              color: AppColors.SECONDARY_COLOR,
              style: Styles.smallText(color: Colors.white),
            ),
            const Sizer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        label: 'Remove',
                        icon: Icons.delete,
                        onPressed: () {
                          showAreYouSure(
                              title: 'Alert',
                              subTitle: 'Are you sure, you want to remove AD?',
                              action: () {},
                              context: context);
                        })),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        label: 'Sold Out',
                        icon: Icons.hourglass_empty_rounded,
                        onPressed: () {
                          showAreYouSure(
                              title: 'Alert',
                              subTitle:
                                  'Are you sure, you want to set this AD as soldout?',
                              action: () {},
                              context: context);
                        })),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        label: 'Re publish',
                        icon: Icons.refresh,
                        onPressed: () {
                          showAreYouSure(
                              title: 'Alert',
                              subTitle:
                                  'Are you sure, you want to re publish AD?',
                              action: () {},
                              context: context);
                        })),
              ],
            ),
            const Sizer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        label: 'Installment',
                        icon: Icons.list,
                        onPressed: () =>
                            context.push(Routes.CREATEINSTALLMENT))),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        label: 'Auction',
                        icon: Icons.group,
                        onPressed: () => context.push(Routes.CREATEAUCTION))),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        label: 'Subscribe',
                        icon: Icons.remove_red_eye_sharp,
                        onPressed: () {})),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdInfo() {
    return Row(children: [
      Expanded(
          child:
              SquareImage(radius: 10, source: NetworkImage(item.images.first))),
      const Sizer(),
      Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(text: item.title),
              Label(text: item.description),
              Label(text: 'EGP ${item.price}'),
            ],
          ))
    ]);
  }

  Widget _buildContactInfo() {
    return Row(
      children: [
        Expanded(
            child: _buildContactItem(
                icon: Icons.visibility_outlined,
                label: 'Views',
                value: item.statistics?.views ?? 0)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.call_outlined,
                label: 'Tel',
                value: item.statistics?.calls ?? 0)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.chat_bubble_outline,
                label: 'Chats',
                value: item.statistics?.chats ?? 0)),
        Expanded(
            child: _buildContactItem(
                icon: Icons.bookmark_outline,
                label: 'Reqs',
                value: item.statistics?.requests ?? 0)),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required int value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: AppColors.LIGHT_GRAY_COLOR,
          ),
          child: Icon(icon),
        ),
        const Sizer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(text: '$value'),
            Label(text: label),
          ],
        )
      ],
    );
  }
}
