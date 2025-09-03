import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  // late PageController _pageController;

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController(initialPage: 0);
  //   print('PageController initialized with initial page: 0');
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   super.dispose();
  // }

  // أضف هذه الدالة في _ImageAdsWidgetState:

  List<Widget> _buildDotsIndicator() {
    const int maxVisibleDots = 9;
    final int totalDots = widget.images.length;

    if (totalDots <= maxVisibleDots) {
      // إذا كان العدد أقل من أو يساوي 9، اعرض كل النقاط
      return List.generate(totalDots, (index) => _buildDot(index));
    }

    // إذا كان العدد أكثر من 9، اعرض 9 نقاط فقط
    List<Widget> dots = [];

    int startIndex, endIndex;

    if (currentIndex <= 4) {
      // إذا كان في البداية، اعرض أول 9
      startIndex = 0;
      endIndex = 8;
    } else if (currentIndex >= totalDots - 5) {
      // إذا كان في النهاية، اعرض آخر 9
      startIndex = totalDots - 9;
      endIndex = totalDots - 1;
    } else {
      // في المنتصف، اعرض النقطة النشطة في الوسط مع 4 على كل جانب
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
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Stack(
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
                // clipBehavior: Clip.antiAlias,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(15),
                //   border: Border.all(
                //     color: context.isDarkMode
                //         ? AppColors.LIGHT_COLOR
                //         : AppColors.GREY_DARK_COLOR,
                //     width: 1,
                //   ),
                // ),
                child: PageView.builder(
                  // controller: _pageController,
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
                    // print('Building page $index');
                    // if (index >= widget.images.length) return Container();

                    return Stack(
                      children: [
                        ImageFromInternet(
                          width: double.infinity,
                          height: kToolbarHeight * 4,
                          image: widget.images[index],
                          defaultLogo: true,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.r),
                            topRight: Radius.circular(5.r),
                          ),
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
                    borderRadius: BorderRadius.circular(20),
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
                      padding: const EdgeInsets.all(6),
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
              PositionedDirectional(
                end: 16,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: IconAppButton(
                    size: 32,
                    icon: widget.isFavourite == false
                        ? Icons.favorite_border
                        : Icons.favorite,
                    // shadows: [
                    //   Shadow(
                    //     color: Colors.black,
                    //     offset: const Offset(1, 1),
                    //     blurRadius: 10,
                    //   ),
                    // ],
                    color: AppColors.whiteColor,
                    onPressed: widget.onPressedFavorite,
                  ),
                ),
              ),
            ],
          ),

          //! indicators
          // if (widget.images.length > 1)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 16.0),
          //     child: AnimatedSmoothIndicator(
          //       activeIndex: currentIndex,
          //       count: widget.images.length,
          //       axisDirection: Axis.horizontal,
          //       effect: ScrollingDotsEffect(
          //         activeStrokeWidth: 2.6,
          //         activeDotScale: 1.3,
          //         maxVisibleDots: 9,
          //         radius: 10,
          //         spacing: 5,
          //         dotHeight: 8,
          //         dotWidth: 8,
          //         smallDotScale: 0.7,
          //         fixedCenter: true,
          //         activeDotColor: context.isDarkMode
          //             ? Colors.white
          //             : AppColors.SECONDARY_COLOR,
          //         dotColor: context.isDarkMode
          //             ? const Color(0x26FFFFFF)
          //             : Colors.grey,
          //       ),
          //     ),
          //   ),
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
