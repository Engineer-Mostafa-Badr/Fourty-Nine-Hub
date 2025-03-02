import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import 'bottom_sheet/custom_bottom_sheet.dart';
// import 'payment_method_bottom_sheet_widget.dart';
import 'partial_payment_widget.dart';

class FareBottomSheetWidget extends StatelessWidget {
  const FareBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 100,
      children: [
        const TextField(
          autofocus: true,
          cursorHeight: 50,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white,
            filled: true,
            border: UnderlineInputBorder(),
            errorBorder: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(),
            focusedBorder: UnderlineInputBorder(),
            disabledBorder: UnderlineInputBorder(),
            label: Text('EGP',
                style:
                    TextStyle(fontSize: 30, color: AppColors.DARK_GRAY_COLOR)),
            // prefix: Text('EGP',
            //     style: TextStyle(
            //         fontSize: 30, color: AppColors.DARK_GRAY_COLOR)),
          ),
        ),
        AppButton(
            width: double.infinity,
            label: LocaleKeys.done.tr(),
            onPressed: () {
              Navigator.pop(context);
              customBottomSheet(context,
                  child: const PartialPaymentWidget(),
                  title: 'Payment Method');
            },
            backColor: AppColors.PRIMARY_COLOR),
      ],
    );
  }
}
