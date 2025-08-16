import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/marriage_call_message_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class MarriageRequestListViewItem extends StatelessWidget {
  const MarriageRequestListViewItem({
    super.key,
    required this.marriageAds,
    required this.state,
  });

  final RequestsLogByMainCategoryEntity marriageAds;
  final SubcategoriesState state;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        ManageVibration.vibrate();
        context.pushNamed(Routes.ADdetails, extra: marriageAds.adId);
      },
      child: Container(
        // margin: EdgeInsets.only(bottom: 20.h),
        // padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.black.withValues(alpha: 178),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ImageFromInternet(
// TODO
                        image: marriageAds.subCategoryId,
                        height: 40,
                        width: 40,
                        isCircle: true,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Label(
                        text: marriageAds.adTitle,
                        style: Styles.headerText(
                          height: 1.60,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Label(
                    text: marriageAds.adDesc,
                    style: Styles.mediumText(fontSize: 24, height: 1.40),
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SvgPicture.asset(Assets.mapPinIcon),
                      const SizedBox(
                        width: 4,
                      ),
                      Label(
                        text: context.isArabic ? 'الجيزة، مصر' : 'Giza , Egypt',
                        style: Styles.headerText(
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.black.withValues(alpha: 178),
              height: 0,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 18, right: 18, top: 4, bottom: 8),
              child: MarriageCallMessageButtons(
                otherUserId: marriageAds.userId,
                subcategoryId: state
                        .subCategories?[state.subCategories?.indexWhere(
                                (element) => element.isSelected == true) ??
                            0]
                        .id ??
                    '',
                phone: marriageAds.phone,
                id: marriageAds.adId,
                hasReport: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
