import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_gift_cubit/winners_gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_gift_view_body.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class WinnersGiftView extends StatelessWidget {
  const WinnersGiftView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.winners.localize,
          actions: [
            BlocBuilder<WinnersGiftCubit, WinnersGiftState>(
              builder: (context, state) {
                return Label(
                  text: getSubTitleAppBar(context, state: state),
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
      body: const WinnersGiftViewBody(),
    );
  }

  String getSubTitleAppBar(BuildContext context,
      {required WinnersGiftState state}) {
    late final String winners;
    if (state.winnersGift?.totalWinners == 0) {
      winners = context.isArabic ? 'لا يوجد فائزين' : 'No Winners';
    } else if (state.winnersGift?.totalWinners == 1) {
      winners = context.isArabic ? 'فائز' : 'Winner';
    } else if (state.winnersGift?.totalWinners == 2) {
      winners = context.isArabic ? 'فائزين' : 'Winners';
    } else if ((state.winnersGift?.totalWinners ?? 0) > 2 &&
        (state.winnersGift?.totalWinners ?? 0) < 11) {
      winners = context.isArabic ? 'فائزين' : 'Winners';
    } else {
      winners = context.isArabic ? 'فائز' : 'Winner';
    }
    if (state.winnersGift?.totalWinners == 0 || state.winnersGift == null) {
      return '';
    }
    return '${FormatNumbers().formatNumber(state.winnersGift?.totalWinners ?? 0, useArabicNumerals: context.isArabic)} $winners / ${FormatNumbers().formatNumber(state.winnersGift?.totalAmount ?? 0, useArabicNumerals: context.isArabic)} ${context.isArabic ? state.winnersGift?.currencyAr ?? '' : state.winnersGift?.currencyEn ?? ''}';
  }
}
