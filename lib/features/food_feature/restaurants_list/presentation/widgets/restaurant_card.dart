import 'package:flutter/material.dart';
import '../../domain/entities/restaurant.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RestaurantCard extends StatelessWidget {
  final GetAllRestaurantEntity? item;
  final bool isVert;
  const RestaurantCard({super.key, this.isVert = true, this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.push(Routes.RESTAURANTDETAILS, extra: item),
        child: isVert ? _buildVerticalCard(context) : _buildHorizontalCard());
  }

  Widget _buildVerticalCard(BuildContext context) {
    return SizedBox(
      width: kToolbarHeight * 2.5,
      height: kToolbarHeight * 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      radius: 5,
                      url: item?.restaurantMedia?.first.mediaKey,
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
                        decoration: BoxDecoration(
                            color: AppColors.getRedColor(context),
                            borderRadius: BorderRadius.circular(5)),
                        child: Label(
                            text: '20% off some items',
                            style: Styles.smallText(color: Colors.white)),
                      ))
                ],
              )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: item?.name ?? "",
                  style: Styles.mediumText(fontWeight: FontWeight.w400),
                ),
                Label(
                  text: "", // item?.description??"",
                  style: Styles.mediumText(
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.ACCENT_COLOR,
                    ),
                    const Sizer(),
                    Label(
                        text: '${item?.totalRating}',
                        style: Styles.mediumText(fontWeight: FontWeight.w500)),
                    Label(
                        text: '(${item?.numberOfReviews}+)',
                        style: Styles.mediumText()),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCard() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: kToolbarHeight,
          width: kToolbarHeight,
          child: SquareImage(
            radius: 5,
            url: item?.restaurantMedia?.first.mediaKey,
          ),
        ),
        const Sizer(),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: item?.name ?? "",
              style: Styles.mediumText(fontWeight: FontWeight.w400),
            ),
            Label(
                text: "", //item?.description,
                style: Styles.mediumText(color: Colors.grey)),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.ACCENT_COLOR,
                ),
                const Sizer(),
                Label(
                    text: '${item?.totalRating} ',
                    style: Styles.mediumText(fontWeight: FontWeight.w500)),
                Label(
                    text: '(${item?.numberOfReviews}+)',
                    style: Styles.mediumText()),
              ],
            ),
          ],
        ))
      ],
    );
  }
}
