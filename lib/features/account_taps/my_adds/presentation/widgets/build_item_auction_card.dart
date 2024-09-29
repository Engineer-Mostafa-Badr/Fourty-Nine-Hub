import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/functions/helper/numbers_helper.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../account_taps/my_adds/domain/entity/my_ads_auction.dart';

class BuildItemAuctionCard extends StatelessWidget {
  final MyAuctionAdsEntity item;
  final bool isVertical;
  const BuildItemAuctionCard({super.key, required this.item, this.isVertical = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.push(Routes.MAZADDETAILS, extra: item.id),
        child: isVertical
            ? _buildVerticalView(context: context)
            : _buildHorizontalView(context: context));
  }

  Widget _buildHorizontalView({required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: SquareImage(
              width: double.infinity,
              radius: 10,
              url: item.ad.images.isNotEmpty
                  ? item.ad.images.first
                  : UIConst.imagePlaceHolder,
            )),
        const Sizer(),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            text: item.ad.title,
                            style: Styles.mediumText(fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                          Label(
                            text: item.ad.desc,
                            style: Styles.mediumText(),
                            maxLines: 2,
                          ),
                        ],
                      )),
                  Sizer(),
                  // IconAppButton(
                  //     size: 20, icon: Icons.favorite_border, onPressed: () {}),
                ],
              ),
              Label(
                //  text: item.ad.address?.address ?? '',
                text: 'address',
                style: Styles.mediumText(),
                maxLines: 1,
              ),
              Sizer(),
              Row(
                children: [
                  Expanded(
                    child: Label(
                      text:
                      NumbersHelper.formatThousands(number: item.ad.price),
                      style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          color: AppColors.SECONDARY_COLOR),
                      maxLines: 1,
                    ),
                  ),
                  Sizer(),
                  Expanded(
                    child: item.adminIgnore
                        ? AppButton(
                        label: 'Details',
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        onPressed: () => context.push(Routes.MAZADDETAILS,
                            extra: item.id))
                        : AppButton(
                        label: 'Bidding',
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        onPressed: () => context.push(Routes.MAZADDETAILS,
                            extra: item.id)),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildVerticalView({required BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SquareImage(
            width: double.infinity,
            radius: 10,
            url: item.ad.images.isNotEmpty
                ? item.ad.images.first
                : UIConst.imagePlaceHolder,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Label(
                text:
                NumbersHelper.formatThousands(number: item.ad.price),
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.SECONDARY_COLOR),
                maxLines: 1,
              ),
            ),
            Sizer(),
            // IconAppButton(
            //     size: 20, icon: Icons.favorite_border, onPressed: () {}),
          ],
        ),
        Label(
          text: item.ad.title,
          style: Styles.mediumText(fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        Label(
          text: item.ad.desc,
          style: Styles.mediumText(),
          maxLines: 2,
        ),
        AppButton(
            label: 'Bidding',
            onPressed: () => context.push(Routes.MAZADDETAILS)),
      ],
    );
  }
}
