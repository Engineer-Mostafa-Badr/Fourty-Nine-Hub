import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/wallet_history_entity.dart';

class WalletHistory extends StatelessWidget {
  final List<WalletHistoryEntity> list;
  const WalletHistory({
    super.key,
    required this.list,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.history,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: _buildHistoryWidget()),
            Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                Sizer(),
                Expanded(
                    child: Label(
                  text: 'Minimum 1002 EGP for personal transaction',
                  style: Styles.mediumText(color: Colors.grey),
                )),
              ],
            ),
            MaterialButton(
              onPressed: () async {
                // if (await LocalAuth().checkBiometrics()) {
                //   context.push(Routes.PAYMENT);
                // }
              },
              color: Colors.red,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              minWidth: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_to_mobile_rounded),
                  Sizer(),
                  Label(
                      text: Labels.withDrawel,
                      style: Styles.mediumText(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryWidget() {
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = list[index];
          return walletActionRow(
              title: '${item.amount}',
              subTitle: item.description,
              onTap: () {},
              icon: FontAwesomeIcons.check);
        },
        separatorBuilder: (context, index) => Container(),
        itemCount: list.length);
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
