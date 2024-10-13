import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/global/button_availability.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/call_message_buttons.dart';
import 'package:fourtyninehub/features/ads_feature/ads/domain/entities/ad_entity.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/premium_request_button.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/widgets/request_button.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/create_ad_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/features/trip_join/view_all_trip_join/presentation/views/widgets/available_trip_button.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';

class MobileAdCard extends StatefulWidget {
  final AdEntity item;
  const MobileAdCard(
      {super.key,
      required this.item,
      required this.onFav,
      required this.onRemoveFav});
  final Function(String) onFav;
  final Function(String) onRemoveFav;

  @override
  State<MobileAdCard> createState() => _MobileAdCardState();
}

class _MobileAdCardState extends State<MobileAdCard> {
  @override
  Widget build(BuildContext context) {
    List<CreateAdEntity> details = widget.item.details
        .where((e) => e.value.nameAr != 'السعر' && e.value.nameAr != 'المرتب')
        .toList();
    return InkWell(
      child: Container(
        width: kToolbarHeight * 2.5,
        // height: 600.h,
        margin: EdgeInsetsDirectional.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: AppColors.DARK_GRAY_COLOR, width: 1),
        ),
        child: Column(
          children: [
            SizedBox(
              height: kToolbarHeight * 2.8,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: kToolbarHeight * 2.8,
                      width: double.infinity,
                      child: Swiper(
                        itemCount: widget.item.images.length > 4
                            ? 4
                            : widget.item.images.length,
                        onIndexChanged: (i) {},
                        outer: false,
                        loop: false,
                        physics: widget.item.images.length > 1
                            ? null
                            : const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: 5.h),
                          child: Stack(
                            children: [
                              ImageFromInternet(
                                width: double.infinity,
                                image: widget.item.images[index],
                                defaultLogo: true,
                                fit: BoxFit.fill,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.r),
                                    topRight: Radius.circular(5.r)),
                              ),
                              if (index == 3)
                                Positioned.fill(
                                    child: InkWell(
                                  onTap: () => context.push(Routes.ADdetails,
                                      extra: widget.item.id),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.8),
                                    alignment: AlignmentDirectional.center,
                                    child: Label(
                                      text: 'See More',
                                      style: Styles.headerText(
                                          color: Colors.white,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ))
                            ],
                          ),
                        ),
                        pagination: SwiperPagination(builder:
                            SwiperCustomPagination(builder: (context, config) {
                          return const DotSwiperPaginationBuilder(
                                  color: AppColors.GREY_DARK_COLOR,
                                  activeColor: AppColors.SECONDARY_COLOR,
                                  size: 10.0,
                                  activeSize: 10.0)
                              .build(context, config);
                        })),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.symmetric(horizontal: 15.w),
                      child: InkWell(
                        onTap: () => context.push(Routes.ADdetails,
                            extra: widget.item.id),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Label(
                                      text:
                                          '${NumbersHelper.formatThousands(number: widget.item.price ?? 0)} ${LocaleKeys.currency.localize}',
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.SECONDARY_COLOR),
                                      maxLines: 1,
                                    ),
                                  ),
                                  IconAppButton(
                                      size: 18,
                                      icon: widget.item.isFavourite == false
                                          ? Icons.favorite_border
                                          : Icons.favorite,
                                      color: AppColors.SECONDARY_COLOR,
                                      onPressed: () async {
                                        if (widget.item.isFavourite == false) {
                                          var result = await widget
                                              .onFav(widget.item.id);
                                          if (result == true) {
                                            widget.item.isFavourite =
                                                !widget.item.isFavourite!;
                                          }
                                        } else {
                                          var result = await widget
                                              .onRemoveFav(widget.item.id);
                                          if (result == true) {
                                            widget.item.isFavourite =
                                                !widget.item.isFavourite!;
                                          }
                                        }
                                      })
                                ],
                              ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '${LocaleKeys.title.localize} : ',
                                      style: Styles.mediumText(
                                          color: AppColors.SECONDARY_COLOR)),
                                  TextSpan(
                                    text: widget.item.title,
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                    // maxLines: 1,
                                  ),
                                ]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Sizer(
                                height: 4,
                              ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: '${LocaleKeys.desc.localize} : ',
                                      style: Styles.mediumText(
                                          color: AppColors.SECONDARY_COLOR)),
                                  TextSpan(
                                    text: widget.item.description,
                                    style: Styles.mediumText(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                    // maxLines: 1,
                                  ),
                                ]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Label(
                                text: widget.item.formattedRestTime,
                                style: Styles.mediumText(color: Colors.grey),
                                maxLines: 1,
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const Sizer(),
            const Divider(
              height: 0,
            ),
            const Sizer(),
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: PremiumRequestButton(item: widget.item,),
                      ),
                      const Sizer(width: 5),
                      Expanded(
                        flex: 3,
                        child: RequestButton(item: widget.item,),
                      )
                    ],
                  ),
                  const Sizer(),
                  CallMessageButtons(
                    otherUserId: widget.item.userId ?? '',
                    subcategoryId: widget.item.subCategoryId ?? '',
                    phone: widget.item.phone ?? '',
                    id: widget.item.id,
                    hasReport: true,
                  ),
                ],
              ),
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
