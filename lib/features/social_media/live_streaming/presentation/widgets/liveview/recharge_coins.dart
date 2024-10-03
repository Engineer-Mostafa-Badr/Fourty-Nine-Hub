import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';

class RechargeCoins extends StatefulWidget {
  const RechargeCoins({super.key});

  @override
  State<RechargeCoins> createState() => _RechargeCoinsState();
}

class _RechargeCoinsState extends State<RechargeCoins> {
  int selectedPackage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Label(
          text: 'Recharge',
          style: Styles.headerText(),
        ),
        const Sizer(),
        Label(
          text: 'Select Recharge Amount',
          style: Styles.mediumText(fontWeight: FontWeight.bold),
        ),
        Label(
          text: 'Recharge to get bonus Coins',
          style: Styles.mediumText(color: Colors.grey),
        ),
        const Sizer(),
        _buildPackagesWidget(),
        const Sizer(),
        Label(
          text: 'By continuing, you agree to the virtual items Policy',
          style: Styles.mediumText(color: Colors.grey),
        ),
        AppButton(label: 'Get 🪙 8 (EGP 4.05)', onPressed: () {})
      ],
    );
  }

  Widget _buildPackageItem(
      {required int id, required String title, required String subTitle}) {
    return InkWell(
      onTap: () {
        selectedPackage = id;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: selectedPackage == id
                    ? AppColors.SECONDARY_COLOR
                    : Colors.grey)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  color: AppColors.ACCENT_COLOR,
                ),
                const Sizer(),
                Label(text: title),
              ],
            ),
            Label(text: subTitle)
          ],
        ),
      ),
    );
  }

  Widget _buildPackagesWidget() {
    return SizedBox(
      height: kToolbarHeight * 1.5,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => _buildPackageItem(
              id: index,
              title: '${5 * (index + 1)}',
              subTitle: 'EGP ${5 * (index + 1)}'),
          separatorBuilder: (context, index) => const Sizer(),
          itemCount: 10),
    );
  }
}
