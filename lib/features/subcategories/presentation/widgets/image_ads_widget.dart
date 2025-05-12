import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class ImageAdsWidget extends StatelessWidget {
  const ImageAdsWidget({
    super.key,
    required this.images,
    required this.isFavourite,
    required this.onPressedFavorite,
  });

  // final MyAdCard myAdCard;
  final List<String> images;
  final Function() onPressedFavorite;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: AlignmentDirectional.topStart,
        children: [
          SizedBox(
            height: kToolbarHeight * 4,
            width: double.infinity,
            child: Swiper(
              itemCount: images.length > 4 ? 4 : images.length,
              onIndexChanged: (i) {},
              outer: false,
              loop: false,
              physics: images.length > 1
                  ? null
                  : const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: Stack(
                  children: [
                    ImageFromInternet(
                      width: double.infinity,
                      image: images[index],
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
              pagination: SwiperPagination(
                  builder: SwiperCustomPagination(builder: (context, config) {
                return const DotSwiperPaginationBuilder(
                        color: AppColors.GREY_DARK_COLOR,
                        activeColor: AppColors.SECONDARY_COLOR,
                        size: 10.0,
                        activeSize: 10.0)
                    .build(context, config);
              })),
            ),
          ),
          PositionedDirectional(
            start: 16,
            top: 16,
            child: IconAppButton(
                size: 32,
                icon: isFavourite == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: AppColors.SECONDARY_COLOR,
                onPressed: onPressedFavorite),
          ),
        ],
      ),
    );
  }
}
