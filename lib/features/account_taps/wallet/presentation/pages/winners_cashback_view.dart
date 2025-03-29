import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/winners_cashback_cubit/winners_cashback_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/winners_cashback_view_body.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../service_locator/service_locator.dart';

class WinnersCashbackView extends StatelessWidget {
  const WinnersCashbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: BackAppBar(
        label: LocaleKeys.winners.localize,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Image.asset(Assets.cupImage),
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => serviceLocator<WinnersCashbackCubit>()..getWinners(context),
        child: const WinnersCashbackViewBody(),
      ),
    );
  }
}
