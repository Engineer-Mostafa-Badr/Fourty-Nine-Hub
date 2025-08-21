import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/dynamic/ratio_widget.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class InstallmentOrderCard extends StatelessWidget {
  const InstallmentOrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.INSTALLMENTORDERDETAILS),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ProfileImage(
                  accountId: 0,
                  userId: '',
                ),
                const Sizer(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: 'Farouk  Shahin',
                        style: Styles.mediumText(fontWeight: FontWeight.bold)),
                    Label(text: 'Nike Shoes', style: Styles.mediumText()),
                    Label(
                        text: '2 remaining installments',
                        style: Styles.mediumText()),
                  ],
                )),
                const RatioWidget(value: .8),
              ],
            ),
            const Sizer(),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: '490 EGP',
                  style: Styles.mediumText(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' Monthly',
                  style: Styles.mediumText(color: Colors.grey)),
            ])),
            Label(
                text: 'Comming installment: 13 Jun. 2024',
                style: Styles.mediumText(color: Colors.grey)),
            const Sizer(),
            AppButton(
                label: 'Pay now',
                onPressed: () {
                  ManageVibration.vibrate();
                }),
          ],
        ),
      ),
    );
  }
}
