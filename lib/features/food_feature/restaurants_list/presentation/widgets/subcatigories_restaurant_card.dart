import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../routes/routes.dart';
import '../../domain/entities/restaurant_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubCatigoriesRestaurantCard extends StatelessWidget {
  final RestaurantEntity? item;
  final bool isVert;
  const SubCatigoriesRestaurantCard({super.key, this.isVert = true, this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.push(Routes.RESTAURANTDETAILS, extra: item?.id),
        child: isVert ? _buildVerticalCard() : _buildHorizontalCard());
  }

  Widget _buildVerticalCard() {
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
                      url: item?.image.first ?? "",
                    ),
                  ),
                  Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
                        decoration: BoxDecoration(
                            color: AppColors.SECONDARY_COLOR,
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
                    Sizer(),
                    Label(
                        text: '${item?.rate}',
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
            url: item?.image.first,
          ),
        ),
        Sizer(),
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
                Sizer(),
                Label(
                    text: '${item?.rate} ',
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
