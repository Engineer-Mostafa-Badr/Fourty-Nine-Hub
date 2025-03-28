import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class MarriageMyAdsListViewItem extends StatelessWidget {
  const MarriageMyAdsListViewItem({
    super.key,
    required this.marriageAds,
    required this.state,
  });

  final AdModel marriageAds;
  final SubcategoriesState state;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: () {
        context.push(Routes.ADdetails, extra: marriageAds.id);
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
                        image: marriageAds.images.first,
                        height: 40,
                        width: 40,
                        isCircle: true,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Label(
                        text: marriageAds.title,
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
                    text: marriageAds.description,
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
                        text: 'Giza , Egypt',
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
              child: SizedBox(
                height: 30,
                width: double.infinity,
                child: AvaialbleTripsButton(
                  title: LocaleKeys.deleteRequest.localize,
                  color: AppColors.SECONDARY_COLOR_DARK2,
                  radius: 15,
                  onTap: () {
                    // TODO: delete request
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
