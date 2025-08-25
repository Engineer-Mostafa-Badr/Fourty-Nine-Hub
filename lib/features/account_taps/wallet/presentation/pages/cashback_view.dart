import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/cashback_cubit/cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/cash_back_view_body.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../routes/routes.dart';
import '../widgets/custom_winner_appbar.dart';

class CashbackView extends StatelessWidget {
  const CashbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.balance.localize,
          actions: [
            CustomWinnerAppbar(
              onPressed: () {
                ManageVibration.vibrate();
                context.push(Routes.WINNERSCASHBACK);
              },
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            serviceLocator<CashbackCubit>(),
        child: const CashbackViewBody(),
      ),
    );
  }
}
