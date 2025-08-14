import 'package:flutter/material.dart';

import '../../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/widget/custom_switch_button.dart';
import '../../../../../../../res/style/styles.dart';
import '../createOrder/cancel_order.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class OfferControl extends StatelessWidget {
  const OfferControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15))),
      child: Column(
        // shrinkWrap: true,
        children: [
          Label(text: 'Finding Drivers...', style: Styles.mediumText()),
          Label(text: 'Your offer', style: Styles.mediumText()),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {

      ManageVibration.vibrate();
                  },
                  child: Label(
                      text: '+3',
                      style: Styles.mediumText(color: Colors.white))),
              Expanded(
                  child:
                      Label(text: '${'20'} EGP', style: Styles.mediumText())),
              ElevatedButton(
                  onPressed: () {

      ManageVibration.vibrate();
                  },
                  child: Label(
                      text: '-3',
                      style: Styles.mediumText(color: Colors.white))),
            ],
          ),
          const Sizer(),
          AppButton(
              label: 'Raise fare',
              onPressed: () {

      ManageVibration.vibrate();
              },
              backColor: Colors.grey[100] ?? Colors.grey,
              textColor: true ? Colors.green : Colors.grey),
          const Sizer(),
          AppButton(
              label: 'Cancel Request',
              onPressed: () {
      ManageVibration.vibrate();
                bottomSheet(
                    widget: const CancelOrder(id: 'ride.sId'),
                    isScrollControlled: true,
                    context: context);
              },
              backColor: Colors.grey[100] ?? Colors.grey,
              textColor: Colors.red),
          const Sizer(),
          Row(
            children: [
              const Icon(
                Icons.rocket_launch,
                size: 14,
              ),
              const Sizer(),
              Expanded(
                  child: Label(
                      text: 'Auto Accept offer of EGP',
                      style: Styles.mediumText())),
              CustomSwitchButton(value: false, onChanged: (v) {})
            ],
          ),
        ],
      ),
    );
  }
}