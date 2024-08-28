import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/pages/forgot_password/enter_email_forgot_password_view.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/winner_cubit/winner_cubit.dart';
import 'package:fourtyninehub/features/competition/presentation/cubit/winner_cubit/winner_state.dart';
import 'package:fourtyninehub/features/competition/presentation/view/widgets/winner_card.dart';

import '../../../../core/localization/locale_keys.g.dart';
import '../../../../res/strings/labels.dart';
import '../../../../res/style/styles.dart';

class Winners extends StatelessWidget {
  const Winners({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  BackAppBar(
        centerTitle: false,
        label: LocaleKeys.winners.localize,
      ),
      body: BlocBuilder<WinnerCubit, WinnerState>(
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
            return Center(
              child: Text(state.errMessage,
                textAlign: TextAlign.center,
                style: Styles.mediumText(),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
