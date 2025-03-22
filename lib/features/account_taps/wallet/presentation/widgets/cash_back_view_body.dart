import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/cashback_cubit/cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/cashback_histories_list_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/core/widget/icon_and_hint_widget.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_failure_widget.dart';
import 'custom_button_wallet_and_gift_and_cashback.dart';

class CashbackViewBody extends StatelessWidget {
  const CashbackViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: BlocBuilder<CashbackCubit, CashbackState>(
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status.isSuccess) {
            final cashback = state.cashback!;
            final histories = state.histories!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderTotalAccountWidget(
                  balance: cashback.balance.toString(),
                  // state.wallet.realAmount.toString(),
                  type: WalletTypes.balance,
                ),
                const SizedBox(
                  height: 8,
                ),
                IconAndHintWidget(
                  text:
                      '${LocaleKeys.minimum.localize}1002 ${LocaleKeys.transaction.localize}',
                ),
                const SizedBox(
                  height: 8,
                ),
                state.isLoadingButton
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButtonWalletAndGiftAndCashback(
                        title: LocaleKeys.requestTransaction2.localize,
                        status: state.cashback!.balance >= 1002,
                        onPressed: () {
                          context
                              .read<CashbackCubit>()
                              .requestWithdrawal(context);
                        },
                      ),
                const SizedBox(
                  height: 16,
                ),
                Label(
                  text: LocaleKeys.history.localize,
                  style: Styles.headerText(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                  child: CashbackHistoriesListView(
                    histories: histories,
                  ),
                ),
              ],
            );
          } else {
            return CustomFailureWidget(
              title: state.messageFailure ??
                  LocaleKeys.somethingWentWrong.localize,
              onPressed: () {
                context.read<CashbackCubit>().getCashback(context);
              },
            );
          }
        },
      ),
    );
  }
}
