import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/cashback_cubit/cashback_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

class RequestCashbackButton extends StatelessWidget {
  const RequestCashbackButton({
    super.key,
    required this.target,
    required this.amount,
    required this.isWaitingApproval,
    required this.isLoading,
  });

  final num target;
  final num amount;
  final bool isWaitingApproval;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CustomCircularProgressIndicator(),
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
          label: LocaleKeys.requestTransfer.localize,
          style: Styles.headerText(color: Colors.white, fontSize: 32),
          backColor: amount >= target
              ? const Color(0xffF33D49)
              : const Color(0xB3F33D49),
          onPressed: () {
            if (amount >= target) {
              context.read<CashbackCubit>().requestWithdrawal(context);
            }
          },
        );
      }
    }
  }
}
