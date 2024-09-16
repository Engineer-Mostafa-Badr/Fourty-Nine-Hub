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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdCard extends StatelessWidget {
  final AdEntity item;
  const AdCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADdetails, extra: item.id),
      child: Container(
        width: kToolbarHeight * 2.5,
        height: 250.h,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.BACKGROUND_COLOR, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      fit: BoxFit.fitWidth,
                      radius: 10,
                      url: item.images.first,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: _buildTag(),
                  )
                ],
              ),
            )),
            Row(
              children: [
                Expanded(
                  child: Label(
                    text:
                        '${NumbersHelper.formatThousands(number: item.price)}',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: AppColors.SECONDARY_COLOR),
                    maxLines: 1,
                  ),
                ),
                Sizer(),
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
              text: item.address?.street ?? '',
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

  Widget _buildTag() {
    // super premium
    return const Icon(
      Icons.workspace_premium_outlined,
      size: 20,
      color: AppColors.SECONDARY_COLOR,
    );
    // premium
    // regular
  }
}
