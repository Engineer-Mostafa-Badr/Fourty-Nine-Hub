import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';

import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../domain/entities/installment_entity.dart';

class InstallmentAdCard extends StatelessWidget {
  final InstallmentEntity item;
  final bool isVertical;
  const InstallmentAdCard(
      {super.key, required this.item, this.isVertical = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.push(Routes.INSTALLMENTDETAILS),
        child: isVertical
            ? _buildVerticalView(context: context)
            : _buildHorizontalView(context: context));
  }

  Widget _buildHorizontalView({required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SquareImage(
                width: double.infinity,
                radius: 10,
                source: NetworkImage(item.ad.images.first))),
        const Sizer(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Label(
                        text: item.ad.title,
                        style: Styles.mediumText(fontWeight: FontWeight.bold),
                        maxLines: 1,
                      ),
                      Label(
                        text: item.ad.description,
                        style: Styles.mediumText(),
                        maxLines: 2,
                      ),
                    ],
                  )),
                  const Sizer(),
                  IconAppButton(
                      size: 20, icon: Icons.favorite_border, onPressed: () {}),
                ],
              ),
              Label(
                text: item.ad.address?.address??'',
                style: Styles.mediumText(),
                maxLines: 1,
              ),
              Label(
                text:
                    '${NumbersHelper.formatThousands(number: item.ad.price)} ${Labels.currency}',
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.SECONDARY_COLOR),
                maxLines: 1,
              ),
              RichText(
                  text: TextSpan(
                children: item.plans?.map((e) {
                  return WidgetSpan(
                      child:
                          BadgedLabel(margin: 3, label: e.duration.toString()));
                }).toList(),
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVerticalView({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SquareImage(
                width: double.infinity,
                radius: 10,
                source: NetworkImage(item.ad.images.first))),
        Row(
          children: [
            Expanded(
              child: Label(
                text:
                    '${NumbersHelper.formatThousands(number: item.ad.price)} ${Labels.currency}',
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.SECONDARY_COLOR),
                maxLines: 1,
              ),
            ),
            const Sizer(),
            IconAppButton(
                size: 20, icon: Icons.favorite_border, onPressed: () {}),
          ],
        ),
        Label(
          text: item.ad.title,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        Label(
          text: item.ad.description,
          style: Styles.mediumText(),
          maxLines: 2,
        ),
        RichText(
            text: TextSpan(
          children: item.plans?.map((e) {
            return WidgetSpan(
                child: BadgedLabel(margin: 3, label: e.duration.toString()));
          }).toList(),
        ))
      ],
    );
  }
}
