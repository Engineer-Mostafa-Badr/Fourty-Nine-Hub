import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/data/models/Ad_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/subcategories/presentation/cubit/subcategories_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/constants/subscription_status.dart';
import '../../../../../core/widget/common/global_card.dart';

class MarriageMyAdsListViewItem extends StatefulWidget {
  const MarriageMyAdsListViewItem({
    super.key,
    required this.marriageAds,
    required this.state,
  });

  final AdModel marriageAds;
  final SubcategoriesState state;

  @override
  State<MarriageMyAdsListViewItem> createState() =>
      _MarriageMyAdsListViewItemState();
}

class _MarriageMyAdsListViewItemState extends State<MarriageMyAdsListViewItem> {
  @override
  Widget build(BuildContext context) {
    return GlobalCard(
      subcategoryId: widget.marriageAds.subCategoryId ?? '',
      phone: widget.marriageAds.phone ?? "",
      reportId: widget.marriageAds.user?.id ?? '',
      otherUserId: '',
      onTap: () async {
        ManageVibration.vibrate();
        context.push(Routes.ADdetails, extra: widget.marriageAds.id);
      },
      isButtonEnabled: false,
      isPremium: SubscriptionStatus.premium.status ==
          widget.marriageAds.ownerSubscriptionStatus,
      hasReport: false,
      hasTopSide: true,
      isView: null,
      subCategoryTitle: context.isArabic
          ? widget.marriageAds.subCategoryNameAr
          : widget.marriageAds.subCategoryNameEn,
      subscriptionType: widget.marriageAds.ownerSubscriptionStatus ==
              SubscriptionStatus.premium.status
          ? LocaleKeys.premium2.localize
          : widget.marriageAds.ownerSubscriptionStatus ==
                  SubscriptionStatus.regular.status
              ? LocaleKeys.regular.localize
              : LocaleKeys.notSubscribed.localize,
      views: widget.marriageAds.views,
      onRequest: () async {
        ManageVibration.vibrate();
        // Get cubit before any async operation
        final cubit = context.read<SubcategoriesCubit>();

        // Show confirmation dialog
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.isArabic ? 'حذف الإعلان' : 'Delete Ad'),
            content: Text(context.isArabic
                ? 'هل أنت متأكد من حذف هذا الإعلان؟'
                : 'Are you sure you want to delete this ad?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.isArabic ? 'إلغاء' : 'Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  context.isArabic ? 'حذف' : 'Delete',
                  style: TextStyle(color: AppColors.SECONDARY_COLOR),
                ),
              ),
            ],
          ),
        );

        if (confirmed == true && mounted) {
          // Call delete API (it will remove from state automatically)
          await cubit.deleteAd(widget.marriageAds.id);
        }
      },
      onSubscribe: () {
        context.pop();
      },
      hasBottomSide: true,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.w, right: 18.w, top: 8.h, bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // user image , title
          Row(
            children: [
              ImageFromInternet(
                image: widget.marriageAds.images.first,
                height: 40.h,
                width: 40.w,
                isCircle: true,
              ),
              SizedBox(
                width: 8.w,
              ),
              Expanded(
                child: Label(
                  text: widget.marriageAds.title,
                  style: Styles.headerText(
                    color: AppColors.getTextColor(context),
                    height: 1.60,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 4.h,
          ),
          // description
          Label(
            text: widget.marriageAds.description,
            style: Styles.mediumText(
              fontSize: 48.sp,
              height: 1.40,
              color: AppColors.getTextColor(context),
            ),
            maxLines: 5,
          ),
          SizedBox(
            height: 4.h,
          ),
          // location
          if (widget.marriageAds.address?.cityEn != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(
                  Assets.mapPinIcon,
                  color: context.isDarkMode ? Colors.white : null,
                ),
                SizedBox(
                  width: 4.w,
                ),
                Flexible(
                  child: Label(
                    text: (context.isArabic
                            ? widget.marriageAds.address?.addressAr
                            : widget.marriageAds.address?.addressEn) ??
                        '',
                    style: Styles.mediumText(
                      fontSize: 48.sp,
                      height: 1.40,
                      color: AppColors.getTextColor(context),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
