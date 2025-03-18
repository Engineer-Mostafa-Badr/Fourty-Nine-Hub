import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';

import '../../common/widgets/stateless/labels/label.dart';
import '../../features/account_taps/wallet/presentation/widgets/button_wallet_and_bill.dart';
import '../../res/style/styles.dart';
import '../localization/locale_keys.g.dart';

class CustomFailureWidget extends StatelessWidget {
  const CustomFailureWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Label(
          text: title,
          style: Styles.headerText(),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          width: double.infinity,
          child: ButtonWalletAndBill(
            icon: const Icon(
              Icons.refresh_sharp,
              color: Colors.white,
            ),
            label: 'Refresh',
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
