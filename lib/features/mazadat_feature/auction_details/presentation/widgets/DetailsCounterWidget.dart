import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import '../../../../../common/functions/helper/numbers_helper.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';

import '../../../auction_list/domain/entities/auction_entity.dart';
import 'Biddings.dart';

class DetailsCounterWidget extends StatelessWidget {
  final AuctionEntity auction;
  const DetailsCounterWidget({super.key, required this.auction});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(100),
            bottomRight: Radius.circular(100),
          )),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Label(
                      text: Labels.highestBid,
                      style: Styles.mediumText(color: Colors.grey)),
                  Label(
                      text:
                          '${NumbersHelper.formatThousands(number: auction.currentPrice)} L.E',
                      style: Styles.headerText(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      ...auction.biddings?.map((e) {
                            return InkWell(
                              onTap: () {
                                bottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    widget: Biddings(
                                      biddingsList: auction.biddings ?? [],
                                    ));
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(e.user.image),
                              ),
                            );
                          }).toList() ??
                          [],
                      const Sizer(),
                      TextAppButton(
                          label: '${auction.biddings?.length} ${Labels.bid}',
                          onPressed: () {
                            bottomSheet(
                                context: context,
                                isScrollControlled: true,
                                widget: Biddings(
                                  biddingsList: auction.biddings ?? [],
                                ));
                          })
                    ],
                  )
                ],
              )),
          SizedBox(
            height: kTextTabBarHeight * 2,
            width: kTextTabBarHeight * 2,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    value: auction.restTimeRatio,
                  ),
                ),
                Positioned.fill(
                    child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Label(
                          text: 'Ends At',
                          style: Styles.mediumText(color: Colors.grey)),
                      Label(
                          text: auction.formattedRestTime,
                          style: Styles.headerText())
                    ],
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
