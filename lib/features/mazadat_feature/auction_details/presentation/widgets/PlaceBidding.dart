import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/mazadat_feature/auction_list/domain/entities/auction_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/functions/helper/auth_helper.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class PlaceBidding extends StatefulWidget {
  final AuctionEntity auction;
  final Function(num) onPlaced;
  const PlaceBidding(
      {super.key, required this.auction, required this.onPlaced});

  @override
  State<PlaceBidding> createState() => _PlaceBiddingState();
}

class _PlaceBiddingState extends State<PlaceBidding> {
  num bidding = 0;
  @override
  void initState() {
    bidding = widget.auction.currentPrice;
    super.initState();
  }

  _increaseBidding() {
    bidding = bidding + widget.auction.rate;
    setState(() {});
  }

  _decreaseBidding() {
    if (bidding > widget.auction.currentPrice) {
      bidding = bidding - widget.auction.rate;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const BackAppBar(
        label: Labels.bid,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              const Sizer(),
              AppButton(
                label: 'Minus',
                onPressed: () => _decreaseBidding(),
                height: kToolbarHeight,
                width: kToolbarHeight,
                radius: 20,
                widget: Icon(
                  Icons.arrow_drop_down_rounded,
                  size: 40,
                  color: bidding > widget.auction.currentPrice
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Label(
                      text: Labels.yourbid,
                      style: Styles.headerText(color: AppColors.PRIMARY_COLOR)),
                  Label(
                      text: NumbersHelper.formatThousands(number: bidding),
                      style: Styles.headerText(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.PRIMARY_COLOR)),
                  Label(
                      text: NumbersHelper.formatThousands(
                          number: widget.auction.currentPrice),
                      style: Styles.mediumText()),
                ],
              )),
              AppButton(
                label: 'Add',
                onPressed: () => _increaseBidding(),
                radius: 20,
                height: kToolbarHeight,
                width: kToolbarHeight,
                widget: const Icon(
                  Icons.arrow_drop_up_rounded,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const Sizer(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: AppColors.PRIMARY_COLOR,
                size: 14,
              ),
              const Sizer(),
              Label(
                  text: Labels.biddingNote,
                  style: Styles.mediumText(
                    color: AppColors.PRIMARY_COLOR,
                  )),
            ],
          ),
          AppButton(
              margin: 10,
              radius: 15,
              height: kToolbarHeight * .8,
              backColor: bidding > widget.auction.currentPrice
                  ? AppColors.SECONDARY_COLOR
                  : AppColors.SECONDARY_COLOR.withAlpha(150),
              style: Styles.headerText(color: Colors.white),
              label: Labels.placeBidding,
              onPressed: () {
                if (bidding > widget.auction.currentPrice) {
                  if (AuthHelper().isLoggedIn()) {
                    widget.onPlaced(bidding);

                    context.pop();
                  } else {
                    context.push(Routes.LOGIN);
                  }
                }
              }),
        ],
      ),
    );
  }
}
