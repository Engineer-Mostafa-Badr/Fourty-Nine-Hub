import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit/competition_cubit.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit/competition_state.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/winner_card.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../service_locator/service_locator.dart';

class Winners extends StatelessWidget {
  const Winners({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        centerTitle: false,
        label: LocaleKeys.winners.localize,
      ),
      body: BlocProvider<CompetitionCubit>(
        create: (context) =>serviceLocator()..fetchWinnerCompetition(),
        child: BlocBuilder<CompetitionCubit, CompetitionState>(
          builder: (BuildContext context, state) {
            if (state.status ==CompetitionStates.success) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: .6),
                  itemBuilder: (context, index) {
                    return WinnerCard(
                      isWinner: true,
                      model: state.winner![index],
                    );
                  },
                  itemCount: state.winner?.length,
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
