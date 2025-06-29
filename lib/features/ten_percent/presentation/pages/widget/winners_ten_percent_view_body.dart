import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/widget/custom_failure_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_grid_view.dart';
import 'package:fourtyninehub/features/ten_percent/presentation/cubit/winners_ten_percent_cubit/winners_ten_percent_cubit.dart';

class WinnersTenPercentViewBody extends StatelessWidget {
  const WinnersTenPercentViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WinnersTenPercentCubit, WinnersTenPercentState>(
      builder: (context, state) {
        if (state.status.isLoading || state.status.isInitial) {
          return const CustomLoading();
        } else if (state.status.isSuccess) {
          return WinnersGridView(
            winners: state.winners!.latestWinners
                .map(
                  (w) => WinnersGridViewModel(
                    image: w.profilePictureKey,
                    name: '${w.firstName} ${w.lastName}',
                    // title: context.isArabic
                    //     ? w.competitionNameAr
                    //     : w.competitionNameEn,
                    date: w.winAt,
                    price: w.winAmount.toString(),
                    currencyAr: state.winners?.currencyAr ?? '***',
                    currencyEn: state.winners?.currencyEn ?? '***',
                  ),
                )
                .toList(),
            hasReachedMax: state.hasReachedMax,
            paginationOnpressed: () {
              context.read<WinnersTenPercentCubit>().getWinners();
            },
          );
        } else {
          return CustomFailureWidget(
            title: getFailureMessage(state.failure!, context),
            onPressed: () {
              context
                  .read<WinnersTenPercentCubit>()
                  .getWinners(isRefresh: true);
            },
          );
        }
      },
    );
  }
}
