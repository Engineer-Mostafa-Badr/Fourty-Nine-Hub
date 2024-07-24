import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
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
      onTap: () => context.push(Routes.ADdetails, extra: item.id),
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
                        label: 'Edit',
                        onPressed: () => context.push(Routes.CREATEAD))),
                const Sizer(),
                AppButton(
                    label: '',
                    icon: Icons.more_horiz,
                    onPressed: () {
                      bottomSheet(
                          context: context,
                          isScrollControlled: true,
                          widget: ListView(
                            shrinkWrap: true,
                            children: [
                              _buildOptionsWidget(
                                label: 'Delete',
                                onTap: () {
                                  showAreYouSure(
                                      title: 'Alert',
                                      subTitle:
                                          'Are you sure, you want to remove AD?',
                                      action: () {},
                                      context: context);
                                },
                                icon: Icons.delete,
                              ),
                              _buildOptionsWidget(
                                label: 'Sold Out',
                                onTap: () {
                                  showAreYouSure(
                                      title: 'Alert',
                                      subTitle:
                                          'Are you sure, you want to set this AD as soldout?',
                                      action: () {},
                                      context: context);
                                },
                                icon: Icons.hourglass_empty_rounded,
                              ),
                              _buildOptionsWidget(
                                label: 'Re publish',
                                onTap: () {
                                  showAreYouSure(
                                      title: 'Alert',
                                      subTitle:
                                          'Are you sure, you want to set this AD as soldout?',
                                      action: () {},
                                      context: context);
                                },
                                icon: Icons.refresh,
                              ),
                              _buildOptionsWidget(
                                label: 'Installment',
                                onTap: () =>
                                    context.push(Routes.CREATEINSTALLMENT),
                                icon: Icons.list,
                              ),
                              _buildOptionsWidget(
                                label: 'Auction',
                                onTap: () => context.push(Routes.CREATEAUCTION, extra: item.id),
                                icon: Icons.group,
                              ),
                            ],
                          ));
                    })
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsWidget({
    required String label,
    required Function onTap,
    required IconData icon,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Label(
            text: label,
          ),
          onTap: () => onTap(),
        ),
      ],
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
