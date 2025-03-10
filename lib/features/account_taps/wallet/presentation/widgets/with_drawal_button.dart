import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/payment_cash_out.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class WithDrawalButton extends StatelessWidget {
  const WithDrawalButton({super.key, required this.state});

  final bool state;

  @override
  Widget build(BuildContext context) {
    return state
        ? AppButton(
            label: 'Request Withdrawal',
            color: AppColors.AUTH_CONTAINER_COLOR,
            backColor: AppColors.SECONDARY_COLOR,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PaymentCashOut(),
                ),
              );
              // Navigator.pushNamed(context, Routes.PAYMENT);
            },
          )
        : AppButton(
            label: 'Request Withdrawal',
            backColor: AppColors.SECONDARY_COLOR.withOpacity(0.5),
            onPressed: () {},
          );
  }
}
