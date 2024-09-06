import 'package:flutter/material.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class WalletHistoryCard extends StatelessWidget {
  final String title, subTitle;
  final num amount;
  final Function onTap;
  final IconData icon;
  const WalletHistoryCard(
      {super.key,
      required this.title,
      required this.subTitle,
      this.amount = 0,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Label(text: title, style: Styles.mediumText()),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(fontSize: 24),
      ),
      trailing: Icon(
        Icons.line_axis,
        color: amount < 0 ? Colors.red : Colors.green,
      ),
      leading: Container(
          height: kToolbarHeight * .7,
          width: kToolbarHeight * .7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.PRIMARY_COLOR,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 14,
          )),
      onTap: () => onTap(),
    );
  }
}
