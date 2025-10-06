import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_failure_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_gift_cubit/winners_gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winner.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_grid_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class WinnersGiftViewBody extends StatelessWidget {
  const WinnersGiftViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WinnersGiftCubit, WinnersGiftState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const CustomLoading();
        } else if (state.status.isSuccess) {
          return WinnersGridView(
            winners: state.winnersGift!.winnersGift
                .map(
                  (w) => WinnersGridViewModel(
                    image: w.profilePictureKey ?? Assets.profile,
                    name: '${w.firstName} ${w.lastName}',
                    title: context.isArabic
                        ? w.competitionNameAr
                        : w.competitionNameEn,
                    date: w.winAt,
                    price: w.profitAmount.toString(),
                    currencyAr: w.currencyAr,
                    currencyEn: w.currencyEn,
                  ),
                )
                .toList(),
            hasReachedMax: state.hasReachedMax,
            paginationOnpressed: () {
              context.read<WinnersGiftCubit>().getWinners(context);
            },
          );
        } else {
          return CustomFailureWidget(
            title: state.errMessage ?? LocaleKeys.somethingWentWrong.localize,
            onPressed: () {
      ManageVibration.vibrate();
              context.read<WinnersGiftCubit>().getWinners(context);
            },
          );
        }
      },
    );
  }
}
