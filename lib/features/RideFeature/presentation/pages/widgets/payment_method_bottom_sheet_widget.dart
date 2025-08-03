import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class PaymentBottomSheetWidget extends StatefulWidget {
  const PaymentBottomSheetWidget({super.key});

  @override
  State<PaymentBottomSheetWidget> createState() =>
      _PaymentBottomSheetWidgetState();
}

class _PaymentBottomSheetWidgetState extends State<PaymentBottomSheetWidget> {
  String _selectedPayment = 'cash';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          ListTile(
            onTap: () {
      ManageVibration.vibrate();
              setState(() {
                _selectedPayment = 'cash';
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: SvgPicture.asset('assets/icons/cash.svg'),
            title: const Text('Cash',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            trailing: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.PRIMARY_COLOR),
                  shape: BoxShape.circle,
                  color: _selectedPayment == 'cash'
                      ? AppColors.PRIMARY_COLOR
                      : null),
              child: _selectedPayment == 'cash'
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
          ),
          ListTile(
            onTap: () {
      ManageVibration.vibrate();
              setState(() {
                _selectedPayment = 'visa';
              });
            },
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: SvgPicture.asset('assets/icons/visa.svg'),
            title: const Text('Visa',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
            trailing: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                  border: Border.all(color: AppColors.PRIMARY_COLOR),
                  shape: BoxShape.circle,
                  color: _selectedPayment == 'visa'
                      ? AppColors.PRIMARY_COLOR
                      : null),
              child: _selectedPayment == 'visa'
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
          ),
          const SizedBox(height: 15),
          AppButton(
              width: double.infinity,
              label: LocaleKeys.done.tr(),
              onPressed: () {

      ManageVibration.vibrate();
              },
              backColor: AppColors.PRIMARY_COLOR),
        ],
      ),
    );
  }
}