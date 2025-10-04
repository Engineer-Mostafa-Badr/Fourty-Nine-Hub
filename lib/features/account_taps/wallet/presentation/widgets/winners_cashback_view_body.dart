import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winner.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_grid_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../core/loading/custom_loading.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_failure_widget.dart';
import '../../../../../res/assets/assets.dart';
import '../cubit/winners_cashback_cubit/winners_cashback_cubit.dart';

class WinnersCashbackViewBody extends StatelessWidget {
  const WinnersCashbackViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WinnersCashbackCubit, WinnersCashbackState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const CustomLoading();
        } else if (state.status.isSuccess) {
          return WinnersGridView(
            winners: state.winnersCashback!.winnersCashback
                .map(
                  (w) => WinnersGridViewModel(
                    image: w.profilePictureKey ?? Assets.profile,
                    name: '${w.firstName} ${w.lastName}',
                    date: w.winAt,
                    price: w.profitAmount.toString(),
                    currencyAr: w.currencyAr,
                    currencyEn: w.currencyEn,
                  ),
                )
                .toList(),
            hasReachedMax: state.hasReachedMax,
            paginationOnpressed: () {
              context.read<WinnersCashbackCubit>().getWinners(context);
            },
            mainAxisExtent: 170,
          );
        } else {
          return CustomFailureWidget(
            title: state.errMessage ?? LocaleKeys.somethingWentWrong.localize,
            onPressed: () {
              ManageVibration.vibrate();
              context.read<WinnersCashbackCubit>().getWinners(context);
            },
          );
        }
      },
    );
  }
}
