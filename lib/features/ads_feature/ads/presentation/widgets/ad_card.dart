import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class AdCard extends StatelessWidget {
  final AdEntity item;
  const AdCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADdetails, extra: item.id),
      child: SizedBox(
        width: kToolbarHeight * 2.5,
        // decoration: BoxDecoration(color: Colors.red),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SquareImage(
                    width: double.infinity,
                    radius: 10,
                    fit: BoxFit.cover,
                    source: NetworkImage(item.images.first))),
            Row(
              children: [
                Expanded(
                  child: Label(
                    text:
                        '${NumbersHelper.formatThousands(number: item.price)} L.E',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.SECONDARY_COLOR),
                    maxLines: 1,
                  ),
                ),
                const Sizer(),
                IconAppButton(
                    size: 18, icon: Icons.favorite_border, onPressed: () {}),
              ],
            ),
            Label(
              text: item.title,
              style: Styles.mediumText(
                  fontWeight: FontWeight.w500, color: Colors.grey),
              maxLines: 1,
            ),
            RichText(
                text: TextSpan(
                    children: item.details
                        .map((e) => WidgetSpan(
                                child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Label(
                                  text: '${e.value} |',
                                  style: Styles.mediumText()),
                            )))
                        .toList())),
            Label(
              text: item.address?.street??'',
              style: Styles.mediumText(color: Colors.grey),
              maxLines: 1,
            ),
            Label(
              text: item.formattedRestTime,
              style: Styles.mediumText(color: Colors.grey),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
