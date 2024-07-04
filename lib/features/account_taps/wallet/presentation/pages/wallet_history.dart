import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class WalletHistory extends StatelessWidget {
  const WalletHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
              const Sizer(),
              Expanded(
                  child: Label(
                text: 'Minimum 1002 EGP for personal transaction',
                style: Styles.mediumText(color: Colors.grey),
              )),
            ],
          ),
          const Sizer(),
          Expanded(child: _buildHistoryWidget()),
        ],
      ),
    );
  }

  Widget _buildHistoryWidget() {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return walletActionRow(
              title: '-10 L.E',
              subTitle: 'Canceled ride request',
              onTap: () {},
              icon: FontAwesomeIcons.car);
        },
        separatorBuilder: (context, index) => Container(),
        itemCount: 4);
  }

  Widget walletActionRow(
      {required String title,
      required String subTitle,
      required Function onTap,
      required IconData icon}) {
    return ListTile(
      title: Label(text: title, style: Styles.mediumText(fontSize: 12)),
      subtitle: Label(
        text: subTitle,
        style: Styles.mediumText(fontSize: 10),
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
