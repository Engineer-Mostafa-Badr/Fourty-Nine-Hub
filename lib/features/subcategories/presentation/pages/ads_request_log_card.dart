import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ad_requests/domain/entities/requests_log_by_main_category_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class AdsRequestLogCard extends StatefulWidget {
  final RequestsLogByMainCategoryEntity requestLog;

  const AdsRequestLogCard({
    super.key,
    required this.requestLog,
  });

  @override
  State<AdsRequestLogCard> createState() => _AdsRequestLogCardState();
}

class _AdsRequestLogCardState extends State<AdsRequestLogCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: context.isDarkMode
            ? AppColors.GREY_DARK_COLOR
            : AppColors.whiteColor,
        border: Border.all(
            color: context.isDarkMode
                ? AppColors.LIGHT_COLOR
                : const Color(0xB20B1035),
            width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 4.h),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Expanded(
          //           child: Row(
          //         children: [
          //           SvgPicture.asset(
          //             Assets.viewsIcon,
          //             color: context.isDarkMode ? AppColors.LIGHT_COLOR : null,
          //           ),
          //           SizedBox(
          //             width: 10.w,
          //           ),
          //           Text(
          //             '437K views',
          //             style: TextStyle(
          //                 color: context.isDarkMode
          //                     ? AppColors.LIGHT_COLOR
          //                     : AppColors.black,
          //                 fontSize: FontSize.s12,
          //                 fontWeight: FontWeight.w400),
          //           ),
          //         ],
          //       )),
          //       SizedBox(
          //         width: 10.w,
          //       ),
          //       const Label(
          //         text: 'Premium',
          //         style: TextStyle(
          //             color: AppColors.SECONDARY_COLOR,
          //             fontSize: FontSize.s16,
          //             fontWeight: FontWeight.w700),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xfff2f1f7),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: _buildHeader(
              status: widget.requestLog.isPremium,
              views: widget.requestLog.views,
            ),
          ),
          Divider(
            color: context.isDarkMode
                ? AppColors.LIGHT_COLOR
                : const Color(0xB20B1035),
            thickness: 1,
            height: 0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        widget.requestLog.gender == 'male'
                            ? Assets.maleImagePlaceholder
                            : Assets.femaleImagePlacehlder,
                      ),
                    ),

                    SizedBox(
                      width: 16.w,
                    ),
                    Label(
                      text: widget.requestLog.firstName,
                      style: Styles.headerText(
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.black,
                        fontSize: 36,
                        height: 1.60,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Label(
                    text: widget.requestLog.adTitle,
                    style: Styles.mediumText(
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black,
                      fontSize: 24,
                      height: 1.40,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    context.isArabic
                        ? widget.requestLog.subCategoryNameAr
                        : widget.requestLog.subCategoryNameEn,
                    style: Styles.mediumText(
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      height: 1.60,
                    ),
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: context.isDarkMode
                ? AppColors.LIGHT_COLOR
                : AppColors.black.withValues(alpha: 0.7),
            thickness: 1,
            height: 0,
          ),
          CallMessageButtons(
            otherUserId: widget.requestLog.userId,
            subcategoryId: widget.requestLog.subCategoryId,
            phone: widget.requestLog.phone,
            id: UserCubit.to.state.data?.id ?? '',
            hasReport: true,
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget _buildHeader({required num views, required bool status}) {
    return Container(
      // width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // color: status == SubscriptionStatus.premium.status
      //     ? Colors.amber
      //     : Colors.grey,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // if (status != SubscriptionStatus.notSubscribed.status) ...[
          //   Icon(
          //     Icons.workspace_premium_outlined,
          //     size: 55.w,
          //     color: status == SubscriptionStatus.premium.status
          //         ? AppColors.SECONDARY_COLOR
          //         : status == SubscriptionStatus.regular.status
          //             ? AppColors.PRIMARY_COLOR
          //             : null,
          //   ),
          //   const Sizer(width: 5)
          // ],
          SvgPicture.asset(
            Assets.adsEyeIcon,
          ),
          const SizedBox(width: 6),
          if (views == 0) ...[
            Label(
              text: LocaleKeys.noViews.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 1) ...[
            Label(
              text: LocaleKeys.oneView.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views == 2) ...[
            Label(
              text: LocaleKeys.twoViews.localize,
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else if (views >= 3 && views <= 10) ...[
            Label(
              text: '$views ${LocaleKeys.views.localize}',
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ] else ...[
            Label(
              text:
                  '${FormatNumbers().formatNumber(views)} ${LocaleKeys.view.localize}',
              style: Styles.mediumText(
                color: const Color(0xFF6C6C6C),
                fontSize: 24,
                height: 1.60,
              ),
            ),
          ],
          const Spacer(),
          Label(
            text: status
                ? LocaleKeys.premium2.localize
                : LocaleKeys.regular.localize,
            style: Styles.mediumText(
              color: const Color(0xFFF33D49),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.60,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
