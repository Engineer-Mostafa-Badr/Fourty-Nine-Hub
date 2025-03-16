import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/payment_cash_out.dart';

class WithDrawalButton extends StatelessWidget {
  const WithDrawalButton({super.key, required this.state, required this.amount, required this.phone});

  final bool state;
  final String amount;
  final String phone;

  @override
  Widget build(BuildContext context) {
    if(context.read<WalletTwoCubit>().buttonRequestLoading){
      return const Center(child: CircularProgressIndicator(),);
    } else {
      return CustomButtonWalletAndGiftAndCashback(
        title: state? 'Request Withdrawal' : 'Request Withdrawal',
        status: state,
        onPressed: () {
          if(state) {
            context.read<WalletTwoCubit>().requestWithdrawal(
              context,
              amount: amount,
              phone: phone,
            );
          }
        },
      );
    }

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
