import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/utils/date_time.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet/wallet_history_entity.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HistoryWalletListViewItem extends StatelessWidget {
  const HistoryWalletListViewItem({super.key, required this.history});

  final WalletHistoryEntity? history;

  @override
  Widget build(BuildContext context) {
    final bool isReceived = history?.received == true;

    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
              isReceived ? Assets.historyClockGreen : Assets.historyClockRed),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text:
                    '${isReceived ? '+' : '-'}${history?.transactionAmount ?? '---'}',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Label(
                text: formatDateTime(history?.createdAt ?? '', context),
                style: Styles.mediumText(
                    fontWeight: FontWeight.w300, fontSize: 20),
              ),
            ],
          ),
          const Spacer(),
          SvgPicture.asset(
              isReceived ? Assets.historyGraphGreen : Assets.historyGraphRed),
        ],
      ),
    );
  }
}
