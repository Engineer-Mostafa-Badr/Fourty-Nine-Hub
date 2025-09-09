import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/cashback_cubit/cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/cashback_histories_list_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/core/widget/icon_and_hint_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/request_cashback_button.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/widget/custom_failure_widget.dart';

class CashbackViewBody extends StatefulWidget {
  const CashbackViewBody({super.key});

  @override
  State<CashbackViewBody> createState() => _CashbackViewBodyState();
}

class _CashbackViewBodyState extends State<CashbackViewBody> {

  @override
  initState(){
    context.read<CashbackCubit>().getCashback(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: BlocConsumer<CashbackCubit, CashbackState>(
        listener: (context, state) {
          if (state.buttonRequestSuccess == true) {
            showSuccessMessage(context, LocaleKeys.requestSentSuccess.localize);
            context.read<CashbackCubit>().getCashback(context, isRefresh: true);
          }
          if (state.buttonRequestSuccess == false) {
            showErrorMessage(context,
                state.messageFailure ?? LocaleKeys.somethingWentWrong.localize);
          }
        },
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const CustomLoading();
          } else if (state.status.isSuccess) {
            final cashback = state.cashback!;
            final histories = state.histories!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                HeaderTotalAccountWidget(
                  balance: cashback.balance.toString(),
                  holdingAmount: 0,
                  currency: context.isArabic
                      ? cashback.currencyAr!
                      : cashback.currencyEn!,
                  // state.wallet.realAmount.toString(),
                  type: WalletTypes.balance,
                ),
                const SizedBox(
                  height: 8,
                ),
                IconAndHintWidget(
                  text:
                      '${LocaleKeys.minimum.localize} ${FormatNumbers().formatNumberByComma('1002', isArabic: context.isArabic)} ${LocaleKeys.transaction.localize}',
                ),
                const SizedBox(
                  height: 8,
                ),
                RequestCashbackButton(
                  amount: state.cashback!.balance,
                  isLoading: state.isLoadingButton,
                  target: 1002,
                  isWaitingApproval: state.cashback?.isWaitingApproval ?? false,
                ),
                // state.isLoadingButton
                //     ? const Center(child: CustomCircularProgressIndicator())
                //     : CustomButtonWalletAndGiftAndCashback(
                //         title: LocaleKeys.requestTransaction2.localize,
                //         status: state.cashback!.balance >= 1002,
                //         onPressed: () {
                //           context
                //               .read<CashbackCubit>()
                //               .requestWithdrawal(context);
                //         },
                //       ),
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
      ManageVibration.vibrate();
                context
                    .read<CashbackCubit>()
                    .getCashback(context, isRefresh: true);
              },
            );
          }
        },
      ),
    );
  }
}
