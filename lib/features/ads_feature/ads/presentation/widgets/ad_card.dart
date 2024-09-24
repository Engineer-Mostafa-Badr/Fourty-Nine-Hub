import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
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
        height: 500.h,
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
                    child: ImageFromInternet(
                      image: item.images.first,
                      height: 200.h,
                      defaultLogo: true,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Expanded(
                //   child: Label(
                //     text:
                //         '${NumbersHelper.formatThousands(number: item.price??0)} L.E',
                //     style: Styles.mediumText(
                //         fontWeight: FontWeight.bold,
                //         color: AppColors.SECONDARY_COLOR),
                //     maxLines: 1,
                //   ),
                // ),
                Sizer(),
                IconAppButton(
                    size: 18, icon: Icons.favorite_border, onPressed: () {}),
              ],
            ),
            Row(
              children: [
                Label(
                    text: '${LocaleKeys.title.localize} : ',
                    style: Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
                Label(
                  text: item.title,
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                  maxLines: 1,
                ),
              ],
            ),
            Row(
              children: [
                Label(
                    text: '${LocaleKeys.desc.localize} : ',
                    style: Styles.mediumText(color: AppColors.SECONDARY_COLOR)),
                Label(
                  text: item.description,
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                  maxLines: 1,
                ),
              ],
            ),
            RichText(
                text: TextSpan(
                    children: item.details
                        .map((e) => WidgetSpan(
                                child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              margin: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Label(
                                      text: '${e.label} : ',
                                      style: Styles.mediumText(
                                          color: AppColors.SECONDARY_COLOR)),
                                  Label(
                                      text: '${e.value}',
                                      style: Styles.mediumText(
                                          color: AppColors.PRIMARY_COLOR)),
                                ],
                              ),
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
