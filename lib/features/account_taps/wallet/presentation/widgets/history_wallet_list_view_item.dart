import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/date_time.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class HistoryWalletListViewItem extends StatelessWidget {
  const HistoryWalletListViewItem(
      {super.key,
      required this.isReceived,
      required this.amount,
      required this.date});

  final bool isReceived;
  final String? amount;
  final String? date;

  @override
  Widget build(BuildContext context) {
    // final bool isReceived = history?.received == true;

    return Padding(
      padding: const EdgeInsets.only(
        right: 16,
        left: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            isReceived
                ? context.isDarkMode
                    ? Assets.historyClockGreenDarkMode
                    : Assets.historyClockGreen
                : context.isDarkMode
                    ? Assets.historyClockRedDarkMode
                    : Assets.historyClockRed,
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text:
                    '${isReceived ? '+' : '-'} ${FormatNumbers().formatNumberByComma(amount, isArabic: context.isArabic)}',
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Label(
                text: formatDateTime(date ?? '', context),
                style: Styles.mediumText(
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
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
