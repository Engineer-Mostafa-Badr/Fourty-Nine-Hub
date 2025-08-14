import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_bottom_sheet_phone_is_required.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/request_withdrawal_bottom_sheet_wallet.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class RequestWalletButton extends StatelessWidget {
  const RequestWalletButton({
    super.key,
    required this.target,
    required this.amount,
    required this.isWaitingApproval,
    required this.currancy,
  });

  final num target;
  final num amount;
  final bool isWaitingApproval;
  final String currancy;

  @override
  Widget build(BuildContext context) {
    if (context.read<WalletTwoCubit>().state.buttonRequestLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
      );
    } else {
      if (isWaitingApproval) {
        return AppButton(
          label: LocaleKeys.waitingApproval.localize,
          style: Styles.headerText(
            color: context.isDarkMode ? Colors.black : Colors.white,
            fontSize: 32,
          ),
          onPressed: () {
      ManageVibration.vibrate();
          },
            
          backColor: const Color(0xB3F33D49),
        );
      } else {
        return AppButton(
          label: LocaleKeys.requestWithdraw.localize,
          style: Styles.headerText(color: Colors.white, fontSize: 32),
          backColor: amount >= target
              ? context.isDarkMode
                  ? const Color(0xffF45560)
                  : const Color(0xffF33D49)
              : context.isDarkMode
                  ? const Color(0xB3F45560)
                  : const Color(0xB3F33D49),
          onPressed: () {
      ManageVibration.vibrate();
            if (amount >= target) {
              // اذا كان المبلغ الخاص بي اكبر من اقل سحب
              if (UserCubit.to.state.data?.phone == null ||
                  UserCubit.to.state.data!.phone!.isEmpty) {
                // اذا لم يكن لي رقم هاتف
                bottomSheet(
                  context: context,
                  // isScrollControlled: true,
                  isFloating: true,
                  asAlertDialog: true,
                  widget: const CustomBottomSheetPhoneIsRequired(),
                );
              } else {
                // اذا كان لي رقم هاتف
                bottomSheet(
                  context: context,
                  widget: BlocProvider(
                    create: (context) => serviceLocator<WalletTwoCubit>(),
                    child: RequestWithdrawalBottomSheetWallet(
                      currancy: currancy,
                      totalAmount: amount,
                    ),
                  ),
                );
                // context.read<WalletTwoCubit>().requestWithdrawal(
                //       context,
                //       amount: amount.toString(),
                //       phone: UserCubit.to.state.data!.phone!,
                //       method: '',
                //     );
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
