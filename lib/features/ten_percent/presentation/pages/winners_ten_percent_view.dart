import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/utils/format_numbers.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../cubit/winners_ten_percent_cubit/winners_ten_percent_cubit.dart';
import 'widget/winners_ten_percent_view_body.dart';
import '../../../../res/assets/assets.dart';
import '../../../../res/style/styles.dart';

class WinnersTenPercentView extends StatelessWidget {
  const WinnersTenPercentView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.winners.localize,
          actions: [
            BlocBuilder<WinnersTenPercentCubit, WinnersTenPercentState>(
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
      body: const WinnersTenPercentViewBody(),
    );
  }



  String getSubTitleAppBar(BuildContext context,
      {required WinnersTenPercentState state}) {
    late final String winners;
    if (state.winners?.totalWinners == 0) {
      winners = context.isArabic ? 'لا يوجد فائزين' : 'No Winners';
    } else if (state.winners?.totalWinners == 1) {
      winners = context.isArabic ? 'فائز' : 'Winner';
    } else if (state.winners?.totalWinners == 2) {
      winners = context.isArabic ? 'فائزين' : 'Winners';
    } else if ((state.winners?.totalWinners ?? 0) > 2 &&
        (state.winners?.totalWinners ?? 0) < 11) {
      winners = context.isArabic ? 'فائزين' : 'Winners';
    } else {
      winners = context.isArabic ? 'فائز' : 'Winner';
    }
    if (state.winners?.totalWinners == 0 || state.winners == null) {
      return '';
    }
    return '${FormatNumbers().formatNumber(state.winners?.totalWinners ?? 0, useArabicNumerals: context.isArabic)} $winners / ${FormatNumbers().formatNumber(state.winners?.totalAmount ?? 0, useArabicNumerals: context.isArabic)} ${context.isArabic ? state.winners?.currencyAr ?? '' : state.winners?.currencyEn ?? ''}';
  }
}
