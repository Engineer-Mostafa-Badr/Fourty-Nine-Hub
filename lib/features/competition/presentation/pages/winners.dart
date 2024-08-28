import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/competition_cubit.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/notifications_state.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/winner_card.dart';

import '../../../../res/strings/labels.dart';
import '../../../../res/style/styles.dart';

class Winners extends StatelessWidget {
  const Winners({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        centerTitle: false,
        label: Labels.winners,
      ),
      body: BlocBuilder<CompetitionCubit, CompetitionState>(
        builder: (BuildContext context, state) {
          if (state is WinnersSuccessState) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: .6),
                  itemBuilder: (context, index) {
                    return WinnerCard(
                      isWinner: true,
                      model: state.winnersModel.data![index],
                    );
                  },
                itemCount: state.winnersModel.data!.length,
              ),
            );
          } else if (state is WinnersErrorState) {
            return Text(
              state.errMessage,
              style: Styles.mediumText(),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
