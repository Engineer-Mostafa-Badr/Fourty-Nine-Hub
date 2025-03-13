import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/payment_cash_out.dart';

class WithDrawalButton extends StatelessWidget {
  const WithDrawalButton({super.key, required this.state});

  final bool state;

  @override
  Widget build(BuildContext context) {
    return CustomButtonWalletAndGiftAndCashback(
      title: state? 'Request Withdrawal' : 'Request Withdrawal',
      status: !state,
      onPressed: () {
        if(!state) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PaymentCashOut(),
            ),
          );
          // Navigator.pushNamed(context, Routes.PAYMENT);
        }
      },
    );
    // return state
    //     ? CustomButtonWalletAndGiftAndCashback(
    //         title: 'Request Withdrawal',
    //         color: const Color(0xB2F33D49),
    //         onpressed: () async {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const PaymentCashOut(),
    //             ),
    //           );
    //           // Navigator.pushNamed(context, Routes.PAYMENT);
    //         },
    //       )
    //     : CustomButtonWalletAndGiftAndCashback(
    //         title: 'Request Withdrawal',
    //         color: const Color(0xFFF33D49),
    //         onpressed: () {},
    //       );
    // return state
    //     ? AppButton(
    //         label: 'Request Withdrawal',
    //         color: AppColors.AUTH_CONTAINER_COLOR,
    //         backColor: AppColors.SECONDARY_COLOR,
    //         onPressed: () {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const PaymentCashOut(),
    //             ),
    //           );
    //           // Navigator.pushNamed(context, Routes.PAYMENT);
    //         },
    //       )
    //     : AppButton(
    //         label: 'Request Withdrawal',
    //         backColor: AppColors.SECONDARY_COLOR.withOpacity(0.5),
    //         onPressed: () {},
    //       );
  }
}
