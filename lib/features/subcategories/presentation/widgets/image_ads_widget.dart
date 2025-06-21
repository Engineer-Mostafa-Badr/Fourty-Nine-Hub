import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../core/widget/SmoothIndicator/scrollig_dots_effect.dart';
import '../../../../core/widget/SmoothIndicator/smooth_page_indicator.dart';

class ImageAdsWidget extends StatefulWidget {
  const ImageAdsWidget({
    super.key,
    required this.images,
    required this.isFavourite,
    required this.onPressedFavorite,
    required this.isVerified,
  });

  // final MyAdCard myAdCard;
  final List<String> images;
  final Function() onPressedFavorite;
  final bool isFavourite;
  final bool isVerified;

  @override
  State<ImageAdsWidget> createState() => _ImageAdsWidgetState();
}

class _ImageAdsWidgetState extends State<ImageAdsWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    int length = widget.images.length;
    if (length > 4) {
      length = 4;
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          // SizedBox(
          //   height: kToolbarHeight * 4,
          //   width: double.infinity,
          //   child: Swiper(
          //     itemCount: widget.images.length > 4 ? 4 : widget.images.length,
          //     onIndexChanged: (i) {},
          //     outer: false,
          //     loop: false,
          //     physics: widget.images.length > 1
          //         ? null
          //         : const NeverScrollableScrollPhysics(),
          //     itemBuilder: (context, index) => Padding(
          //       padding: EdgeInsets.only(bottom: 5.h),
          //       child: Stack(
          //         children: [
          //           ImageFromInternet(
          //             width: double.infinity,
          //             image: widget.images[index],
          //             defaultLogo: true,
          //             fit: BoxFit.cover,
          //             borderRadius: BorderRadius.only(
          //                 topLeft: Radius.circular(5.r),
          //                 topRight: Radius.circular(5.r)),
          //           ),
          //           if (index == 3)
          //             Positioned.fill(
          //                 child: Container(
          //               color: Colors.black.withOpacity(0.8),
          //               alignment: AlignmentDirectional.center,
          //               child: Label(
          //                 text: LocaleKeys.seeAll.localize,
          //                 style: Styles.headerText(
          //                     color: Colors.white,
          //                     decoration: TextDecoration.underline),
          //               ),
          //             ))
          //         ],
          //       ),
          //     ),
          //     pagination: SwiperPagination(
          //         builder: SwiperCustomPagination(builder: (context, config) {
          //       return const DotSwiperPaginationBuilder(
          //               color: AppColors.GREY_DARK_COLOR,
          //               activeColor: AppColors.SECONDARY_COLOR,
          //               size: 10.0,
          //               activeSize: 10.0)
          //           .build(context, config);
          //     })),
          //   ),
          // ),
          SizedBox(
            height: kToolbarHeight * 4,
            width: double.infinity,
            child: PageView.builder(
              onPageChanged: (value) {
                print(value);
                if (value < 3) {
                  setState(() {
                    currentIndex = value;
                  });
                }
              },
              itemCount: length,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Stack(
                  children: [
                    ImageFromInternet(
                      width: double.infinity,
                      image: widget.images[index],
                      defaultLogo: true,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.r),
                          topRight: Radius.circular(5.r)),
                    ),
                    if (index == 3)
                      Positioned.fill(
                          child: Container(
                        color: Colors.black.withOpacity(0.8),
                        alignment: AlignmentDirectional.center,
                        child: Label(
                          text: LocaleKeys.seeAll.localize,
                          style: Styles.headerText(
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        ),
                      ))
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: widget.images.length,
              effect: ScrollingDotsEffect(
                activeStrokeWidth: 2.6,
                activeDotScale: 1.3,
                maxVisibleDots: 5,
                radius: 8,
                spacing: 5,
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: context.isDarkMode
                    ? Colors.white
                    : AppColors.SECONDARY_COLOR,
                dotColor:
                    context.isDarkMode ? const Color(0x26FFFFFF) : Colors.grey,
              ),
            ),
          ),
          if (widget.isVerified)
            PositionedDirectional(
              start: 16,
              top: 16,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      Assets.verified,
                      height: 15,
                      width: 15,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Label(
                      text: context.isArabic ? 'موثق' : 'Verified',
                      style: Styles.smallText(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          PositionedDirectional(
            end: 16,
            bottom: 16,
            child: IconAppButton(
              size: 32,
              icon: widget.isFavourite == false
                  ? Icons.favorite_border
                  : Icons.favorite,
              color: AppColors.SECONDARY_COLOR,
              onPressed: widget.onPressedFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
