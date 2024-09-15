import 'package:flutter/material.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletHistoryCard extends StatelessWidget {
  final String title, subTitle;
  final bool? amount;
  final Function? onTap;
  final IconData icon;

  const WalletHistoryCard(
      {super.key,
      required this.title,
      required this.subTitle,
      this.amount = false,
      required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Label(
        text: amount! ? title : '- $title',
        style: Styles.mediumText(),
      ),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(
            fontSize: 24, color: AppColors.GREY_NORMAL_COLOR),
      ),
      trailing: Icon(
        Icons.line_axis,
        color: amount! ? AppColors.WHATS_APP_COLOR : AppColors.SECONDARY_COLOR,
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
      onTap: () => onTap!(),
    );
  }
}
