import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_bottom_sheet_phone_is_required.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class RequestWalletButton extends StatelessWidget {
  const RequestWalletButton({
    super.key,
    required this.target,
    required this.amount,
    required this.isWaitingApproval,
  });

  final num target;
  final num amount;
  final bool isWaitingApproval;

  @override
  Widget build(BuildContext context) {
    if (context.read<WalletTwoCubit>().state.buttonRequestLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      if (isWaitingApproval) {
        return AppButton(
          label: LocaleKeys.waitingApproval.localize,
          style: Styles.headerText(color: Colors.white, fontSize: 32),
          onPressed: () {},
          backColor: const Color(0xB3F33D49),
        );
      } else {
        return AppButton(
          label: LocaleKeys.requestWithdraw.localize,
          style: Styles.headerText(color: Colors.white, fontSize: 32),
          backColor: amount >= target
              ? const Color(0xffF33D49)
              : const Color(0xB3F33D49),
          onPressed: () {
            if (amount >= target) {
              if (UserCubit.to.state.data?.phone == null ||
                  UserCubit.to.state.data!.phone!.isEmpty) {
                bottomSheet(
                  context: context,
                  // isScrollControlled: true,
                  isFloating: true,
                  asAlertDialog: true,
                  widget: const CustomBottomSheetPhoneIsRequired(),
                );
              } else {
                context.read<WalletTwoCubit>().requestWithdrawal(
                      context,
                      amount: amount.toString(),
                      phone: UserCubit.to.state.data!.phone!,
                    );
              }
            }
          },
        );
      }
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
