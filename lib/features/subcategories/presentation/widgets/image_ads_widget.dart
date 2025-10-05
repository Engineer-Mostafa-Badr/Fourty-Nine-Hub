import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/widget/common/favorite_icon.dart';
import '../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';

import '../../../../core/widget/SmoothIndicator/scrollig_dots_effect.dart';
import '../../../../core/widget/SmoothIndicator/smooth_page_indicator.dart';

class ImageAdsWidget extends StatefulWidget {
  const ImageAdsWidget({
    super.key,
    required this.images,
    required this.isFavourite,
    required this.onPressedFavorite,
    required this.isVerified,
    required this.isMyAd,
  });

  // final MyAdCard myAdCard;
  final List<String> images;
  final Function() onPressedFavorite;
  final bool isFavourite;
  final bool isVerified;
  final bool isMyAd;

  @override
  State<ImageAdsWidget> createState() => _ImageAdsWidgetState();
}

class _ImageAdsWidgetState extends State<ImageAdsWidget> {
  int currentIndex = 0;

  List<Widget> _buildDotsIndicator() {
    const int maxVisibleDots = 9;
    final int totalDots = widget.images.length;

    if (totalDots <= maxVisibleDots) {
      return List.generate(totalDots, (index) => _buildDot(index));
    }

    List<Widget> dots = [];

    int startIndex, endIndex;

    if (currentIndex <= 4) {
      startIndex = 0;
      endIndex = 8;
    } else if (currentIndex >= totalDots - 5) {
      startIndex = totalDots - 9;
      endIndex = totalDots - 1;
    } else {
      startIndex = currentIndex - 4;
      endIndex = currentIndex + 4;
    }

    for (int i = startIndex; i <= endIndex; i++) {
      dots.add(_buildDot(i));
    }

    return dots;
  }

  Widget _buildDot(int index) {
    bool isActive = index == currentIndex;

    // تحديد حجم النقطة بناءً على المسافة من النقطة النشطة
    double dotSize = 8.0;
    double dotScale = 1.0;

    if (isActive) {
      dotScale = 1.3; // النقطة النشطة
    } else {
      int distance = (index - currentIndex).abs();
      if (distance == 1) {
        dotScale = 1.0; // النقاط المجاورة
      } else if (distance == 2) {
        dotScale = 0.7; // النقاط قبل الأخيرة
      } else {
        dotScale = 0.5; // النقاط البعيدة
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      width: dotSize * dotScale,
      height: dotSize * dotScale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? (context.isDarkMode ? Colors.white : AppColors.SECONDARY_COLOR)
            : (context.isDarkMode
                ? const Color(0x26FFFFFF)
                : Colors.grey.withOpacity(0.3 + (dotScale * 0.4))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Images count: ${widget.images.length}');
    print('Images: ${widget.images}');

    if (widget.images.isEmpty) {
      return SizedBox(
        height: kToolbarHeight * 4,
        child: Center(
          child: Text(
            'لا توجد صور',
            style: TextStyle(
              color: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r),bottomRight: Radius.circular(20.r)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SizedBox(
                height: kToolbarHeight * 4,
                width: double.infinity,
                child: PageView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    print('Page changed from $currentIndex to $value');
                    if (mounted) {
                      setState(() {
                        currentIndex = value;
                      });
                    }
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ImageFromInternet(
                          width: double.infinity,
                          height: kToolbarHeight * 4,
                          image: widget.images[index],
                          defaultLogo: true,
                          fit: BoxFit.fill,
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r),bottomRight: Radius.circular(20.r)),
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
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
              ),

              //! Cover
              IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.red,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.r),bottomRight: Radius.circular(20.r)),
                    border: Border.all(
                      color: context.isDarkMode
                          ? AppColors.LIGHT_COLOR
                          : AppColors.GREY_DARK_COLOR,
                      width: 1,
                    ),
                  ),
                  height: kToolbarHeight * 4,
                  width: double.infinity,
                ),
              ),

              //! Verified
              if (widget.isVerified)
                PositionedDirectional(
                  start: 16,
                  top: 16,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Assets.verified,
                            height: 15,
                            width: 15,
                          ),
                          const SizedBox(width: 4),
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
                ),

              //! Favourite
              if(!widget.isMyAd)PositionedDirectional(
                end: 16,
                top: 16,
                child: FavoriteIcon(isFavourite: widget.isFavourite, onPressedFavorite: widget.onPressedFavorite),
              ),
            ],
          ),
          if (widget.images.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildDotsIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
