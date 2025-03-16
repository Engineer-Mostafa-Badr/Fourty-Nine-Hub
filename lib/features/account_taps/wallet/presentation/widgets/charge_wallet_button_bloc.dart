import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/charge_wallet_cubit/charge_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import '../../../../subscripe/presentation/widgets/amounts.dart';

class ChargeWalletButtonBloc extends StatelessWidget {
  const ChargeWalletButtonBloc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChargeWalletCubit, ChargeWalletState>(
      listener: (context, state) {
        if (state is ChargeWalletSuccess) {
          bottomSheet(
            context: context,
            widget: SubscriptoinAmountsWidget(
              amounts: state.amounts,
              walletType: WalletTypes.mainWallet,
            ),
          );
        }
        if (state is ChargeWalletFailure) {
          showErrorMessage(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ChargeWalletLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return CustomButtonWalletAndGiftAndCashback(
              title: LocaleKeys.chargeWallet.localize,
              color: Colors.green,
              onpressed: () async {
                context.read<ChargeWalletCubit>().showActiveSubscriptionAmounts(
                      walletType: WalletTypes.mainWallet,
                    );
              });
          // return AppButton(
          //   label: LocaleKeys.chargeWallet.localize,
          //   backColor: Colors.green,
          //   color: AppColors.AUTH_CONTAINER_COLOR,
          //   onPressed: () async {
          //     context.read<ChargeWalletCubit>().showActiveSubscriptionAmounts(
          //           walletType: WalletTypes.mainWallet,
          //         );
          //   },
          // );
        }
      },
    );
  }
}
