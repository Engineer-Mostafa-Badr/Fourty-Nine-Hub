import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';

class TransferMoneyView extends StatelessWidget {
  const TransferMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.transferMoney,
      ),
      body: ListView(
        children: [
          _buildTransferInfo(context: context),
        ],
      ),
    );
  }

  Widget _buildTransferInfo({required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            text: Labels.paymentAddress,
            style: Styles.mediumText(
                color: AppColors.PRIMARY_COLOR, fontWeight: FontWeight.bold),
          ),
          const Sizer(),
          FormTextField(
            hint: 'Payment Address',
            action: (v) {},
            suffix: SizedBox(
              width: kToolbarHeight * 1.5,
              child: Row(
                children: [
                  Label(
                      text: '@49hub',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  const Sizer(
                    width: 5,
                  ),
                  IconAppButton(
                      onPressed: () => context.push(Routes.Lists),
                      icon: Icons.notes_rounded)
                ],
              ),
            ),
          ),
          const Sizer(),
          FormTextField(
            hint: 'Amount',
            type: TextInputType.number,
            suffix: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Label(
                  text: Labels.currency,
                  style: Styles.mediumText(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Sizer(),
          AppButton(
              label: 'Confirm', onPressed: () => context.push(Routes.PAYMENT)),
        ],
      ),
    );
  }
}
