import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_cashback_cubit/winners_cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_cashback_view_body.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class WinnersCashbackView extends StatelessWidget {
  const WinnersCashbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.winners.localize,
          actions: [
            BlocBuilder<WinnersCashbackCubit, WinnersCashbackState>(
              builder: (context, state) {
                return Label(
                  text: getSubTitleAppBar(context, state: state),
                  // '${FormatNumbers().formatNumber(state.winners?.totalWinners ?? 0)} ${LocaleKeys.winners.localize} / ${FormatNumbers().formatNumber(state.winners?.totalAmount ?? 0, useArabicNumerals: context.isArabic)} ${context.isArabic ? state.winners?.currencyAr ?? '' : state.winners?.currencyEn ?? ''}',
                  style: Styles.smallText(),
                );
              },
            ),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Image.asset(Assets.cupImage),
            ),
          ],
        ),
      ),
      body: const WinnersCashbackViewBody(),
    );
  }

  String getSubTitleAppBar(BuildContext context,
      {required WinnersCashbackState state}) {
    late final String winners;
    if (state.winnersCashback?.totalWinners == 0) {
      winners = context.isArabic ? 'لا يوجد فائزين' : 'No Winners';
    } else if (state.winnersCashback?.totalWinners == 1) {
      winners = context.isArabic ? 'فائز' : 'Winner';
    } else if (state.winnersCashback?.totalWinners == 2) {
      winners = context.isArabic ? 'فائزين' : 'Winners';
    } else if ((state.winnersCashback?.totalWinners ?? 0) > 2 &&
        (state.winnersCashback?.totalWinners ?? 0) < 11) {
      winners = context.isArabic ? 'فائزين' : 'Winners';
    } else {
      winners = context.isArabic ? 'فائز' : 'Winner';
    }
    if (state.winnersCashback?.totalWinners == 0 ||
        state.winnersCashback == null) {
      return '';
    }
    return '(${FormatNumbers().formatNumber(state.winnersCashback?.totalWinners ?? 0, useArabicNumerals: context.isArabic)} $winners / ${FormatNumbers().formatNumber(state.winnersCashback?.totalAmount ?? 0, useArabicNumerals: context.isArabic)} ${context.isArabic ? state.winnersCashback?.currencyAr ?? '' : state.winnersCashback?.currencyEn ?? ''})';
  }
}
